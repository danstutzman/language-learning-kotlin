package com.danstutzman.templates

import com.danstutzman.db.EsUniqueConjugation

fun GetEsUniqueConjugations(
  uniqueConjugations: List<EsUniqueConjugation>,
  infEsByLeafId: Map<Int, String>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Spanish Unique Conjugations</h1>\n")
  html.append("<form method='POST' action='/es/unique-conjugations'>\n")
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
  for (uniqueConjugation in uniqueConjugations) {
    val infEs = infEsByLeafId[uniqueConjugation.infLeafId]

    html.append("  <tr>\n")
    html.append("    <td>${uniqueConjugation.leafId}</td>\n")
    html.append("    <td>${uniqueConjugation.esMixed}</td>\n")
    html.append("    <td>${uniqueConjugation.en}</td>\n")
    html.append("    <td>${uniqueConjugation.enDisambiguation}</td>\n")
    html.append("    <td>${infEs}</td>\n")
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
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}