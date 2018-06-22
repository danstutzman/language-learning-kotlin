package es

import en.EnVerbs
import seeds.Card
import seeds.GlossRow

data class Inf (
  override val cardId: Int,
  val es: String,
  val enPresent: String,
  val enPast: String,
  val enDisambiguation: String?
): Card {
  override fun getChildrenCardIds(): List<Int> = listOf()
  fun getEnVerb(number: Int, person: Int, tense: Tense): String =
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
    "to ${enPresent}" +
    if (enDisambiguation != null) " (${enDisambiguation})" else ""
}
