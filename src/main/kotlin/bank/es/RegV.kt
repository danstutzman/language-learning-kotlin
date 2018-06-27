package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class RegV (
  val inf: Inf,
  val pattern: RegVPattern
): CardCreator, V {
  fun getEsVerbPrefix(): String =
    inf.esMixed.substring(0, inf.esMixed.length - 2) + "-"
  fun getEsMixed(): String =
    inf.esMixed.substring(0, inf.esMixed.length - 2) +
    pattern.esLower.substring(1)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(inf.leafId,
      when (pattern.tense) {
        Tense.PRES -> inf.enPresent
        Tense.PRET -> inf.enPast
      },
      getEsVerbPrefix())) +
    pattern.getGlossRows()
  override fun getPrompt(): String =
    "(${pattern.getEnPronoun()}) " +
      EnVerbs.getEnVerbFor(inf, pattern.number, pattern.person, pattern.tense)
}
