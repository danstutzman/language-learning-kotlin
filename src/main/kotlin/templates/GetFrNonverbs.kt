package com.danstutzman.templates

import com.danstutzman.db.FrNonverb

fun GetFrNonverbs(nonverbRows: List<FrNonverb>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>French Nonverbs</h1>\n")
  html.append("<form method='POST' action='/fr/nonverbs'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>LeafId</td>\n")
  html.append("    <th>French</td>\n")
  html.append("    <th>English</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (row in nonverbRows) {
    html.append("  <tr>\n")
    html.append("    <td>${row.leafId}</td>\n")
    html.append("    <td>${row.frMixed}</td>\n")
    html.append("    <td>${row.en}</td>\n")
    html.append("    <td><input type='submit' name='deleteLeaf${row.leafId}' value='Delete' onClick='return confirm(\"Delete nonverb?\")'></td>\n")
    html.append("  </tr>\n")
  }
  html.append("  <tr>\n")
  html.append("    <th></td>\n")
  html.append("    <th><input type='text' name='fr_mixed'></td>\n")
  html.append("    <th><input type='text' name='en'></td>\n")
  html.append("    <th><input type='submit' name='newNonverb' value='Insert'></td>\n")
  html.append("  </tr>\n")
  html.append("</table>\n")
  html.append("</form>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}