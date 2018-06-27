package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class StemChangeV (
  val stemChange: StemChange,
  val pattern: RegVPattern
): CardCreator, V {
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
}
