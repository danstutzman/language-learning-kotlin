package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
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
  val leafId: Int,
  val infCategory: InfCategory,
  val number: Int,
  val person: Int,
  val tense: Tense,
  val esLower: String
): CardCreator {
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  fun getEnPronoun(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, "(${getEnPronoun()})", esLower))
  override fun getPrompt(): String {
    val enPronoun = 
      EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
    val enVerbSuffix =
      EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
    return when (tense) {
      Tense.PRES -> when (infCategory) {
        InfCategory.AR   -> "(${enPronoun} work${enVerbSuffix})"
        InfCategory.ER   -> "(${enPronoun} learn${enVerbSuffix})"
        InfCategory.ERIR -> "(${enPronoun} learn${enVerbSuffix})"
        InfCategory.IR   -> "(${enPronoun} live${enVerbSuffix})"
        InfCategory.STEMPRET -> throw RuntimeException("Shouldn't happen")
      }
      Tense.PRET -> when (infCategory) {
        InfCategory.AR   -> "(${enPronoun} worked)"
        InfCategory.ER   -> "(${enPronoun} learned)"
        InfCategory.ERIR -> "(${enPronoun} learned)"
        InfCategory.IR   -> "(${enPronoun} lived)"
        InfCategory.STEMPRET -> "(${enPronoun} had)"
      }
    }
  }
}
