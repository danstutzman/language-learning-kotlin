package com.danstutzman.templates

import com.danstutzman.db.ArUniqueConjugation

fun GetArUniqueConjugations(
  uniqueConjugations: List<ArUniqueConjugation>,
  rootArBuckwalterByLeafId: Map<Int, String>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Arabic Unique Conjugations</h1>\n")
  html.append("<form method='POST' action='/ar/unique-conjugations'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>LeafId</td>\n")
  html.append("    <th>English</td>\n")
  html.append("    <th>Root Buckwalter</td>\n")
  html.append("    <th>Buckwalter</td>\n")
  html.append("    <th>Pronunciation (Qalam)</td>\n")
  html.append("    <th>Monospace</td>\n")
  html.append("    <th>Gender</td>\n")
  html.append("    <th>Number</td>\n")
  html.append("    <th>Person</td>\n")
  html.append("    <th>Tense</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (row in uniqueConjugations) {
    val rootArBuckwalter = rootArBuckwalterByLeafId[row.rootLeafId]
    html.append("  <tr>\n")
    html.append("    <td>${row.leafId}</td>\n")
    html.append("    <td>${row.en}</td>\n")
    html.append("    <td class='ar-buckwalter'>${rootArBuckwalter}</td>\n")
    html.append("    <td class='ar-buckwalter' data-row-id='${row.leafId}'>${escapeHTML(row.arBuckwalter)}</td>\n")
    html.append("    <td><div id='ar-qalam-${row.leafId}' class='ar-qalam'></td>\n")
    html.append("    <td><div id='ar-monospace-${row.leafId}' class='ar-monospace'></td>\n")
    html.append("    <td>${row.gender}</td>\n")
    html.append("    <td>${row.number}</td>\n")
    html.append("    <td>${row.person}</td>\n")
    html.append("    <td>${row.tense}</td>\n")
    html.append("    <td><input type='submit' name='deleteLeaf${row.leafId}' value='Delete' onClick='return confirm(\"Delete unique conjugation?\")'></td>\n")
    html.append("  </tr>\n")
  }
  html.append("  <tr>\n")
  html.append("    <td></td>\n")
  html.append("    <td><input type='text' name='en'></td>\n")
  html.append("    <td><input type='text' name='root_ar_buckwalter' class='ar-buckwalter'></td>\n")
  html.append("    <td><input type='text' id='ar-buckwalter-new' name='ar_buckwalter' class='ar-buckwalter' data-row-id='new'></td>\n")
  html.append("    <td><input type='text' id='ar-qalam-new' data-row-id='new'></td>\n")
  html.append("    <td><input type='text' id='ar-monospace-new' class='ar-monospace'></td>\n")
  html.append("    <th><select name='gender'><option></option><option>M</option><option>F</option></select>\n")
  html.append("    <th><select name='number'><option></option><option>1</option><option>2</option></select>\n")
  html.append("    <th><select name='person'><option></option><option>1</option><option>2</option><option>3</option></select></td>\n")
  html.append("    <th><select name='tense'><option></option><option>PRES</option><option>PAST</option></select></td>\n")
  html.append("    <th><input type='submit' name='newUniqueConjugation' value='Insert'></td>\n")
  html.append("  </tr>\n")
  html.append("</table>\n")
  html.append("</form>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}