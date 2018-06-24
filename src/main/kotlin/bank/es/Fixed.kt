package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

// A Fixed is defined as a word that can't add a prefix or suffix
data class Fixed (
  override val cardId: Int,
  val es: String,
  val en: String
): Card {
  override fun getChildrenCards(): List<Card> = listOf<Card>()
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(cardId, en, es))
  override fun getKey(): String = es
}
