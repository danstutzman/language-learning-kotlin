package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

// An Entry is a word that's not a verb
data class Entry (
  override val cardId: Int,
  val es: String,
  val en: String,
  val enDisambiguation: String?
): Card {
  override fun getChildrenCards(): List<Card> = listOf<Card>()
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(cardId, en, es))
  override fun getKey(): String = es
}
