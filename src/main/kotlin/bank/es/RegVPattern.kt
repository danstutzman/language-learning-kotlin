package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs

data class RegVPattern (
  val leafId: Int,
  val infCategory: InfCategory,
  val number: Int,
  val person: Int,
  val tense: EsTense,
  val esLower: String
): CardCreator {
  override fun explainDerivation(): String =
    "infCategory=${infCategory} " +
    "number=${number} person=${person} tense=${tense}"
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
      EsTense.PRES -> when (infCategory) {
        InfCategory.AR   -> "(${enPronoun} work${enVerbSuffix})"
        InfCategory.ER   -> "(${enPronoun} learn${enVerbSuffix})"
        InfCategory.ERIR -> "(${enPronoun} learn${enVerbSuffix})"
        InfCategory.IR   -> "(${enPronoun} live${enVerbSuffix})"
        InfCategory.STEMPRET -> throw RuntimeException("Shouldn't happen")
      }
      EsTense.PRET -> when (infCategory) {
        InfCategory.AR   -> "(${enPronoun} worked)"
        InfCategory.ER   -> "(${enPronoun} learned)"
        InfCategory.ERIR -> "(${enPronoun} learned)"
        InfCategory.IR   -> "(${enPronoun} lived)"
        InfCategory.STEMPRET -> "(${enPronoun} had)"
      }
    }
  }
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
