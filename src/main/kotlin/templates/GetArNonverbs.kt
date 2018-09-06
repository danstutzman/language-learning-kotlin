package com.danstutzman.templates

import com.danstutzman.db.ArNonverb

fun GetArNonverbs(nonverbRows: List<ArNonverb>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Arabic Nonverbs</h1>\n")
  html.append("<form method='POST' action='/ar/nonverbs'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>LeafId</td>\n")
  html.append("    <th>English</td>\n")
  html.append("    <th>Buckwalter</td>\n")
  html.append("    <th>Monospace</td>\n")
  html.append("    <th>Middles</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (row in nonverbRows) {
    html.append("  <tr>\n")
    html.append("    <td>${row.leafId}</td>\n")
    html.append("    <td>${row.en}</td>\n")
    html.append("    <td class='ar-buckwalter' data-leaf-id='${row.leafId}'>${row.arBuckwalter}</td>\n")
    html.append("    <td><div id='ar-monospace-${row.leafId}' class='ar-monospace'></td>\n")
    html.append("    <td><div id='ar-middles-${row.leafId}' class='ar-middles'></td>\n")
    html.append("    <td><input type='submit' name='deleteLeaf${row.leafId}' value='Delete' onClick='return confirm(\"Delete nonverb?\")'></td>\n")
    html.append("  </tr>\n")
  }
  html.append("  <tr>\n")
  html.append("    <td></td>\n")
  html.append("    <td><input type='text' name='en'></td>\n")
  html.append("    <td><input type='text' id='ar-buckwalter-new' name='ar_buckwalter' class='ar-buckwalter' data-leaf-id='new'></td>\n")
  html.append("    <td><input type='text' id='ar-monospace-new' class='ar-monospace'></td>\n")
  html.append("    <td><input type='text' id='ar-middles-new' class='ar-middles'></td>\n")
  html.append("    <td><input type='submit' name='newNonverb' value='Insert'></td>\n")
  html.append("  </tr>\n")
  html.append("</table>\n")
  html.append("</form>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}