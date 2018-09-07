package com.danstutzman.templates

import com.danstutzman.db.Goal
import com.danstutzman.db.Paragraph

fun GetParagraph(lang: String, paragraph: Paragraph, goals: List<Goal>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)

  html.append("<a href='/${lang}/paragraphs'>Back to paragraphs</a>\n")
  html.append("<h1>Edit Paragraph ${paragraph.paragraphId}</h1>\n")
  html.append("<form method='POST' action='/${lang}/paragraphs/${paragraph.paragraphId}'>\n")
  html.append("  <label for='en'>Topic</label><br>\n")
  html.append("  <input type='text' name='topic' value='${escapeHTML(paragraph.topic)}'><br>\n")
  html.append("  <label for='enabled'>Enabled</label><br>\n")
  html.append("  <input type='checkbox' name='enabled' ${if (paragraph.enabled) "checked" else ""}><br>\n")
  html.append("  <input type='submit' name='submit' value='Update Paragraph'>\n")
  html.append("  <input type='submit' name='submit' value='Delete Paragraph' onClick='return confirm(\"Delete paragraph?\")'>\n")
  html.append("</form>\n")
  html.append("<hr>")

  html.append("<form method='POST' action='/${lang}/paragraphs/${paragraph.paragraphId}/disambiguate-goal'>\n")
  html.append("  <table>\n")
  html.append("    <tr>\n")
  html.append("      <th>Goal ID</th>\n")
  html.append("      <th>English</th>\n")
  if (lang == "ar") {
    html.append("      <th>Arabic (Buckwalter)</th>\n")
    html.append("      <th>Arabic (Monospace)</th>\n")
    html.append("      <th>Pronunciation (Qalam)</th>\n")
  } else {
    html.append("      <th>L2</th>\n")
  }
  html.append("    </tr>\n")
  for (goal in goals) {
    html.append("    <tr>")
    html.append("      <td>${goal.goalId}</td>\n")
    html.append("      <td>${goal.en}</td>\n")
    if (lang == "ar") {
      html.append("    <td class='ar-buckwalter' data-row-id='${goal.goalId}'>${escapeHTML(goal.l2)}</td>\n")
      html.append("    <td><div id='ar-monospace-${goal.goalId}' class='ar-monospace'></td>\n")
      html.append("    <td><div id='ar-qalam-${goal.goalId}' class='ar-qalam'></td>\n")
    }
    else {
      html.append("      <td>${goal.l2}</td>\n")
    }
    html.append("    </tr>")
  }
  html.append("    <tr>")
  html.append("      <td>New</td>\n")
  html.append("      <td><input type='text' name='en' value=''></td>\n")
  if (lang == "ar") {
    html.append("    <td><input type='text' id='ar-buckwalter-new' name='l2' class='ar-buckwalter' data-row-id='new'></td>\n")
    html.append("    <td><input type='text' id='ar-monospace-new' class='ar-monospace' data-row-id='new'></td>\n")
    html.append("    <td><input type='text' id='ar-qalam-new'></td>\n")
  } else {
    html.append("      <td><input type='text' name='l2' value=''></td>\n")
  }
  html.append("      <td><input type='submit' name='submit' value='Add Goal to Paragraph'></td>\n")
  html.append("    </tr>")
  html.append("  </table>\n")
  html.append("</form>\n")

  html.append(CLOSE_BODY_TAG)
  return html.toString()
}