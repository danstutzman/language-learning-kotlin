package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class Inf (
  override val cardId: Int,
  val es: String,
  val enPresent: String,
  val enPast: String,
  val enDisambiguation: String?
): Card, V {
  override fun getChildrenCardIds(): List<Int> = listOf()
  override fun getEnVerb(): String = enPresent
  fun getEnVerbFor(number: Int, person: Int, tense: Tense): String =
    when (tense) {
      Tense.PRES ->
        enPresent +
        EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
      Tense.PRET -> enPast
    } + if (enDisambiguation != null) " ${enDisambiguation}" else ""
  override fun getEsWords(): List<String> = listOf(es)
  override fun getKey(): String = es
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, enPresent, es))
  override fun getQuizQuestion(): String =
    if (enPresent == "can") "to be able to" else "to ${enPresent}" +
    if (enDisambiguation != null) " (${enDisambiguation})" else ""
}
