package com.danstutzman.templates

import com.danstutzman.db.Goal
import com.danstutzman.db.Paragraph

fun GetParagraph(paragraph: Paragraph, goals: List<Goal>): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)

  html.append("<a href='/paragraphs'>Back to paragraphs</a>\n")
  html.append("<h1>Edit Paragraph ${paragraph.paragraphId}</h1>\n")
  html.append("<form method='POST' action='/paragraphs/${paragraph.paragraphId}'>\n")
  html.append("  <label for='en'>Topic</label><br>\n")
  html.append("  <input type='text' name='topic' value='${escapeHTML(paragraph.topic)}'><br>\n")
  html.append("  <label for='enabled'>Enabled</label><br>\n")
  html.append("  <input type='checkbox' name='enabled' ${if (paragraph.enabled) "checked" else ""}><br>\n")
  html.append("  <input type='submit' name='submit' value='Update Paragraph'>\n")
  html.append("  <input type='submit' name='submit' value='Delete Paragraph' onClick='return confirm(\"Delete paragraph?\")'>\n")
  html.append("</form>\n")
  html.append("<hr>")

  html.append("<form method='POST' action='/paragraphs/${paragraph.paragraphId}/disambiguate-goal'>\n")
  html.append("  <table>\n")
  html.append("    <tr>\n")
  html.append("      <th>Goal ID</th>\n")
  html.append("      <th>English</th>\n")
  html.append("      <th>Spanish</th>\n")
  html.append("    </tr>\n")
  for (goal in goals) {
    html.append("    <tr>")
    html.append("      <td>${goal.goalId}</td>\n")
    html.append("      <td>${goal.en}</td>\n")
    html.append("      <td>${goal.es}</td>\n")
    html.append("    </tr>")
  }
  html.append("    <tr>")
  html.append("      <td>New</td>\n")
  html.append("      <td><input type='text' name='en' value=''></td>\n")
  html.append("      <td><input type='text' name='es' value=''></td>\n")
  html.append("      <td><input type='submit' name='submit' value='Add Goal to Paragraph'></td>\n")
  html.append("    </tr>")
  html.append("  </table>\n")
  html.append("</form>\n")

  html.append(CLOSE_BODY_TAG)
  return html.toString()
}