package com.danstutzman.bank

import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.IdSequence
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs
import com.danstutzman.bank.es.Entry
import com.danstutzman.bank.es.EntryList
import com.danstutzman.bank.es.GENDER_TO_DESCRIPTION
import com.danstutzman.bank.es.Goal
import com.danstutzman.bank.es.Inf
import com.danstutzman.bank.es.InfCategory
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPattern
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.StemChange
import com.danstutzman.bank.es.StemChangeList
import com.danstutzman.bank.es.StemChangeV
import com.danstutzman.bank.es.Tense
import com.danstutzman.bank.es.UniqV
import com.danstutzman.bank.es.UniqVList
import com.danstutzman.bank.es.VCloud
import com.danstutzman.db.Db
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.FileReader
import java.io.StringReader
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response
import java.io.File

const val DELAY_THRESHOLD = 100000

data class CardRow(
  val cardId: Int,
  val type: String,
  val key: String,
  val childrenCardIds: List<Int>,
  val glossRows: List<GlossRow>,
  val quizQuestion: String
) {}

data class SkillRow(
  val cardId: Int,
  val delay: Int,
  val endurance: Int,
  val lastSeenAt: Int,
  val mnemonic: String
) {}

data class SkillsUpload(
  val skillExports: List<SkillExport>?
) {}

data class SkillExport(
  val cardType: String,
  val cardKey: String,
  val delay: Int,
  val endurance: Int,
  val lastSeenAt: Int,
  val mnemonic: String
) {}

data class SkillsExport(
  val skillExports: List<SkillExport>
) {}

fun descendantsOf(cards: Iterable<Card>): Set<Card> {
  val children = mutableSetOf<Card>()
  for (card in cards) {
    children.addAll(card.getChildrenCards())
  }
  if (children.size > 0) {
    children.addAll(descendantsOf(children))
  }
  return children
}

fun cardType(card: Card): String = card::class.java.name.split(".").last()


