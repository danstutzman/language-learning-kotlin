package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow

data class Nonverb (
  val leafId: Int,
  val frMixed: String,
  val en: String
): CardCreator {
  override fun explainDerivation(): String =
    "nonverb=${frMixed} en=${en}"
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, frMixed))
  override fun getPrompt(): String = en
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
