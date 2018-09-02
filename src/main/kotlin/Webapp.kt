package com.danstutzman

import com.danstutzman.bank.Bank
import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.Interpretation
import com.danstutzman.bank.es.Nonverb
import com.danstutzman.db.CardEmbedding
import com.danstutzman.db.CardRow
import com.danstutzman.db.CardUpdate
import com.danstutzman.db.Db
import com.danstutzman.db.Goal
import com.danstutzman.db.Infinitive
import com.danstutzman.db.NonverbRow
import com.danstutzman.db.Paragraph
import com.danstutzman.db.StemChangeRow
import com.danstutzman.db.UniqueConjugation
import com.danstutzman.templates.GetCards
import com.danstutzman.templates.GetInfinitives
import com.danstutzman.templates.GetNonverbs
import com.danstutzman.templates.GetParagraph
import com.danstutzman.templates.GetParagraphs
import com.danstutzman.templates.GetRoot
import com.danstutzman.templates.GetStemChanges
import com.danstutzman.templates.GetUniqueConjugations
import com.danstutzman.templates.PostParagraphDisambiguateGoal
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.File
import java.text.Normalizer
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response

val STAGE0_NOT_READY_TO_TEST = 0
val STAGE1_READY_TO_TEST = 1
val STAGE5_SAME_AS_ENGLISH = 5

fun normalize(s: String): String = Normalizer.normalize(s, Normalizer.Form.NFC)

fun blankToNull(s: String): String? = if (s == "") null else s

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

