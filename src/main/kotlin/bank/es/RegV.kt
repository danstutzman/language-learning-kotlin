package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class RegV (
  override val cardId: Int,
  val inf: Inf,
  val pattern: RegVPattern
): Card, V {
  fun getEsVerbPrefix(): String = inf.es.substring(0, inf.es.length - 2) + "-"
  override fun getChildrenCards(): List<Card> = listOf(inf, pattern)
  fun getEs(): String =
    inf.es.substring(0, inf.es.length - 2) + pattern.es.substring(1)
  override fun getEnVerbFor(number: Int, person: Int, tense: Tense) =
    inf.getEnVerbFor(number, person, tense)
  override fun getEsWords(): List<String> = listOf(getEs())
  override fun getGlossRows(): List<GlossRow> = listOf(
    GlossRow(inf.cardId,
      getEnVerbFor(getNumber(), getPerson(), getTense()),
      getEsVerbPrefix())) +
    pattern.getGlossRows()
  override fun getKey(): String = "${inf.getKey()}${pattern.getKey()}"
  override fun getNumber(): Int = pattern.number
  override fun getPerson(): Int = pattern.person
  override fun getQuizQuestion(): String =
    "(${pattern.getEnPronoun()}) " + 
    getEnVerbFor(getNumber(), getPerson(), getTense())
  override fun getTense(): Tense = pattern.tense
}
