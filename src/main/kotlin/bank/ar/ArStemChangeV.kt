package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.Interpretation
import com.danstutzman.bank.V

data class ArStemChangeV (
  val stemChange: ArStemChange,
  val pattern: ArVPattern
): CardCreator, V {
  override fun explainDerivation(): String =
    "root=${stemChange.root.arBuckwalter} en=${stemChange.en} " +
      "stemChange=${stemChange.arBuckwalter} gender=${pattern.gender} " +
      "number=${pattern.number} person=${pattern.person} tense=${pattern.tense}"

  override fun getChildCardCreators(): List<CardCreator> =
    listOf(stemChange, pattern) +
    stemChange.getChildCardCreators() +
    pattern.getChildCardCreators()

  fun getArBuckwalter(): String =
    (if (pattern.prefixBuckwalter != null)
        pattern.prefixBuckwalter.substring(0,
          pattern.prefixBuckwalter.length - 1)
        else "") +
      stemChange.arBuckwalter.substring(0, stemChange.arBuckwalter.length - 1) +
      pattern.suffixBuckwalter.substring(1)

  override fun getGlossRows(): List<GlossRow> = 
    pattern.getPrefixGlossRows() +
      stemChange.getGlossRows() +
      pattern.getSuffixGlossRows()

  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " + ArToEnVerbs.getEnVerbFor(
      stemChange.root,
      pattern.number,
      pattern.person,
      pattern.tense)

  override fun serializeLeafIds(): String =
    "stemChangeLeafId=${stemChange.leafId} patternLeafId=${pattern.leafId}"
}