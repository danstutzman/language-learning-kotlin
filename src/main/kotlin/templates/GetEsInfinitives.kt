package com.danstutzman.templates

import com.danstutzman.db.EsInfinitive

fun GetEsInfinitives(infinitives: List<EsInfinitive>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Spanish Infinitives</h1>\n")
  html.append("<form method='POST' action='/es/infinitives'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>LeafId</td>\n")
  html.append("    <th>Spanish</td>\n")
  html.append("    <th>English</td>\n")
  html.append("    <th>English disambiguation</td>\n")
  html.append("    <th>English past</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (infinitive in infinitives) {
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
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}