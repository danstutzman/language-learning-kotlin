package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class RegV (
  val inf: Inf,
  val pattern: RegVPattern
): CardCreator, V {
  fun getEsVerbPrefix(): String = inf.es.substring(0, inf.es.length - 2) + "-"
  fun getEs(): String =
    inf.es.substring(0, inf.es.length - 2) + pattern.es.substring(1)
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
