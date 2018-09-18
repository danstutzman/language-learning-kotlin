package com.danstutzman.templates

import com.danstutzman.db.Morpheme

fun GetMorphemes(
  lang: String,
  morphemes: List<Morpheme>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>$lang Morphemes</h1>\n")
  html.append("<form method='POST' action='/$lang/morphemes'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>Id</td>\n")
  html.append("    <th>Type</td>\n")
  html.append("    <th>L2</td>\n")
  html.append("    <th>Gloss</td>\n")
  html.append("    <th></th>\n")
  html.append("  </tr>\n")
  for (row in morphemes) {
    html.append("  <tr>\n")
    html.append("    <td>${row.morphemeId}</td>\n")
    html.append("    <td>${row.type}</td>\n")
    html.append("    <td>${row.l2}</td>\n")
    html.append("    <td>${row.gloss}</td>\n")
    html.append("    <td><input type='submit' name='deleteMorpheme${row.morphemeId}' value='Delete' onClick='return confirm(\"Delete morpheme?\")'></td>\n")
    html.append("  </tr>\n")
  }
  html.append("  <tr>\n")
  html.append("    <th></td>\n")
  html.append("    <th><input type='text' name='type'></td>\n")
  html.append("    <th><input type='text' name='l2'></td>\n")
  html.append("    <th><input type='text' name='gloss'></td>\n")
  html.append("    <th><input type='submit' name='newMorpheme' value='Insert'></td>\n")
  html.append("  </tr>\n")
  html.append("</table>\n")
  html.append("</form>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}