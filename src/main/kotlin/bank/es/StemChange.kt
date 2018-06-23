package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.es.Inf

data class StemChange (
  override val cardId: Int,
	val tense: Tense,
	val inf:   Inf,
	val stem:  String
): Card {
  fun getEnVerb(): String = when (tense) {
    Tense.PRES -> inf.enPresent
    Tense.PRET -> inf.enPast
  }
  override fun getChildrenCards(): List<Card> = listOf<Card>()
  override fun getGlossRows(): List<GlossRow> =
		listOf(GlossRow(cardId, getEnVerb(), stem))
  override fun getKey(): String = stem
}
