package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.Interpretation
import com.danstutzman.bank.V

data class FrStemChangeV (
  val stemChange: FrStemChange,
  val pattern: FrRegVPattern
): CardCreator, V {
  override fun explainDerivation(): String {
    val en = stemChange.inf.enPresent
    return "infinitive=${stemChange.inf.frMixed} en=${en} " +
      "stemChange=${stemChange.frMixed} " +
      "number=${pattern.number} person=${pattern.person} tense=${pattern.tense}"
  }
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(stemChange, pattern) +
    stemChange.getChildCardCreators() +
    pattern.getChildCardCreators()
  fun getFrMixed(): String =
    stemChange.frMixed.substring(0, stemChange.frMixed.length - 1) +
    pattern.frLower.substring(1)
  override fun getGlossRows(): List<GlossRow> = 
    stemChange.getGlossRows() + pattern.getGlossRows()
  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " + FrToEnVerbs.getEnVerbFor(
      stemChange.inf,
      pattern.number,
      pattern.person,
      pattern.tense)
  override fun serializeLeafIds(): String =
    "stemChangeLeafId=${stemChange.leafId} patternLeafId=${pattern.leafId}"
}