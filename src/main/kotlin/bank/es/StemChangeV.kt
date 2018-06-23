package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class StemChangeV (
  override val cardId: Int,
  val stemChange: StemChange,
  val pattern: RegVPattern
): Card, V {
  override fun getChildrenCardIds(): List<Int> =
    listOf(stemChange.cardId, pattern.cardId)
  override fun getEnVerb() =
    stemChange.inf.getEnVerbFor(pattern.number, pattern.person, pattern.tense)
  fun getEs(): String =
    stemChange.stem.substring(0, stemChange.stem.length - 1) +
    pattern.es.substring(1)
  override fun getEsWords(): List<String> = listOf(getEs())
  override fun getGlossRows(): List<GlossRow> = 
    listOf(GlossRow(stemChange.cardId, getEnVerb(), stemChange.stem)) +
    pattern.getGlossRows()
  override fun getKey(): String = "${stemChange.getKey()}${pattern.getKey()}"
  override fun getQuizQuestion(): String =
    "(${pattern.getEnPronoun()}) ${getEnVerb()}"
}
