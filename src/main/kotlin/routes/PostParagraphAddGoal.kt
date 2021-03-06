package com.danstutzman.routes

import com.danstutzman.bank.Bank
import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.ArNonverb
import com.danstutzman.db.Db
import com.danstutzman.db.CardEmbedding
import com.danstutzman.db.CardRow
import com.danstutzman.db.EsNonverb
import com.danstutzman.db.FrNonverb
import com.danstutzman.db.Goal
import com.google.gson.GsonBuilder

val STAGE0_NOT_READY_TO_TEST = 0
val STAGE1_READY_TO_TEST = 1
val STAGE5_SAME_AS_ENGLISH = 5

data class WordDisambiguation (
  val type: String,
  val exists: Boolean,
  val leafIds: String?,
  val en: String?,
  val enDisambiguation: String?,
  val enPlural: String?,
  val es: String?,
  val frMixed: String?,
  val arBuckwalter: String?
)

private val gsonBuilder = GsonBuilder().create()

private fun convertGlossRowsToJson(glossRows: List<GlossRow>): String =
  gsonBuilder.toJson(glossRows)
    .replace("\\u003e", ">")
    .replace("\\u003c", "<")
    .replace("\\u0027", "'")
    .replace("\\u0026", "&")

fun PostParagraphAddGoal(db: Db, lang: String, paragraphId: Int, goalEn: String,
  goalL2: String, wordDisambiguations: List<WordDisambiguation>) {
  if (goalEn == "") {
    throw RuntimeException("En param can't be blank")
  }

  val bank = Bank(db)
  val cardCreators = mutableListOf<CardCreator>()
  for ((wordNum, word) in bank.splitL2Phrase(lang, goalL2).withIndex()) {
    val disambiguation = wordDisambiguations[wordNum]
    val interpretations: List<Interpretation> = bank.interpretL2Word(lang, word)
    if (disambiguation.exists) {
      val interpretation = interpretations.find {
          it.type == disambiguation.type && it.cardCreator != null &&
          it.cardCreator.serializeLeafIds() == disambiguation.leafIds
        } ?: throw RuntimeException(
          "Can't find ${disambiguation.type} with ${disambiguation.leafIds}")
      cardCreators.add(interpretation.cardCreator!!)
    } else {
      if (disambiguation.type == "ArNonverb") {
        val row = db.arNonverbsTable.insert(ArNonverb(
          0, disambiguation.en!!, disambiguation.arBuckwalter!!))
        cardCreators.add(com.danstutzman.bank.ar.ArNonverb(
          row.leafId, row.arBuckwalter, row.en))
      } else if (disambiguation.type == "EsNonverb") {
        val row = db.esNonverbsTable.insert(EsNonverb(
          0, disambiguation.en!!, disambiguation.enDisambiguation!!,
          blankToNull(disambiguation.enPlural!!), disambiguation.es!!))
        cardCreators.add(com.danstutzman.bank.es.Nonverb(
          row.leafId, row.esMixed, row.en,
          blankToNull(row.enDisambiguation)))
      } else if (disambiguation.type == "FrNonverb") {
        val row = db.frNonverbsTable.insert(FrNonverb(
          0, disambiguation.en!!, disambiguation.frMixed!!))
        cardCreators.add(com.danstutzman.bank.fr.Nonverb(
          row.leafId, row.frMixed, row.en))
      } else {
        throw RuntimeException("Can't create ${disambiguation.type}")
      }
    }
  }

  createGoal(goalL2, cardCreators, goalEn, db, paragraphId)
}

