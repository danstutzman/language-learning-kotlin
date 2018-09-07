package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.ar.ArVRoot

data class ArStemChange (
  val leafId: Int,
  val tense: ArTense,
  val root: ArVRoot,
  val arBuckwalter: String,
  val en: String,
  val persons: List<Int>
): CardCreator {
  override fun explainDerivation(): String =
    "root=${root.arBuckwalter} tense=${tense} persons=${persons}"

  override fun getChildCardCreators(): List<CardCreator> =
    listOf(root) + root.getChildCardCreators()

  fun getEnVerb(): String = en

  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(
    leafId, getEnVerb(), arBuckwalter))

  override fun getPrompt(): String =
    "Stem change for ${root.arBuckwalter} in ${tense} for persons ${persons}"

  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
