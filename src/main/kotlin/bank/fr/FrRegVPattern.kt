package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs

data class FrRegVPattern (
  val leafId: Int,
  val infCategory: FrInfCategory,
  val number: Int,
  val person: Int,
  val tense: FrTense,
  val frLower: String
): CardCreator {
  override fun explainDerivation(): String =
    "infCategory=${infCategory} " +
    "number=${number} person=${person} tense=${tense}"
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  fun getEnPronoun(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, "(${getEnPronoun()})", frLower))
  override fun getPrompt(): String {
    val enPronoun = 
      EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
    val enVerbSuffix =
      EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
    return when (tense) {
      FrTense.PRES -> when (infCategory) {
        FrInfCategory.ER -> "(${enPronoun} speak${enVerbSuffix})"
        FrInfCategory.ENIR -> "(${enPronoun} come${enVerbSuffix})"
      }
    }
  }
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}