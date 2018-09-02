package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V

data class FrInf (
  val leafId: Int,
  val frMixed: String,
  val enPresent: String,
  val enPast: String
): CardCreator, V {
  override fun explainDerivation(): String =
    "infinitive=${frMixed} enPresent=${enPresent}"
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, enPresent, frMixed))
  override fun getPrompt(): String = "to ${enPresent}"
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
