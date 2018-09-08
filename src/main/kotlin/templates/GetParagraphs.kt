package com.danstutzman.templates

import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.GlossRows
import com.danstutzman.db.CardRow
import com.danstutzman.db.CardEmbedding
import com.danstutzman.db.Goal
import com.danstutzman.db.Paragraph
import java.util.LinkedList

fun getGlossRowsHtml(
  goalId: Int,
  cardId: Int,
  cardByCardId: Map<Int, CardRow>,
  cardEmbeddingsByCardId: Map<Int, List<CardEmbedding>>
 ): String {

  val card = cardByCardId[cardId] ?: throw RuntimeException(
    "Can't find cardId ${cardId} from goal ${goalId}")
  val glossRows = GlossRows.expandGlossRows(card.glossRowsJson)
  val openTagsByGlossRowIndex = glossRows.map { LinkedList<String>() }
  val closeTagsByGlossRowIndex = glossRows.map { LinkedList<String>() }
  val numLeafs = cardByCardId[cardId]!!.leafIdsCsv.split(",").size - 1
  val cardEmbeddingsAndSelf = (cardEmbeddingsByCardId[cardId]!! +
    listOf(CardEmbedding(cardId, cardId, 0, numLeafs))
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
    val l2 = glossRows[i].l2
    val nextL2 = if (i < glossRows.size - 1) glossRows[i + 1].l2 else ""

    glossRowsHtml.append(openTagsByGlossRowIndex[i].joinToString(""))
    glossRowsHtml.append(l2.replace("-", ""))
    glossRowsHtml.append(closeTagsByGlossRowIndex[i].joinToString(""))
    if (!l2.endsWith("-") && !nextL2.startsWith("-")) {
      glossRowsHtml.append(" ")
    }
  }
  return glossRowsHtml.toString()
}

fun GetParagraphs(
  lang: String,
  paragraphs: List<Paragraph>,
  goalsByParagraphId: Map<Int, List<Goal>>,
  cardByCardId: Map<Int, CardRow>,
  cardEmbeddingsByCardId: Map<Int, List<CardEmbedding>>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)

  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>${lang} Paragraphs</h1>\n")
  for (paragraph in paragraphs) {
    html.append("<h2>Paragraph ${paragraph.paragraphId}: ${paragraph.topic}")
    html.append("  enabled=${paragraph.enabled}</h2>\n")
    html.append("<table border='1'>\n")
    for (goal in goalsByParagraphId[paragraph.paragraphId]!!) {
      val glossRowsHtml = getGlossRowsHtml(goal.goalId, goal.cardId,
        cardByCardId, cardEmbeddingsByCardId)

      html.append("  <tr>\n")
      html.append("    <td>${goal.en}</td>\n")
      html.append("    <td>${glossRowsHtml}</td>\n")
      html.append("  </tr>\n")
    }
    html.append("</table>\n")
    html.append("<p><a href='/${lang}/paragraphs/${paragraph.paragraphId}'>Edit</a></p>\n")
  }

  html.append("<h2>Add paragraph</h2>\n")
  html.append("<form method='POST' action='/${lang}/paragraphs'>\n")
  html.append("  <label for='topic'>Topic</label><br>\n")
  html.append("  <input type='text' name='topic'><br>\n")
  html.append("  <label for='enabled'>Enabled</label><br>\n")
  html.append("  <input type='checkbox' name='enabled'><br>\n")
  html.append("  <input type='submit' name='submit' value='Add Paragraph'>\n")
  html.append("</form>\n")

  html.append(CLOSE_BODY_TAG)
  return html.toString()
}