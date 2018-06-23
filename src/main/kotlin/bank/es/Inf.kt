package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class Inf (
  override val cardId: Int,
  val es: String,
  val enPresent: String,
  val enPast: String,
  val enDisambiguation: String?
): Card, V {
  override fun getChildrenCards(): List<Card> = listOf()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getKey(): String = es
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, enPresent, es))
}
