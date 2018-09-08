package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow

data class ArCompoundNoun (
  val noun: ArNoun,
  val case: ArNounCase?,
  val suffixPronoun: ArSuffixPronoun?
): CardCreator {
  override fun explainDerivation(): String =
    "noun=${noun.arBuckwalter}" +
    (if (case != null) " case=${case.arBuckwalter} " else "") +
    (if (suffixPronoun != null) " suffixPronoun=${suffixPronoun.arBuckwalter}"
      else "")

  override fun getChildCardCreators(): List<CardCreator> =
    listOf(noun) +
    noun.getChildCardCreators() +
    (if (case != null) listOf(case) else listOf<CardCreator>()) +
    (if (case != null) case.getChildCardCreators() else listOf<CardCreator>()) +
    (if (suffixPronoun != null) listOf(suffixPronoun)
      else listOf<CardCreator>()) +
    (if (suffixPronoun != null) suffixPronoun.getChildCardCreators()
      else listOf<CardCreator>())

  fun getArBuckwalter(): String =
    noun.arBuckwalter +
    (if (case != null) case.arBuckwalter.substring(1) else "") +
    (if (suffixPronoun != null) suffixPronoun.arBuckwalter.substring(1) else "")

  override fun getGlossRows(): List<GlossRow> =
    noun.getGlossRows() +
    (if (case != null) case.getGlossRows() else listOf<GlossRow>()) +
    (if (suffixPronoun != null) suffixPronoun.getGlossRows()
      else listOf<GlossRow>())

  override fun getPrompt(): String =
    "${noun.en}" +
    (if (case != null) " (${case.enGloss})" else "") +
    (if (suffixPronoun != null) " (${suffixPronoun.getEnPronoun()})" else "")

  override fun serializeLeafIds(): String =
    "nounLeafId=${noun.leafId}" +
    (if (case != null) " caseLeafId=${case.leafId}" else "") +
    (if (suffixPronoun != null)
      " suffixPronoun=${suffixPronoun.leafId}" else "")
}