class Bank(
  val skillsExportFile: File,
  val db: Db
) {
  val logger: Logger = LoggerFactory.getLogger("Webapp.kt")

  val cardIdSequence  = IdSequence()
  val infList         = InfList(cardIdSequence)
  val regVPatternList = RegVPatternList(cardIdSequence)
  val entryList       = EntryList(cardIdSequence, db)
  val uniqVList       = UniqVList(cardIdSequence, infList)
  val stemChangeList  = StemChangeList(cardIdSequence, infList)
  val vCloud          = VCloud(cardIdSequence, infList, uniqVList,
                          regVPatternList, stemChangeList)

  val iClauses: List<Card> = db.selectAllGoals().flatMap {
    if (it.es == "") {
      listOf<Card>()
    } else {
      try {
        listOf(parseEs(it.es, it.enFreeText))
      } catch (e: CantMakeCard) {
        System.err.println(e)
        System.err.println(it)
        listOf<Card>()
      }
    }
  }
  val iClauseByKey = iClauses.map { Pair(it.getKey(), it) }.toMap()

  val cards = iClauses.toSet() + descendantsOf(iClauses)
  val cardRows = cards.map {
    val type = it.javaClass.name.split('.').last()
    CardRow(
      it.cardId,
      type,
      it.getKey(),
      it.getChildrenCards().map { it.cardId },
      it.getGlossRows(),
      getPrompt(it)
    )
  }
  val assertion = assertUniqPrompts(cardRows)

  val skillsExport: SkillsExport = Gson()
    .fromJson(skillsExportFile.readText(), SkillsExport::class.java)

  fun getCardsAndSkills(): Map<String, Any> {
    val skillExportByCardTypeAndKey = skillsExport.skillExports.map {
      Pair(Pair(it.cardType, it.cardKey), it)
    }.toMap()

    val skillRows = cards.map {
      val skillExport = 
        skillExportByCardTypeAndKey[Pair(cardType(it), it.getKey())]
      if (skillExport != null) {
        SkillRow(it.cardId,
          skillExport.delay,
          skillExport.endurance,
          skillExport.lastSeenAt,
          skillExport.mnemonic)
      } else {
        SkillRow(it.cardId,
          if (it.getChildrenCards().size == 0)
            DELAY_THRESHOLD else DELAY_THRESHOLD * 2,
          0,
          0,
          "")
      }
    }

    return linkedMapOf(
      "cards" to cardRows,
      "skills" to skillRows
    )
  }

  fun parseEs(es: String, prompt: String): Card {
    val cards = es.toLowerCase().split(" ").map { word ->
      entryList.byEs(word) ?:
      uniqVList.byEs(word) ?:
      vCloud.byEs(word) ?:
      throw CantMakeCard("Can't find card for es ${word}")
    }
    return Goal(cardIdSequence.nextId(), prompt, cards)
  }

  fun saveSkillsExport(skillsUpload: SkillsUpload) {
    skillsExportFile.writeText(
      GsonBuilder().setPrettyPrinting().create().toJson(
        SkillsExport(skillsUpload.skillExports!!)))
  }

  fun getEnVerbFor(inf: Inf, number: Int, person: Int, tense: Tense): String =
    when (tense) {
      Tense.PRES ->
        inf.enPresent +
        EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
      Tense.PRET -> inf.enPast
    } + if (inf.enDisambiguation != null) " (${inf.enDisambiguation})" else ""

  fun getPrompt(card: Card): String = when (card) {
    is Entry -> card.en
    is Goal -> card.prompt
    is Inf -> if (card.enDisambiguation != null)
      "to ${card.enPresent} (${card.enDisambiguation})"
      else "to ${card.enPresent}"
    is RegV ->
      "(${card.pattern.getEnPronoun()}) " +
      getEnVerbFor(card.inf,
        card.pattern.number, card.pattern.person, card.pattern.tense)
    is RegVPattern -> {
      val enPronoun = "(" + EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[
        Pair(card.number, card.person)]!! + ")"
      val enVerbSuffix = EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[
        Pair(card.number, card.person)]!!
      when (card.tense) {
        Tense.PRES -> when (card.infCategory) {
          InfCategory.AR   -> "${enPronoun} talk${enVerbSuffix} (hablar)"
          InfCategory.ER   -> "${enPronoun} eat${enVerbSuffix} (comer)"
          InfCategory.ERIR -> "${enPronoun} eat${enVerbSuffix} (comer)"
          InfCategory.IR   -> "${enPronoun} live${enVerbSuffix} (vivir)"
          InfCategory.STEMPRET -> throw RuntimeException("Shouldn't happen")
        }
        Tense.PRET -> when (card.infCategory) {
          InfCategory.AR   -> "${enPronoun} talked (hablar)"
          InfCategory.ER   -> "${enPronoun} ate (comer)"
          InfCategory.ERIR -> "${enPronoun} ate (comer)"
          InfCategory.IR   -> "${enPronoun} lived (vivir)"
          InfCategory.STEMPRET -> "${enPronoun} had (tener)"
        }
      }
    }
    is UniqV -> "(" + EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[
        Pair(card.number, card.person)] + ") " + getPrompt(card.inf)
    is StemChange -> "Stem change for ${card.inf.es} in ${card.tense}"
    is StemChangeV ->
      "(${card.pattern.getEnPronoun()}) " + getEnVerbFor(
        card.stemChange.inf,
        card.pattern.number,
        card.pattern.person,
        card.pattern.tense)
    else -> throw RuntimeException("Unexpected card type ${card::class}")
  }

  fun assertUniqPrompts(cardRows: List<CardRow>) {
    val cardRowByPrompt = mutableMapOf<String, CardRow>()
    for (cardRow in cardRows) {
      val oldCard = cardRowByPrompt.get(cardRow.quizQuestion)
      if (oldCard != null) {
        throw RuntimeException("Key ${cardRow.quizQuestion} has two values: " +
          "${oldCard} and ${cardRow}")
      }
      cardRowByPrompt.put(cardRow.quizQuestion, cardRow)
    }
  }
}