package com.danstutzman.templates

import com.danstutzman.db.EsNonverb

fun GetEsNonverbs(nonverbRows: List<EsNonverb>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Spanish Nonverbs</h1>\n")
  html.append("<form method='POST' action='/es/nonverbs'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>LeafId</td>\n")
  html.append("    <th>Spanish</td>\n")
  html.append("    <th>English</td>\n")
  html.append("    <th>English disambiguation</td>\n")
  html.append("    <th>English plural</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (row in nonverbRows) {
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
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}