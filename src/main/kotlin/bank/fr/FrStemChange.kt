package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.fr.FrInf

data class FrStemChange (
  val leafId: Int,
  val tense: FrTense,
  val inf:   FrInf,
  val frMixed:  String,
  val en: String,
  val enPast: String
): CardCreator {
  override fun explainDerivation(): String =
    "inf=${inf.frMixed} tense=${tense}"
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(inf) + inf.getChildCardCreators()
  fun getEnVerb(): String = when (tense) {
    FrTense.PRES -> en
  }
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(
    leafId, getEnVerb(), frMixed))
  override fun getPrompt(): String =
    "Stem change for ${inf.frMixed} in ${tense}"
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
