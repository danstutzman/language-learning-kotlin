package com.danstutzman.templates

import com.danstutzman.bank.Interpretation

fun PostParagraphDisambiguateGoal(
  paragraphId: Int,
  phraseEn: String,
  phraseEs: String,
  words: List<String>,
  interpretationsByWordNum: List<List<Interpretation>>
): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<a href='/'>Back to home</a>\n")
  html.append("<form method='POST' action='/paragraphs/${paragraphId}/add-goal'>\n")
  html.append("<h1>Disambiguate Goal</h1>\n")
  html.append("<p>Phrase to disambiguate is: <i>${escapeHTML(phraseEs)}</i></p>\n")
  html.append("<input type='hidden' name='en' value='${escapeHTML(phraseEn)}'>\n")
  html.append("<input type='hidden' name='es' value='${escapeHTML(phraseEs)}'>\n")
  for ((wordNum, word) in words.withIndex()) {
    val interpretations = interpretationsByWordNum[wordNum]
    val existingInterpretations = interpretations.filter { it.cardCreator != null }
    val bestInterpretation: Interpretation? =
      if (existingInterpretations.size == 1) existingInterpretations[0]
      else if (interpretations.size == 1) interpretations[0]
      else null

    html.append("<h2>${word}</h2>")
    for ((interpretationNum, interpretation) in
      interpretations.sortedBy { it.cardCreator == null }.withIndex()) {
      val checked = if (interpretation == bestInterpretation) "checked='checked'" else ""
      if (interpretation.cardCreator != null) {
        html.append("<input type='radio' name='word.${wordNum}' value='${interpretationNum}' ${checked}>")
        html.append("<input type='hidden' name='word.${wordNum}.${interpretationNum}.leafIds' value='${escapeHTML(interpretation.cardCreator.serializeLeafIds())}'>")
        html.append("<input type='hidden' name='word.${wordNum}.${interpretationNum}.exists' value='true'>")
        html.append("Use existing ${interpretation.type} (${interpretation.cardCreator.explainDerivation()})")
      } else {
        html.append("<input type='radio' name='word.${wordNum}' value='${interpretationNum}' ${checked}>")
        html.append("<input type='hidden' name='word.${wordNum}.${interpretationNum}.exists' value='false'>")
        html.append("Add new ${interpretation.type}")
        html.append("<input type='text' name='word.${wordNum}.${interpretationNum}.es' value='${escapeHTML(word)}'> (check case)")
        html.append("<input type='text' name='word.${wordNum}.${interpretationNum}.en' placeholder='English'>")
        html.append("<input type='text' name='word.${wordNum}.${interpretationNum}.enDisambiguation' placeholder='English disambiguation (optional)'>")
        html.append("<input type='text' name='word.${wordNum}.${interpretationNum}.enPlural' placeholder='English plural (optional)'>")
      }
      html.append("<input type='hidden' name='word.${wordNum}.${interpretationNum}.type' value='${interpretation.type}'>")
      html.append("<br>")
    }
  }
  html.append("<p><input type='submit' name='submit' value='Add Goal'></p>")
  html.append("</form>")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}