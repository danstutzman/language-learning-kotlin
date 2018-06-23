package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class StemChangeV (
  override val cardId: Int,
  val stemChange: StemChange,
  val pattern: RegVPattern
): Card, V {
  override fun getChildrenCards(): List<Card> = listOf(stemChange, pattern)
  fun getEs(): String =
    stemChange.stem.substring(0, stemChange.stem.length - 1) +
    pattern.es.substring(1)
  override fun getGlossRows(): List<GlossRow> = 
    stemChange.getGlossRows() + pattern.getGlossRows()
  override fun getKey(): String = "${stemChange.getKey()}${pattern.getKey()}"
}
