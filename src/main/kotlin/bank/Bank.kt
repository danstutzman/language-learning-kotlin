package com.danstutzman.bank

import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.GlossRows
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs
import com.danstutzman.bank.es.GENDER_TO_DESCRIPTION
import com.danstutzman.bank.es.Inf
import com.danstutzman.bank.es.InfCategory
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.Nonverb
import com.danstutzman.bank.es.NonverbList
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
var SPANISH_PUNCTUATION_REGEX = Regex("[ .,;$?\u00BF\u00A1()-]+")

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

  val infList         = InfList(db)
  val regVPatternList = RegVPatternList()
  val nonverbList     = NonverbList(db)
  val uniqVList       = UniqVList(infList, db)
  val stemChangeList  = StemChangeList(infList, db)
  val vCloud          = VCloud(infList, uniqVList,
                          regVPatternList, stemChangeList)


  fun getCardDownloads(): Map<String, List<CardDownload>> {
    val paragraphIds =
      db.selectAllParagraphs().filter { it.enabled }.map { it.paragraphId }
    val goalCardIds =
      db.selectGoalsWithParagraphIdIn(paragraphIds).map { it.cardId }
    val allCardIds = (db.selectCardEmbeddingsWithLongerCardIdIn(goalCardIds)
      .map { it.shorterCardId } + goalCardIds).distinct()
    val cardDownloads = db.selectCardRowsWithCardIdIn(allCardIds).map {
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

  fun splitEsPhrase(esPhrase: String): List<String> =
    esPhrase.split(SPANISH_PUNCTUATION_REGEX).flatMap { word ->
      if (word == "") listOf<String>() else listOf(word)
    }

  fun interpretEsWord(word: String): List<Interpretation> =
    nonverbList.interpretEsLower(word.toLowerCase()) +
      vCloud.interpretEsLower(word.toLowerCase())

  fun saveCardUpdates(cardUpdates: List<CardUpdate>) {
    for (cardUpdate in cardUpdates) {
      db.updateCard(cardUpdate)
    }
  }
}