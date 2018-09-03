package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V
import com.danstutzman.bank.en.EnVerbs

data class FrRegV (
  val inf: FrInf,
  val pattern: FrRegVPattern
): CardCreator, V {
  override fun explainDerivation(): String {
    val en = inf.enPresent
    return "infinitive=${inf.frMixed} en=${en} " +
      "number=${pattern.number} person=${pattern.person} tense=${pattern.tense}"
  }
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(inf, pattern) +
    inf.getChildCardCreators() +
    pattern.getChildCardCreators()
  fun getFrVerbPrefix(): String =
    inf.frMixed.substring(0, inf.frMixed.length - pattern.infCategory.length) +
    "-"
  fun getFrMixed(): String =
    inf.frMixed.substring(0, inf.frMixed.length - pattern.infCategory.length) +
    pattern.frLower.substring(1)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(inf.leafId,
      when (pattern.tense) {
        FrTense.PRES -> inf.enPresent
      },
      getFrVerbPrefix())) +
    pattern.getGlossRows()
  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " + FrToEnVerbs.getEnVerbFor(
      inf, pattern.number, pattern.person, pattern.tense)
    override fun serializeLeafIds(): String =
      "infLeafId=${inf.leafId} patternLeafId=${pattern.leafId}"
}
