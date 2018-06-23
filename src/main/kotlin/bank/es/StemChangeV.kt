package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class StemChangeV (
  override val cardId: Int,
  val stemChange: StemChange,
  val pattern: RegVPattern
): Card, V {
  override fun getChildrenCards(): List<Card> = listOf(stemChange, pattern)
  override fun getEnVerbFor(number: Int, person: Int, tense: Tense) =
    stemChange.inf.getEnVerbFor(number, person, tense)
  fun getEs(): String =
    stemChange.stem.substring(0, stemChange.stem.length - 1) +
    pattern.es.substring(1)
  override fun getEsWords(): List<String> = listOf(getEs())
  override fun getGlossRows(): List<GlossRow> = 
    listOf(GlossRow(
      stemChange.cardId,
      getEnVerbFor(getNumber(), getPerson(), getTense()),
      stemChange.stem)) +
    pattern.getGlossRows()
  override fun getKey(): String = "${stemChange.getKey()}${pattern.getKey()}"
  override fun getNumber(): Int = pattern.number
  override fun getPerson(): Int = pattern.person
  override fun getQuizQuestion(): String =
    "(${pattern.getEnPronoun()}) " +
    getEnVerbFor(getNumber(), getPerson(), getTense())
  override fun getTense(): Tense = pattern.tense
}
