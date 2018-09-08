package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs

data class ArNounCase (
  val leafId: Int,
  val enGloss: String,
  val arBuckwalter: String
): CardCreator {
  override fun explainDerivation(): String = "case=$arBuckwalter"

  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()

  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, enGloss, arBuckwalter))

  override fun getPrompt(): String = "Case ending for $enGloss"

  override fun serializeLeafIds(): String = "leafId=$leafId"
}