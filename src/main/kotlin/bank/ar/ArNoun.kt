package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow

data class ArNoun (
  val leafId: Int,
  val arBuckwalter: String,
  val en: String,
  val gender: ArGender
): CardCreator {
  override fun explainDerivation(): String = "en=${en}"

  override fun getChildCardCreators(): List<CardCreator> =
    listOf<CardCreator>()

  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, arBuckwalter))

  override fun getPrompt(): String = en

  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
