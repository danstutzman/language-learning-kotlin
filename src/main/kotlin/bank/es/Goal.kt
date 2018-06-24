package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class Goal(
  override val cardId: Int,
  val prompt: String,
  val cards: List<Card>
): Card {
  override fun getChildrenCards(): List<Card> = cards
  override fun getGlossRows(): List<GlossRow> =
    cards.flatMap { it.getGlossRows() }
  override fun getKey(): String =
    cards.flatMap { it.getGlossRows() }.map { it.es }.joinToString(",")
}