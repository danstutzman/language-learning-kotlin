package com.danstutzman.templates

import com.danstutzman.db.CardRow
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.GlossRows

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

fun GetCards(cardRows: List<CardRow>): String {
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
  for (card in cardRows) {
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
  return html.toString()
}