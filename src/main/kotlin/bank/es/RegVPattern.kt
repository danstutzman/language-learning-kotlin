package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs

val NUMBER_TO_DESCRIPTION = linkedMapOf(
  1 to "singular",
  2 to "plural"
)

val PERSON_TO_DESCRIPTION = linkedMapOf(
  1 to "1st person",
  2 to "2nd person",
  3 to "3rd person"
)

data class RegVPattern (
  override val cardId: Int,
  val infCategory: InfCategory,
  val number: Int,
  val person: Int,
  val tense: Tense,
  val es: String
): Card {
  fun getEnPronoun(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
  override fun getKey(): String = "${infCategory}${number}${person}${tense}"
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, "(${getEnPronoun()})", es))
  override fun getQuizQuestion(): String {
    val enPronoun =
      EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
    val enVerbSuffix =
      EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
    return when (tense) {
      Tense.PRES -> when (infCategory) {
        InfCategory.AR   -> "(${enPronoun}) talk${enVerbSuffix}"
        InfCategory.ER   -> "(${enPronoun}) eat${enVerbSuffix}"
        InfCategory.ERIR -> "(${enPronoun}) eat${enVerbSuffix}"
        InfCategory.IR   -> "(${enPronoun}) live${enVerbSuffix}"
        InfCategory.STEMPRET -> throw RuntimeException("Shouldn't happen")
      }
      Tense.PRET -> when (infCategory) {
        InfCategory.AR   -> "(${enPronoun}) talked"
        InfCategory.ER   -> "(${enPronoun}) ate"
        InfCategory.ERIR -> "(${enPronoun}) ate"
        InfCategory.IR   -> "(${enPronoun}) lived"
        InfCategory.STEMPRET -> "(${enPronoun}) had"
      }
    }
  }
}
