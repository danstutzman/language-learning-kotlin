package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

// A flexible is a noun or adjective
// Its ending can change to reflect gender or pluralization
data class Flexible (
  override val cardId: Int,
  val es: String,
  val en: String
): Card {
  override fun getChildrenCards(): List<Card> = listOf<Card>()
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(cardId, en, es))
  override fun getKey(): String = es
}
