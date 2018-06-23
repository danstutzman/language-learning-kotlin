package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class NClause(
  override val cardId: Int,
  val prompt: String,
  val headEs: String,
  val headEn: String,
  val iClause: IClause,
  val isQuestion: Boolean
): Card {
  override fun getChildrenCards(): List<Card> = listOf(iClause)
  override fun getEsWords(): List<String> =
    listOf(headEs) + iClause.getEsWords()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(0, headEn, headEs)) +
    iClause.getGlossRows()
  override fun getKey(): String =
    "headEs=${headEs}," +
    "headEn=${headEn}," +
    "iClause=${iClause.getKey()}"
}
