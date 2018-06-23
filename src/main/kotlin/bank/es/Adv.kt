package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class Adv (
  override val cardId: Int,
  val es: String,
  val en: String
): Card {
  override fun getChildrenCards(): List<Card> = listOf<Card>()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(cardId, en, es))
  override fun getKey(): String = es
}