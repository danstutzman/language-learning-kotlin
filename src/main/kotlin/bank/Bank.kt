package com.danstutzman.bank

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.IdSequence
import com.danstutzman.bank.es.DetList
import com.danstutzman.bank.es.IClause
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.NList
import com.danstutzman.bank.es.NPList
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.StemChange
import com.danstutzman.bank.es.StemChangeList
import com.danstutzman.bank.es.UniqVList
import com.danstutzman.bank.es.VCloud
import com.esotericsoftware.yamlbeans.YamlReader
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.FileReader
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response
import java.io.File

const val DELAY_THRESHOLD = 100000

data class IClausesYaml (
  val iClauses: List<IClauseYaml>? = null
) {}

data class IClauseYaml (
  var agent: String? = null,
  var v: String? = null
) {}

data class CardRow(
  val cardId: Int,
  val type: String,
  val key: String,
  val childrenCardIds: List<Int>,
  val glossRows: List<GlossRow>,
  val esWords: List<String>,
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
  val iClausesYamlFile: File
) {
  val logger: Logger = LoggerFactory.getLogger("Webapp.kt")

  val cardIdSequence  = IdSequence()
  val infList         = InfList(cardIdSequence)
  val regVPatternList = RegVPatternList(cardIdSequence)
  val nList           = NList(cardIdSequence)
  val detList         = DetList(cardIdSequence)
  val uniqVList       = UniqVList(cardIdSequence, infList)
  val npList          = NPList(cardIdSequence)
  val stemChangeList  = StemChangeList(cardIdSequence, infList)
  val vCloud          = VCloud(cardIdSequence, infList, uniqVList,
                          regVPatternList, stemChangeList)

  val reader = YamlReader(FileReader(iClausesYamlFile))
  val ignored =
    reader.getConfig().setClassTag("IClause", IClauseYaml::class.java)
  val iClausesYaml = reader.read(List::class.java) as List<IClauseYaml>
  val iClauses = iClausesYaml.map { yaml ->
    IClause(
      cardIdSequence.nextId(),
      npList.byEs(yaml.agent!!),
      vCloud.byEs(yaml.v!!)
    )
  }
  val iClauseByKey = iClauses.map { Pair(it.getKey(), it) }.toMap()
  val iClauseByQuestion =
    Assertions.assertUniqKeys(iClauses.map { Pair(it.getQuizQuestion(), it) })

  val cards = iClauses.toSet() + descendantsOf(iClauses)
  val cardRows = cards.map {
    val type = it.javaClass.name.split('.').last()
    CardRow(
      it.cardId,
      type,
      it.getKey(),
      it.getChildrenCards().map { it.cardId },
      it.getGlossRows(),
      it.getEsWords(),
      it.getQuizQuestion()
    )
  }

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

  fun saveSkillsExport(skillsUpload: SkillsUpload) {
    skillsExportFile.writeText(
      GsonBuilder().setPrettyPrinting().create().toJson(
        SkillsExport(skillsUpload.skillExports!!)))
  }
}