private fun createGoal(goalL2:String, cardCreators: List<CardCreator>,
  goalEn: String, db:Db, paragraphId:Int) {
  if (cardCreators.size > 0) {
    val cardRowsForWords = cardCreators.map { cardCreator ->
      val glossRows = cardCreator.getGlossRows()
      CardRow(
        cardId = 0,
        glossRowsJson = convertGlossRowsToJson(glossRows),
        lastSeenAt = null,
        leafIdsCsv = glossRows.map { it.leafId }.joinToString(","),
        mnemonic = "",
        prompt = cardCreator.getPrompt(),
        stage = if (glossRows.size == 1) {
            if (glossRows[0].l2 == glossRows[0].en) STAGE5_SAME_AS_ENGLISH
            else STAGE1_READY_TO_TEST
          }
          else STAGE0_NOT_READY_TO_TEST
      )
    }
    val cardRowsForWordsChildren =
      cardCreators.flatMap { it.getChildCardCreators() }.map { cardCreator ->
        val glossRows = cardCreator.getGlossRows()
        CardRow(
          cardId = 0,
          glossRowsJson = convertGlossRowsToJson(glossRows),
          lastSeenAt = null,
          leafIdsCsv = glossRows.map { it.leafId }.joinToString(","),
          mnemonic = "",
          prompt = cardCreator.getPrompt(),
          stage = if (glossRows.size == 1) STAGE1_READY_TO_TEST
            else STAGE0_NOT_READY_TO_TEST
        )
      }
    val glossRows = cardCreators.flatMap { it.getGlossRows() }
    val cardRowForGoal = CardRow(
      cardId = 0,
      glossRowsJson = convertGlossRowsToJson(glossRows),
      lastSeenAt = null,
      leafIdsCsv = glossRows.map { it.leafId }.joinToString(","),
      mnemonic = "",
      prompt = goalEn,
      stage = if (glossRows.size == 1) STAGE1_READY_TO_TEST
        else STAGE0_NOT_READY_TO_TEST
    )
    val allCardRows =
      listOf(cardRowForGoal) + cardRowsForWords + cardRowsForWordsChildren
    db.cardsTable.insert(allCardRows)

    val leafIdsCsvCardIdPairs = db.cardsTable.selectLeafIdsCsvCardIdPairs()
    val leafIdCsvToCardId = leafIdsCsvCardIdPairs.toMap()

    val cardEmbeddings = mutableListOf<CardEmbedding>()
    for (outerPair in leafIdsCsvCardIdPairs) {
      val outerLeafIdsCsv = outerPair.first
      val outerCardId = outerPair.second
      for (innerCardRow in allCardRows) {
        val innerCardId = leafIdCsvToCardId[innerCardRow.leafIdsCsv]!!
        cardEmbeddings.addAll(
          findCardEmbeddings(outerLeafIdsCsv, innerCardRow.leafIdsCsv).map {
            CardEmbedding(
              outerCardId,
              innerCardId,
              it.firstLeafIndex,
              it.lastLeafIndex)
          })
        cardEmbeddings.addAll(
          findCardEmbeddings(innerCardRow.leafIdsCsv, outerLeafIdsCsv).map {
            CardEmbedding(
              innerCardId,
              outerCardId,
              it.firstLeafIndex,
              it.lastLeafIndex)
          })
      }
    }
    db.cardEmbeddingsTable.insertCardEmbeddings(cardEmbeddings)

    db.goalsTable.insert(Goal(
      0,
      goalEn,
      goalL2,
      leafIdCsvToCardId[cardRowForGoal.leafIdsCsv]!!,
      paragraphId
    ))
  }
}

fun findCardEmbeddings(longerLeafIdsCsv: String,
  shorterLeafIdsCsv: String) : List<CardEmbedding> {
  val embeddings = mutableListOf<CardEmbedding>()
  if (longerLeafIdsCsv != shorterLeafIdsCsv &&
      longerLeafIdsCsv.contains(shorterLeafIdsCsv)) {
    val longerLeafIds = longerLeafIdsCsv.split(",").map { it.toInt() }
    val shorterLeafIds = shorterLeafIdsCsv.split(",").map { it.toInt() }
    for (firstLeafIndex in 0..longerLeafIds.size - 1) {
      val lastLeafIndex = firstLeafIndex + shorterLeafIds.size - 1
      if (lastLeafIndex < longerLeafIds.size) {
        var leafIdsMatch = true
        for (i in firstLeafIndex..lastLeafIndex) {
          if (shorterLeafIds[i - firstLeafIndex] != longerLeafIds[i]) {
            leafIdsMatch = false
            break
          }
        }

        if (leafIdsMatch) {
          embeddings.add(CardEmbedding(0, 0, firstLeafIndex, lastLeafIndex))
        }
      }
    }
  }
  return embeddings
}