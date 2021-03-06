package com.danstutzman.bank

import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.GlossRows
import com.danstutzman.bank.ar.ArCompoundNounCloud
import com.danstutzman.bank.ar.ArNonverbList
import com.danstutzman.bank.ar.ArNounCaseList
import com.danstutzman.bank.ar.ArNounList
import com.danstutzman.bank.ar.ArStemChangeList
import com.danstutzman.bank.ar.ArSuffixPronounList
import com.danstutzman.bank.ar.ArUniqVList
import com.danstutzman.bank.ar.ArVCloud
import com.danstutzman.bank.ar.ArVPatternList
import com.danstutzman.bank.ar.ArVRootList
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs
import com.danstutzman.bank.es.GENDER_TO_DESCRIPTION
import com.danstutzman.bank.es.Inf
import com.danstutzman.bank.es.InfCategory
import com.danstutzman.bank.es.Nonverb
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPattern
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.StemChange
import com.danstutzman.bank.es.StemChangeList
import com.danstutzman.bank.es.StemChangeV
import com.danstutzman.bank.es.UniqV
import com.danstutzman.bank.es.UniqVList
import com.danstutzman.bank.fr.FrInfList
import com.danstutzman.bank.fr.FrRegVPatternList
import com.danstutzman.bank.fr.FrStemChangeList
import com.danstutzman.bank.fr.FrUniqVList
import com.danstutzman.bank.fr.FrVCloud
import com.danstutzman.db.CardUpdate
import com.danstutzman.db.Db
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.FileReader
import java.io.StringReader
import kotlin.collections.Map
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response
import java.io.File

const val DELAY_THRESHOLD = 100000

data class CardDownload(
  val cardId: Int,
  val glossRows: List<GlossRow>,
  val lastSeenAt: Int?,
  val leafIdsCsv: String,
  val mnemonic: String,
  val prompt: String,
  val stage: Int
) {}


class Bank(
  val db: Db
) {
  val logger: Logger = LoggerFactory.getLogger("Bank.kt")

  val arNonverbList = ArNonverbList(db)
  val arNounList    = ArNounList(db)
  val arCompoundNounCloud = ArCompoundNounCloud(arNounList, ArNounCaseList(),
    ArSuffixPronounList())
  val arRootList = ArVRootList(db)
  val arVCloud      = ArVCloud(arRootList, ArVPatternList(),
    ArStemChangeList(arRootList, db), ArUniqVList(arRootList, db))
  val esInfList     = com.danstutzman.bank.es.InfList(db)
  val esNonverbList = com.danstutzman.bank.es.NonverbList(db)
  val esVCloud      = com.danstutzman.bank.es.VCloud(
    esInfList, UniqVList(esInfList, db), RegVPatternList(),
    StemChangeList(esInfList, db))
  val frNonverbList = com.danstutzman.bank.fr.NonverbList(db)
  val frInfList     = FrInfList(db)
  val frVCloud      = FrVCloud(
    frInfList, FrUniqVList(frInfList, db), FrRegVPatternList(),
    FrStemChangeList(frInfList, db))

  fun getCardDownloads(lang: String): Map<String, List<CardDownload>> {
    val paragraphIds = db.paragraphsTable.selectForLang(lang)
      .filter { it.enabled }.map { it.paragraphId }
    val goalCardIds =
      db.goalsTable.selectWithParagraphIdIn(paragraphIds).map { it.cardId }
    val allCardIds = (db.cardEmbeddingsTable
      .selectWithLongerCardIdIn(goalCardIds)
      .map { it.shorterCardId } + goalCardIds
     ).distinct()
    val cardDownloads = db.cardsTable.selectWithCardIdIn(allCardIds).map {
      CardDownload(
        cardId = it.cardId,
        glossRows = GlossRows.expandGlossRows(it.glossRowsJson),
        lastSeenAt = it.lastSeenAt,
        leafIdsCsv = it.leafIdsCsv,
        mnemonic = it.mnemonic,
        prompt = it.prompt,
        stage = it.stage)
    }
    assertUniqPrompts(cardDownloads)
    return linkedMapOf("cardDownloads" to cardDownloads)
  }

  fun assertUniqPrompts(cardDownloads: List<CardDownload>) {
    val cardDownloadByPrompt = mutableMapOf<String, CardDownload>()
    for (cardDownload in cardDownloads) {
      val oldCard = cardDownloadByPrompt.get(cardDownload.prompt)
      if (oldCard != null) {
        throw RuntimeException(
          "Key ${cardDownload.prompt} has two values: " +
          "${oldCard} and ${cardDownload}")
      }
      cardDownloadByPrompt.put(cardDownload.prompt, cardDownload)
    }
  }

  fun splitL2Phrase(lang: String, l2Phrase: String): List<String> =
    when(lang) {
      "ar" -> l2Phrase
        .split(Regex("[ ]+"))
        .filterNot { it == "" }
      "es" -> l2Phrase
        .split(Regex("[ .,;$?!\u00BF\u00A1()'\"-]+"))
        .filterNot { it == "" }
      "fr" -> l2Phrase
        .split(Regex("[^a-zàâçéèêëîïôûùüÿæœ']+", RegexOption.IGNORE_CASE))
        .flatMap { 
          // combined="m'appelle" becomes ["m'", "appelle"]
          val match = Regex("^([djmt]')(.+)$").find(it)
          if (match != null) listOf(match.groupValues[1], match.groupValues[2])
          else listOf(it)
        }
        .filterNot { it == "" }
      else -> throw RuntimeException("Unknown lang ${lang}")
    }

  fun interpretL2Word(lang: String, word: String): List<Interpretation> =
    if (lang == "ar")
      arNonverbList.interpretArBuckwalter(word) +
      arCompoundNounCloud.interpretArBuckwalter(word) +
      arVCloud.interpretArBuckwalter(word)
    else if (lang == "es")
      esNonverbList.interpretEsLower(word.toLowerCase()) +
      esVCloud.interpretEsLower(word.toLowerCase())
    else if (lang == "fr")
      frNonverbList.interpretFrLower(word.toLowerCase()) +
      frVCloud.interpretFrLower(word.toLowerCase())
    else throw RuntimeException("Unknown lang ${lang}")

  fun saveCardUpdates(cardUpdates: List<CardUpdate>) {
    for (cardUpdate in cardUpdates) {
      db.cardsTable.update(cardUpdate)
    }
  }
}