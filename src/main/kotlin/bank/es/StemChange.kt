package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.es.Inf

data class StemChange (
  val leafId: Int,
  val tense: EsTense,
  val inf:   Inf,
  val esMixed:  String,
  val en: String,
  val enPast: String,
  val enDisambiguation: String
): CardCreator {
  override fun explainDerivation(): String =
    "inf=${inf.esMixed} enDisambiguation=${enDisambiguation} tense=${tense}"
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(inf) + inf.getChildCardCreators()
  fun getEnVerb(): String = when (tense) {
    EsTense.PRES -> en
    EsTense.PRET -> enPast
  }
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(
    leafId, getEnVerb(), esMixed))
  override fun getPrompt(): String =
    "Stem change for ${inf.esMixed} in ${tense}"
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
