package com.danstutzman

import com.danstutzman.bank.Bank
import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.GlossRows
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.Tense
import com.danstutzman.bank.es.UniqVList
import com.danstutzman.db.CardEmbedding
import com.danstutzman.db.CardRow
import com.danstutzman.db.CardUpdate
import com.danstutzman.db.Db
import com.danstutzman.db.Goal
import com.danstutzman.db.GoalCardId
import com.danstutzman.db.Infinitive
import com.danstutzman.db.NonverbRow
import com.danstutzman.db.StemChangeRow
import com.danstutzman.db.UniqueConjugation
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.File
import java.util.LinkedList
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response

val STAGE0_NOT_READY_TO_TEST = 0
val STAGE1_READY_TO_TEST = 1
val STAGE5_SAME_AS_ENGLISH = 5

fun escapeHTML(s: String): String {
  val out = StringBuilder(Math.max(16, s.length))
  for (c in s) {
    if (c.toInt() > 127 ||
      c == '"' ||
      c == '<' ||
      c == '>' ||
      c == '&' ||
      c == '\'') {
      out.append("&#")
      out.append(c.toInt())
      out.append(';')
    } else {
      out.append(c)
    }
  }
  return out.toString()
}

fun htmlForGlossRowsTable(json: String): String {
  val html = StringBuilder()
  html.append("<table>")

  html.append("<tr>")
  for (row in GlossRows.expandGlossRows(json)) {
    html.append("<td>${row.en}</td>")
  }
  html.append("</tr>")

  html.append("<tr>")
  for (row in GlossRows.expandGlossRows(json)) {
    html.append("<td>${row.es}</td>")
  }
  html.append("</tr>")

  html.append("</table>")
  return html.toString()
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

  val getRoot = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append("<li><a href='/cards'>Cards</a></li>\n")
    html.append("<li><a href='/goals'>Goals</a></li>\n")
    html.append("<li><a href='/infinitives'>Infinitives</a></li>\n")
    html.append("<li><a href='/nonverbs'>Nonverbs</a></li>\n")
    html.append("<li><a href='/stem-changes'>Stem Changes</a></li>\n")
    html.append("<li><a href='/unique-conjugations'>Unique Conjugations</a></li>\n")
    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val getCards = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<a href='/'>Back to home</a>\n")
    html.append("<h1>Cards</h1>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>CardId</td>\n")
    html.append("    <th>Gloss Rows</td>\n")
    html.append("    <th>Last Seen At</td>\n")
    html.append("    <th>Mnemonic</td>\n")
    html.append("    <th>Prompt</td>\n")
    html.append("    <th>Stage</td>\n")
    html.append("  </tr>\n")
    for (card in db.selectAllCardRows()) {
      html.append("  <tr>\n")
      html.append("    <td>${card.cardId}</td>\n")
      html.append("    <td>${htmlForGlossRowsTable(card.glossRowsJson)}</td>\n")
      html.append("    <td>${card.lastSeenAt}</td>\n")
      html.append("    <td>${card.mnemonic}</td>\n")
      html.append("    <td>${card.prompt}</td>\n")
      html.append("    <td>${card.stage}</td>\n")
      html.append("  </tr>\n")
    }
    html.append("</table><br>\n")

    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val getGoals = { _: Request, _: Response ->
    val goals = db.selectAllGoals()
    val goalCardIds = goals.map { it.cardId }
    val cardEmbeddingsByCardId = goals.map {
      Pair(it.cardId, mutableListOf<CardEmbedding>())
    }.toMap().toMutableMap()
    val subCardIds = mutableListOf<Int>()
    for (cardEmbedding in
      db.selectCardEmbeddingsWithLongerCardIdIn(goalCardIds)) {
      cardEmbeddingsByCardId[cardEmbedding.longerCardId]!!.add(cardEmbedding)
      subCardIds.add(cardEmbedding.shorterCardId)
    }
    val allCardIds = (goalCardIds + subCardIds).distinct()
    val cardByCardId = db.selectCardRowsWithCardIdIn(allCardIds)
      .map { Pair(it.cardId, it) }.toMap()

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<a href='/'>Back to home</a>\n")
    html.append("<h1>Goals</h1>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>ID</td>\n")
    html.append("    <th>Tags</td>\n")
    html.append("    <th>English</td>\n")
    html.append("    <th>Spanish</td>\n")
    html.append("  </tr>\n")
    for (goal in goals) {
      val card = cardByCardId[goal.cardId]!!
      val glossRows = GlossRows.expandGlossRows(card.glossRowsJson)
      val openTagsByGlossRowIndex = glossRows.map { LinkedList<String>() }
      val closeTagsByGlossRowIndex = glossRows.map { LinkedList<String>() }
      val cardEmbeddingsAndSelf = (cardEmbeddingsByCardId[goal.cardId]!! +
        listOf(CardEmbedding(goal.cardId, goal.cardId, 0,
          cardByCardId[goal.cardId]!!.leafIdsCsv.split(",").size - 1))
      ).sortedBy { it.lastLeafIndex - it.firstLeafIndex } // short ones first
      for (embedding in cardEmbeddingsAndSelf) {
        val stage = cardByCardId[embedding.shorterCardId]?.stage ?:
          throw RuntimeException(
            "Can't find shorterCard for embedding ${embedding}")
        val style = if (embedding.firstLeafIndex == embedding.lastLeafIndex)
          "goal-es-single-word" else "goal-es-multiple-words"
        openTagsByGlossRowIndex[embedding.firstLeafIndex].push(
          "<span class='${style} stage${stage}'>")
        closeTagsByGlossRowIndex[embedding.lastLeafIndex].add("</span>")
      }

      val glossRowsHtml = StringBuilder()
      for (i in 0..glossRows.size - 1) {
        val es = glossRows[i].es
        glossRowsHtml.append(openTagsByGlossRowIndex[i].joinToString(""))
        glossRowsHtml.append(es.replace("-", ""))
        glossRowsHtml.append(closeTagsByGlossRowIndex[i].joinToString(""))
        if (!es.endsWith("-")) {
          glossRowsHtml.append(" ")
        }
      }

      html.append("  <tr>\n")
      html.append("    <td>${goal.goalId}</td>\n")
      html.append("    <td>${goal.tagsCsv}</td>\n")
      html.append("    <td>${goal.en}</td>\n")
      html.append("    <td>${glossRowsHtml}</td>\n")
      // html.append("    <td><a href='/goals/${goal.goalId}'>Edit</a></td>\n")
      html.append("  </tr>\n")
    }
    html.append("</table><br>\n")

    html.append("<form method='POST' action='/goals'>\n")
    html.append("  <label for='tags_csv'>Tags (comma-separated)</label><br>\n")
    html.append("  <input type='text' name='tags_csv'><br>\n")
    html.append("  <label for='en'>English</label><br>\n")
    html.append("  <input type='text' name='en'><br>\n")
    html.append("  <label for='es'>Spanish</label><br>\n")
    html.append("  <textarea name='es' rows='10' cols='80'></textarea><br>\n")
    html.append("  <input type='submit' name='submit' value='Add Goal'>\n")
    html.append("</form>\n")

    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  // val getGoal = { req: Request, _: Response ->
  //   val goal = db.selectGoalById(req.params("goalId")!!.toInt())!!

  //   val html = StringBuilder()
  //   html.append(OPEN_BODY_TAG)

  //   html.append("<h1>Edit Goal ${goal.goalId}</h1>\n")
  //   html.append("<form method='POST' action='/goals/${goal.goalId}'>\n")
  //   html.append("  <label for='en'>Tags (comma-separated)</label><br>\n")
  //   html.append("  <input type='text' name='tags_csv' value='${escapeHTML(goal.tagsCsv)}'><br>\n")
  //   html.append("  <label for='en'>English</label><br>\n")
  //   html.append("  <input type='text' name='en' value='${escapeHTML(goal.en)}'><br>\n")
  //   html.append("  <label for='es'>Spanish</label><br>\n")
  //   html.append("  <input type='text' name='es' value='${escapeHTML(goal.es)}'><br>\n")
  //   html.append("  <input type='submit' name='submit' value='Edit Goal'>\n")
  //   html.append("  <input type='submit' name='submit' value='Delete Goal' onClick='return confirm(\"Delete goal?\")'>\n")
  //   html.append("</form>\n")

  //   html.append(CLOSE_BODY_TAG)
  //   html.toString()
  // }

  // val postGoal = { req: Request, res: Response ->
  //   val submit = req.queryParams("submit")
  //   if (submit == "Edit Goal") {
  //     val goal = Goal(
  //       req.params("goalId").toInt(),
  //       req.queryParams("tags_csv"),
  //       req.queryParams("en"),
  //       req.queryParams("es"),
  //       ""
  //     )
  //     db.updateGoal(goal)
  //   } else if (submit == "Delete Goal") {
  //     db.deleteGoal(req.params("goalId").toInt())
  //   } else {
  //     throw RuntimeException("Unexpected submit value: ${submit}")
  //   }

  //   res.redirect("/goals")
  // }

  val postGoals = { req: Request, res: Response ->
    val goalTagsCsv = req.queryParams("tags_csv")
    val goalEs = req.queryParams("es")
    val goalEn = req.queryParams("en")

    val bank = Bank(db)
    val gsonBuilder = GsonBuilder().create()
    val cardCreators = bank.parseEsPhrase(goalEs)
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
      db.insertCardRows(allCardRows)

      val leafIdsCsvCardIdPairs = db.selectLeafIdsCsvCardIdPairs()
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
      db.insertCardEmbeddings(cardEmbeddings)

      db.insertGoal(Goal(
        0,
        goalTagsCsv,
        goalEn,
        goalEs,
        leafIdCsvToCardId[cardRowForGoal.leafIdsCsv]!!
      ))
    }

    res.redirect("/goals")
  }

  val getNonverbs = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<a href='/'>Back to home</a>\n")
    html.append("<h1>Nonverbs</h1>\n")
    html.append("<form method='POST' action='/nonverbs'>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>LeafId</td>\n")
    html.append("    <th>Spanish</td>\n")
    html.append("    <th>English</td>\n")
    html.append("    <th>English disambiguation</td>\n")
    html.append("    <th>English plural</td>\n")
    html.append("    <th></td>\n")
    html.append("  </tr>\n")
    for (row in db.selectAllNonverbRows()) {
      html.append("  <tr>\n")
      html.append("    <td>${row.leafId}</td>\n")
      html.append("    <td>${row.esMixed}</td>\n")
      html.append("    <td>${row.en}</td>\n")
      html.append("    <td>${row.enDisambiguation}</td>\n")
      html.append("    <td>${row.enPlural ?: ""}</td>\n")
      html.append("    <td><input type='submit' name='deleteLeaf${row.leafId}' value='Delete' onClick='return confirm(\"Delete nonverb?\")'></td>\n")
      html.append("  </tr>\n")
    }
    html.append("  <tr>\n")
    html.append("    <th></td>\n")
    html.append("    <th><input type='text' name='es_mixed'></td>\n")
    html.append("    <th><input type='text' name='en'></td>\n")
    html.append("    <th><input type='text' name='en_disambiguation'></td>\n")
    html.append("    <th><input type='text' name='en_plural'></td>\n")
    html.append("    <th><input type='submit' name='newNonverb' value='Insert'></td>\n")
    html.append("  </tr>\n")
    html.append("</table>\n")
    html.append("</form>\n")
  }

  val postNonverbs = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.deleteLeaf(leafId)
    }

    if (req.queryParams("newNonverb") != null) {
      db.insertNonverbRow(NonverbRow(
        0,
        req.queryParams("en"),
        req.queryParams("en_disambiguation"),
        if (req.queryParams("en_plural") != "")
          req.queryParams("en_plural") else null,
        req.queryParams("es_mixed")
      ))
    }

    res.redirect("/nonverbs")
  }

  val getInfinitives = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<a href='/'>Back to home</a>\n")
    html.append("<h1>Infinitives</h1>\n")
    html.append("<form method='POST' action='/infinitives'>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>LeafId</td>\n")
    html.append("    <th>Spanish</td>\n")
    html.append("    <th>English</td>\n")
    html.append("    <th>English disambiguation</td>\n")
    html.append("    <th>English past</td>\n")
    html.append("    <th></td>\n")
    html.append("  </tr>\n")
    for (infinitive in db.selectAllInfinitives()) {
      html.append("  <tr>\n")
      html.append("    <td>${infinitive.leafId}</td>\n")
      html.append("    <td>${infinitive.esMixed}</td>\n")
      html.append("    <td>${infinitive.en}</td>\n")
      html.append("    <td>${infinitive.enDisambiguation}</td>\n")
      html.append("    <td>${infinitive.enPast}</td>\n")
      html.append("    <td><input type='submit' name='deleteLeaf${infinitive.leafId}' value='Delete' onClick='return confirm(\"Delete infinitive?\")'></td>\n")
      html.append("  </tr>\n")
    }
    html.append("  <tr>\n")
    html.append("    <th></td>\n")
    html.append("    <th><input type='text' name='es_mixed'></td>\n")
    html.append("    <th><input type='text' name='en'></td>\n")
    html.append("    <th><input type='text' name='en_disambiguation'></td>\n")
    html.append("    <th><input type='text' name='en_past'></td>\n")
    html.append("    <th><input type='submit' name='newInfinitive' value='Insert'></td>\n")
    html.append("  </tr>\n")
    html.append("</table>\n")
    html.append("</form>\n")
  }

  val postInfinitives = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.deleteLeaf(leafId)
    }

    if (req.queryParams("newInfinitive") != null) {
      db.insertInfinitive(Infinitive(
        0,
        req.queryParams("en"),
        req.queryParams("en_disambiguation"),
        req.queryParams("en_past"),
        req.queryParams("es_mixed")
      ))
    }

    res.redirect("/infinitives")
  }

  val getUniqueConjugations = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<a href='/'>Back to home</a>\n")
    html.append("<h1>Unique Conjugations</h1>\n")
    html.append("<form method='POST' action='/unique-conjugations'>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>LeafId</td>\n")
    html.append("    <th>Spanish</td>\n")
    html.append("    <th>English</td>\n")
    html.append("    <th>English disambiguation</td>\n")
    html.append("    <th>Infinitive</td>\n")
    html.append("    <th>Number</td>\n")
    html.append("    <th>Person</td>\n")
    html.append("    <th>Tense</td>\n")
    html.append("    <th></td>\n")
    html.append("  </tr>\n")
    for (uniqueConjugation in db.selectAllUniqueConjugations()) {
      html.append("  <tr>\n")
      html.append("    <td>${uniqueConjugation.leafId}</td>\n")
      html.append("    <td>${uniqueConjugation.esMixed}</td>\n")
      html.append("    <td>${uniqueConjugation.en}</td>\n")
      html.append("    <td>${uniqueConjugation.enDisambiguation}</td>\n")
      html.append("    <td>${uniqueConjugation.infinitiveEsMixed}</td>\n")
      html.append("    <td>${uniqueConjugation.number}</td>\n")
      html.append("    <td>${uniqueConjugation.person}</td>\n")
      html.append("    <td>${uniqueConjugation.tense}</td>\n")
      html.append("    <td><input type='submit' name='deleteLeaf${uniqueConjugation.leafId}' value='Delete' onClick='return confirm(\"Delete conjugation?\")'></td>\n")
      html.append("  </tr>\n")
    }
    html.append("  <tr>\n")
    html.append("    <th></td>\n")
    html.append("    <th><input type='text' name='es_mixed'></td>\n")
    html.append("    <th><input type='text' name='en'></td>\n")
    html.append("    <th><input type='text' name='en_disambiguation'></td>\n")
    html.append("    <th><input type='text' name='infinitive_es_mixed'></td>\n")
    html.append("    <th><select name='number'><option></option><option>1</option><option>2</option></select>\n")
    html.append("    <th><select name='person'><option></option><option>1</option><option>2</option><option>3</option></select></td>\n")
    html.append("    <th><select name='tense'><option></option><option>PRES</option><option>PRET</option></select></td>\n")
    html.append("    <th><input type='submit' name='newUniqueConjugation' value='Insert'></td>\n")
    html.append("  </tr>\n")
    html.append("</table>\n")
    html.append("</form>\n")
  }

  val postUniqueConjugations = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.deleteLeaf(leafId)
    }

    if (req.queryParams("newUniqueConjugation") != null) {
      db.insertUniqueConjugation(UniqueConjugation(
        0,
        req.queryParams("es_mixed"),
        req.queryParams("en"),
        req.queryParams("infinitive_es_mixed"),
        req.queryParams("number").toInt(),
        req.queryParams("person").toInt(),
        req.queryParams("tense"),
        req.queryParams("en_disambiguation")
      ))
    }

    res.redirect("/unique-conjugations")
  }

  val getStemChanges = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<a href='/'>Back to home</a>\n")
    html.append("<h1>Stem Changes</h1>\n")
    html.append("<form method='POST' action='/stem-changes'>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>LeafId</td>\n")
    html.append("    <th>Infinitive</td>\n")
    html.append("    <th>Stem</td>\n")
    html.append("    <th>Tense</td>\n")
    html.append("    <th>English</td>\n")
    html.append("    <th>English past</td>\n")
    html.append("    <th>English disambiguation</td>\n")
    html.append("    <th></th>\n")
    html.append("  </tr>\n")
    for (row in db.selectAllStemChangeRows()) {
      html.append("  <tr>\n")
      html.append("    <td>${row.leafId}</td>\n")
      html.append("    <td>${row.infinitiveEsMixed}</td>\n")
      html.append("    <td>${row.esMixed}</td>\n")
      html.append("    <td>${row.tense}</td>\n")
      html.append("    <td>${row.en}</td>\n")
      html.append("    <td>${row.enPast}</td>\n")
      html.append("    <td>${row.enDisambiguation}</td>\n")
      html.append("    <td><input type='submit' name='deleteLeaf${row.leafId}' value='Delete' onClick='return confirm(\"Delete stem change?\")'></td>\n")
      html.append("  </tr>\n")
    }
    html.append("  <tr>\n")
    html.append("    <th></td>\n")
    html.append("    <th><input type='text' name='infinitive_es_mixed'></td>\n")
    html.append("    <th><input type='text' name='es_mixed'></td>\n")
    html.append("    <th><select name='tense'><option></option><option>PRES</option><option>PRET</option></select></td>\n")
    html.append("    <th><input type='text' name='en'></td>\n")
    html.append("    <th><input type='text' name='en_past'></td>\n")
    html.append("    <th><input type='text' name='en_disambiguation'></td>\n")
    html.append("    <th><input type='submit' name='newStemChange' value='Insert'></td>\n")
    html.append("  </tr>\n")
    html.append("</table>\n")
    html.append("</form>\n")
  }

  val postStemChanges = { req: Request, res: Response ->
    val regex = "deleteLeaf([0-9]+)".toRegex()
    val leafIdsToDelete = req.queryParams().map { paramName ->
      val match = regex.find(paramName)
      if (match != null) match.groupValues[1].toInt() else null
    }.filterNotNull()
    for (leafId in leafIdsToDelete) {
      db.deleteLeaf(leafId)
    }

    if (req.queryParams("newStemChange") != null) {
      db.insertStemChangeRow(StemChangeRow(
        0,
        req.queryParams("infinitive_es_mixed"),
        req.queryParams("es_mixed"),
        req.queryParams("tense"),
        req.queryParams("en"),
        req.queryParams("en_past"),
        req.queryParams("en_disambiguation")
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
