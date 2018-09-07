package com.danstutzman.templates

import com.danstutzman.db.ArStemChange

fun GetArStemChanges(
  stemChanges: List<ArStemChange>,
  rootArBuckwalterByLeafId: Map<Int, String>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<h1>Arabic Stem Changes</h1>\n")
  html.append("<form method='POST' action='/ar/stem-changes'>\n")
  html.append("<table border='1'>\n")
  html.append("  <tr>\n")
  html.append("    <th>LeafId</td>\n")
  html.append("    <th>English</td>\n")
  html.append("    <th>Root Buckwalter</td>\n")
  html.append("    <th>Buckwalter</td>\n")
  html.append("    <th>Pronunciation (Qalam)</td>\n")
  html.append("    <th>Monospace</td>\n")
  html.append("    <th>Tense</td>\n")
  html.append("    <th>Persons</td>\n")
  html.append("    <th></td>\n")
  html.append("  </tr>\n")
  for (row in stemChanges) {
    val rootArBuckwalter = rootArBuckwalterByLeafId[row.rootLeafId]
    html.append("  <tr>\n")
    html.append("    <td>${row.leafId}</td>\n")
    html.append("    <td>${row.en}</td>\n")
    html.append("    <td class='ar-buckwalter'>${rootArBuckwalter}</td>\n")
    html.append("    <td class='ar-buckwalter' data-row-id='${row.leafId}'>${escapeHTML(row.arBuckwalter)}</td>\n")
    html.append("    <td><div id='ar-qalam-${row.leafId}' class='ar-qalam'></td>\n")
    html.append("    <td><div id='ar-monospace-${row.leafId}' class='ar-monospace'></td>\n")
    html.append("    <td>${row.tense}</td>\n")
    html.append("    <td>${row.personsCsv}</td>\n")
    html.append("    <td><input type='submit' name='deleteLeaf${row.leafId}' value='Delete' onClick='return confirm(\"Delete stem change?\")'></td>\n")
    html.append("  </tr>\n")
  }
  html.append("  <tr>\n")
  html.append("    <th></td>\n")
  html.append("    <td><input type='text' name='en'></td>\n")
  html.append("    <td><input type='text' name='root_ar_buckwalter' class='ar-buckwalter'></td>\n")
  html.append("    <td><input type='text' id='ar-buckwalter-new' name='ar_buckwalter' class='ar-buckwalter' data-row-id='new'></td>\n")
  html.append("    <td><input type='text' id='ar-qalam-new'></td>\n")
  html.append("    <td><input type='text' id='ar-monospace-new' class='ar-monospace' data-row-id='new'></td>\n")
  html.append("    <td><select name='tense'><option></option><option>PRES</option><option>PAST</option></select></td>\n")
  html.append("    <td><select name='persons_csv'><option></option><option>1,2,3</option><option>1,2</option><option>3</option></select></td>\n")
  html.append("    <td><input type='submit' name='newStemChange' value='Insert'></td>\n")
  html.append("  </tr>\n")
  html.append("</table>\n")
  html.append("</form>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}