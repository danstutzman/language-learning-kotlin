package com.danstutzman.templates

import com.danstutzman.db.EsStemChange

fun GetEsStemChanges(
  stemChanges: List<EsStemChange>,
  infEsMixedByLeafId: Map<Int, String>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Spanish Stem Changes</h1>\n")
  html.append("<form method='POST' action='/es/stem-changes'>\n")
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
  for (row in stemChanges) {
    val infEsMixed = infEsMixedByLeafId[row.infLeafId]
    html.append("  <tr>\n")
    html.append("    <td>${row.leafId}</td>\n")
    html.append("    <td>${infEsMixed}</td>\n")
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
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}