package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V
import com.danstutzman.bank.en.EnVerbs

data class ArV (
  val root: ArVRoot,
  val pattern: ArVPattern
): CardCreator, V {
  private val ROOT_REGEX = "^([^aeiou])([^aeiou])([i])?([^aeiou])$".toRegex()

  override fun explainDerivation(): String {
    val en = when (pattern.tense) {
      ArTense.PAST -> root.enPast
      ArTense.PRES -> root.enPresent
    }
    return "root=${root.arBuckwalter} en=${en} " +
      "gender=${pattern.gender} number=${pattern.number} " +
      "person=${pattern.person} tense=${pattern.tense}"
  }

  override fun getChildCardCreators(): List<CardCreator> =
    listOf(root, pattern) +
    root.getChildCardCreators() +
    pattern.getChildCardCreators()

  fun getArBuckwalter(): String {
    val stem = when (pattern.tense) {
      ArTense.PAST -> getPastStem()
      ArTense.PRES -> getPresStem()
    }
    return (
      if (pattern.prefixBuckwalter != null)
        pattern.prefixBuckwalter.substring(0,
          pattern.prefixBuckwalter.length - 1)
        else "") +
      stem.substring(0, stem.length - 1) +
      pattern.suffixBuckwalter.substring(1)
  }

  override fun getGlossRows(): List<GlossRow> {
    val rootGlossRow = when (pattern.tense) {
      ArTense.PAST -> GlossRow(root.leafId, root.enPast, getPastStem())
      ArTense.PRES -> GlossRow(root.leafId, root.enPresent, getPresStem())
    }
    return pattern.getPrefixGlossRows() +
      listOf(rootGlossRow) +
      pattern.getSuffixGlossRows()
  }

  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " + ArToEnVerbs.getEnVerbFor(
      root, pattern.number, pattern.person, pattern.tense)

  override fun serializeLeafIds(): String =
    "rootLeafId=${root.leafId} patternLeafId=${pattern.leafId}"

  private fun getPastStem(): String =
    "${root.c1}a${root.c2}${root.v2}${root.c3}-"

  private fun getPresStem(): String =
    "${root.c1}o${root.c2}${root.arPresMiddleVowelBuckwalter}${root.c3}-"
}