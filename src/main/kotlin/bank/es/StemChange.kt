package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.es.Inf

data class StemChange (
  val leafId: Int,
	val tense: Tense,
	val inf:   Inf,
	val stem:  String
): CardCreator {
  fun getEnVerb(): String = when (tense) {
    Tense.PRES -> inf.enPresent
    Tense.PRET -> inf.enPast
  }
  override fun getGlossRows(): List<GlossRow> =
		listOf(GlossRow(leafId, getEnVerb(), stem))
  override fun getPrompt(): String = "Stem change for ${inf.es} in ${tense}"
}