fun createGoal(goalEs:String, cardCreators: List<CardCreator>, goalEn: String,
  db: Db, paragraphId: Int) {
  val gsonBuilder = GsonBuilder().create()
  if (cardCreators.size > 0) {
    val cardRowsForWords = cardCreators.map { cardCreator ->
      val glossRows = cardCreator.getGlossRows()
      CardRow(
        cardId = 0,
        glossRowsJson = gsonBuilder.toJson(glossRows),
        lastSeenAt = null,
        leafIdsCsv = glossRows.map { it.leafId }.joinToString(","),
        mnemonic = "",
        prompt = cardCreator.getPrompt(),
        stage = if (glossRows.size == 1) {
            if (glossRows[0].es == glossRows[0].en) STAGE5_SAME_AS_ENGLISH
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
          glossRowsJson = gsonBuilder.toJson(glossRows),
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
      glossRowsJson = gsonBuilder.toJson(glossRows),
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
      goalEs,
      leafIdCsvToCardId[cardRowForGoal.leafIdsCsv]!!,
      paragraphId
    ))
  }
}

data class CardsUpload(val cards: List<CardUpload>)

data class CardUpload (
  val cardId: Int,
  val glossRows: List<GlossRow>,
  val mnemonic: String,
  val lastSeenAt: Int?,
  val stage: Int
)

class Webapp(
  val db: Db
) {
  val logger: Logger = LoggerFactory.getLogger("Webapp.kt")

  val OPEN_BODY_TAG = """
    <html>
      <head>
        <link rel='stylesheet' type='text/css' href='/style.css'>
        <script src='/script.js'></script>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
      </head>
      <body>"""
  val CLOSE_BODY_TAG = "</body></html>"

  val getRoot = { _: Request, _: Response -> GetRoot() }

  val getCards = { _: Request, _: Response ->
    val cardRows = db.cardsTable.selectAll()
    GetCards(cardRows)
  }

  val getNonverbs = { _: Request, _: Response ->
    val nonverbs = db.leafsTable.selectAllNonverbRows()
    GetNonverbs(nonverbs)
  }

  val postNonverbs = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.leafsTable.deleteLeaf(leafId)
    }

    if (req.queryParams("newNonverb") != null) {
      db.leafsTable.insertNonverbRow(NonverbRow(
        0,
        normalize(req.queryParams("en")),
        normalize(req.queryParams("en_disambiguation")),
        blankToNull(normalize(req.queryParams("en_plural"))),
        normalize(req.queryParams("es_mixed"))
      ))
    }

    res.redirect("/nonverbs")
  }

  val getInfinitives = { _: Request, _: Response ->
    val infinitives = db.leafsTable.selectAllInfinitives()
    GetInfinitives(infinitives)
  }

  val postInfinitives = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.leafsTable.deleteLeaf(leafId)
    }

    if (req.queryParams("newInfinitive") != null) {
      db.leafsTable.insertInfinitive(Infinitive(
        0,
        normalize(req.queryParams("en")),
        normalize(req.queryParams("en_disambiguation")),
        normalize(req.queryParams("en_past")),
        normalize(req.queryParams("es_mixed"))
      ))
    }

    res.redirect("/infinitives")
  }

  val getParagraphs = { _: Request, _: Response ->
    val paragraphs = db.paragraphsTable.selectAll()
    val allGoals = db.goalsTable.selectAll()
    val goalsByParagraphId = paragraphs.map {
      Pair(it.paragraphId, mutableListOf<Goal>())
    }.toMap()
    for (goal in allGoals) {
      goalsByParagraphId[goal.paragraphId]?.add(goal) ?:
        throw RuntimeException(
          "Can't find paragraphId ${goal.paragraphId} from goal ${goal}")
    }

    val goalCardIds = allGoals.map { it.cardId }
    val cardEmbeddingsByCardId = allGoals.map {
      Pair(it.cardId, mutableListOf<CardEmbedding>())
    }.toMap().toMutableMap()
    val subCardIds = mutableListOf<Int>()
    for (cardEmbedding in
      db.cardEmbeddingsTable.selectWithLongerCardIdIn(goalCardIds)) {
      cardEmbeddingsByCardId[cardEmbedding.longerCardId]!!.add(cardEmbedding)
      subCardIds.add(cardEmbedding.shorterCardId)
    }
    val allCardIds = (goalCardIds + subCardIds).distinct()
    val cardByCardId = db.cardsTable.selectWithCardIdIn(allCardIds)
      .map { Pair(it.cardId, it) }.toMap()

    GetParagraphs(paragraphs, goalsByParagraphId, cardByCardId,
      cardEmbeddingsByCardId)
  }

  val postParagraphs = { req: Request, res: Response ->
    val topic = normalize(req.queryParams("topic"))
    val enabled = req.queryParams("enabled") != null
    db.paragraphsTable.insert(Paragraph(0, topic, enabled))
    res.redirect("/paragraphs")
  }

  val getParagraph = { req: Request, _: Response ->
    val paragraphId = req.params("paragraphId")!!.toInt()
    val paragraph = db.paragraphsTable.selectById(paragraphId)!!
    val goals = db.goalsTable.selectWithParagraphIdIn(
      listOf(paragraph.paragraphId))
    GetParagraph(paragraph, goals)
  }

  val postParagraph = { req: Request, res: Response ->
    val paragraphId = req.params("paragraphId").toInt()
    val submit = req.queryParams("submit")
    if (submit == "Edit Paragraph") {
      val paragraph = Paragraph(
        req.params("paragraphId").toInt(),
        req.queryParams("topic"),
        req.queryParams("enabled") != null)
      db.paragraphsTable.update(paragraph)

   } else if (submit == "Delete Paragraph") {
      db.paragraphsTable.delete(req.params("paragraphId").toInt())
    } else {
      throw RuntimeException("Unexpected submit value: ${submit}")
    }

    res.redirect("/paragraphs/${paragraphId}")
  }

  val postParagraphDisambiguateGoal = { req: Request, _: Response ->
    val paragraphId = req.params("paragraphId").toInt()
    val phraseEn = normalize(req.queryParams("en")!!)
    val phraseEs = normalize(req.queryParams("es")!!)
    if (phraseEn == "") {
      throw RuntimeException("En param can't be blank")
    }

    val bank = Bank(db)
    val words = bank.splitEsPhrase(phraseEs)
    val interpretationsByWordNum = words.map { bank.interpretEsWord(it) }

    PostParagraphDisambiguateGoal(paragraphId, phraseEn, phraseEs, words,
      interpretationsByWordNum)
  }

  val postParagraphAddGoal = { req: Request, res: Response ->
    val paragraphId = req.params("paragraphId").toInt()
    val goalEn = normalize(req.queryParams("en")!!)
    val goalEs = normalize(req.queryParams("es")!!)
    if (goalEn == "") {
      throw RuntimeException("En param can't be blank")
    }

    val bank = Bank(db)
    val cardCreators = mutableListOf<CardCreator>()
    for ((wordNum, word) in bank.splitEsPhrase(goalEs).withIndex()) {
      val interpretations: List<Interpretation> = bank.interpretEsWord(word)

      val interpretationNum = req.queryParams("word.${wordNum}")
      val type = req.queryParams("word.${wordNum}.${interpretationNum}.type")
      val exists =
        req.queryParams("word.${wordNum}.${interpretationNum}.exists")
      if (exists == "true") {
        val leafIds =
          req.queryParams("word.${wordNum}.${interpretationNum}.leafIds")
        val interpretation = interpretations.find {
            it.type == type && it.cardCreator != null &&
            it.cardCreator.serializeLeafIds() == leafIds
          } ?: throw RuntimeException("Can't find ${type} with ${leafIds}")
        cardCreators.add(interpretation.cardCreator!!)
      } else {
        if (type == "Nonverb") {
          val row = db.leafsTable.insertNonverbRow(NonverbRow(
            0,
            normalize(req.queryParams(
              "word.${wordNum}.${interpretationNum}.en")),
            normalize(req.queryParams(
              "word.${wordNum}.${interpretationNum}.enDisambiguation")),
            blankToNull(normalize(req.queryParams(
              "word.${wordNum}.${interpretationNum}.enPlural"))),
            normalize(req.queryParams(
              "word.${wordNum}.${interpretationNum}.es"))
          ))
          cardCreators.add(Nonverb(row.leafId, row.esMixed, row.en, blankToNull(row.enDisambiguation)))
        } else {
          throw RuntimeException("Can't create ${type}")
        }
      }
    }

    createGoal(goalEs, cardCreators, goalEn, db, paragraphId)

    res.redirect("/paragraphs/${paragraphId}")
  }

  val getUniqueConjugations = { _: Request, _: Response ->
    val uniqueConjugations = db.leafsTable.selectAllUniqueConjugations()
    val infEsByLeafId = db.leafsTable.selectInfinitivesWithLeafIdIn(
      uniqueConjugations.map { it.infLeafId }.distinct()
    ).map { it.leafId to it.esMixed }.toMap()

    GetUniqueConjugations(uniqueConjugations, infEsByLeafId)
  }

  val postUniqueConjugations = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.leafsTable.deleteLeaf(leafId)
    }

    if (req.queryParams("newUniqueConjugation") != null) {
      var infinitive = db.leafsTable.findInfinitiveByEsMixed(
        normalize(req.queryParams("infinitive_es_mixed")))!!

      db.leafsTable.insertUniqueConjugation(UniqueConjugation(
        0,
        normalize(req.queryParams("es_mixed")),
        normalize(req.queryParams("en")),
        infinitive.leafId,
        req.queryParams("number").toInt(),
        req.queryParams("person").toInt(),
        req.queryParams("tense"),
        normalize(req.queryParams("en_disambiguation"))
      ))
    }

    res.redirect("/unique-conjugations")
  }

  val getStemChanges = { _: Request, _: Response ->
    val stemChanges = db.leafsTable.selectAllStemChangeRows()
    val infEsMixedByLeafId = db.leafsTable.selectInfinitivesWithLeafIdIn(
      stemChanges.map { it.infLeafId }.distinct()
    ).map { it.leafId to it.esMixed }.toMap()
    GetStemChanges(stemChanges, infEsMixedByLeafId)
  }

  val postStemChanges = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.leafsTable.deleteLeaf(leafId)
    }

    if (req.queryParams("newStemChange") != null) {
      var infinitive = db.leafsTable.findInfinitiveByEsMixed(
        normalize(req.queryParams("infinitive_es_mixed")))!!

      db.leafsTable.insertStemChangeRow(StemChangeRow(
        leafId = 0,
        infLeafId = infinitive.leafId,
        esMixed = normalize(req.queryParams("es_mixed")),
        tense = req.queryParams("tense"),
        en = normalize(req.queryParams("en")),
        enPast = normalize(req.queryParams("en_past")),
        enDisambiguation = normalize(req.queryParams("en_disambiguation"))
      ))
    }

    res.redirect("/stem-changes")
  }

  val getApi = { _: Request, res: Response ->
    val bank = Bank(db)
    val response = bank.getCardDownloads()
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    GsonBuilder().serializeNulls().create().toJson(response)
  }

  val postApi = { req: Request, res: Response ->
    val cardsUpload = Gson().fromJson(req.body(), CardsUpload::class.java)
    val bank = Bank(db)
    bank.saveCardUpdates(cardsUpload.cards.map {
      CardUpdate(
        cardId = it.cardId,
        lastSeenAt = it.lastSeenAt,
        mnemonic = it.mnemonic,
        stage = it.stage)
    })
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    "{}"
  }
}
