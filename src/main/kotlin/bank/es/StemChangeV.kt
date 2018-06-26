package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class StemChangeV (
  val stemChange: StemChange,
  val pattern: RegVPattern
): CardCreator, V {
  fun getEs(): String =
    stemChange.stem.substring(0, stemChange.stem.length - 1) +
    pattern.es.substring(1)
  override fun getGlossRows(): List<GlossRow> = 
    stemChange.getGlossRows() + pattern.getGlossRows()
  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " + EnVerbs.getEnVerbFor(
      stemChange.inf,
      pattern.number,
      pattern.person,
      pattern.tense)
}
