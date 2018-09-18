package com.danstutzman.templates

import com.danstutzman.db.Morpheme
import com.danstutzman.db.NewCardRow

fun GetNewCards(lang: String, rows: List<NewCardRow>,
  morphemeById: Map<Int, Morpheme>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>$lang New Cards</h1>\n")
  html.append("<form method='POST' action='/$lang/new-cards'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>Id</td>\n")
  html.append("    <th>Type</td>\n")
  html.append("    <th>Task</td>\n")
  html.append("    <th>Content</td>\n")
  html.append("    <th>Morphemes</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (row in rows) {
    val morphemeIds = row.morphemeIdsCsv.split(",").map { it.toInt() }
    val morphemeL2s =
      morphemeIds.map { morphemeById[it]!!.l2 }.joinToString(" ")
    html.append("  <tr>\n")
    html.append("    <td>${row.newCardId}</td>\n")
    html.append("    <td>${row.type}</td>\n")
    html.append("    <td>${row.enTask}</td>\n")
    html.append("    <td>${row.enContent}</td>\n")
    html.append("    <td>$morphemeL2s</td>\n")
    html.append("    <td><input type='submit' name='deleteNewCard${row.newCardId}' value='Delete' onClick='return confirm(\"Delete new card?\")'></td>\n")
    html.append("  </tr>\n")
  }
  html.append("</table>\n")

  html.append("<h2>Add new card</h2>")
  html.append("<input type='text' name='enTask'>Task<br/>\n")
  html.append("<input type='text' name='enContent'>Content<br/>\n")
  html.append("<table>\n")
  html.append("  <tr>\n")
  html.append("    <th>L2</th>\n")
  html.append("    <th>Gloss</th>\n")
  html.append("  </tr>\n")
  for (i in 0..9) {
    html.append("<tr>\n")
    html.append("  <td><input type='text' name='l2$i'></td>\n")
    html.append("  <td><input type='text' name='gloss$i'></td>\n")
    html.append("</tr>\n")
  }
  html.append("</table>\n")

  html.append("<input type='submit' name='newNewCard' value='Add'>\n")

  html.append("</form>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}