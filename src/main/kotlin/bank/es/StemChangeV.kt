package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.Interpretation
import com.danstutzman.bank.V
import com.danstutzman.bank.en.EnVerbs

data class StemChangeV (
  val stemChange: StemChange,
  val pattern: RegVPattern
): CardCreator, V {
  override fun explainDerivation(): String {
    val en = stemChange.inf.enPresent +
      if (stemChange.inf.enDisambiguation != null)
        " (${stemChange.inf.enDisambiguation})" else ""
    return "infinitive=${stemChange.inf.esMixed} en=${en}" +
      "stemChange=${stemChange.esMixed} " +
      "number=${pattern.number} person=${pattern.person} tense=${pattern.tense}"
  }
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(stemChange, pattern) +
    stemChange.getChildCardCreators() +
    pattern.getChildCardCreators()
  fun getEsMixed(): String =
    stemChange.esMixed.substring(0, stemChange.esMixed.length - 1) +
    pattern.esLower.substring(1)
  override fun getGlossRows(): List<GlossRow> = 
    stemChange.getGlossRows() + pattern.getGlossRows()
  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " + EnVerbs.getEnVerbFor(
      stemChange.inf,
      pattern.number,
      pattern.person,
      pattern.tense)
  override fun serializeLeafIds(): String =
    "stemChangeLeafId=${stemChange.leafId} patternLeafId=${pattern.leafId}"
}
