package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class IClauseLink(
  override val cardId: Int,
  val subject: NP?,
  val v: V,
  val predNomOrAdj: Card
): Card {
  override fun getChildrenCards(): List<Card> =
    if (subject == null) listOf<Card>() else listOf(subject) +
    listOf(v) +
    listOf(predNomOrAdj)
  override fun getEsWords(): List<String> = capitalizeAndAddPunctuation(
    if (subject == null) listOf<String>() else subject.getEsWords() +
    v.getEsWords() +
    predNomOrAdj.getEsWords()
  )
  override fun getGlossRows(): List<GlossRow> =
    if (subject == null) listOf<GlossRow>() else subject.getGlossRows() +
    v.getGlossRows() +
    predNomOrAdj.getGlossRows()
  override fun getKey(): String =
    "subject=${subject?.getKey()} " +
    "v=${v.getKey()} " +
    "predNomOrAdj=${predNomOrAdj.getKey()}"
  override fun getQuizQuestion(): String = capitalizeFirstLetter(
    if (subject == null) "" else (subject.getQuizQuestion() + " " ) +
    v.getEnVerb() +
    " " + predNomOrAdj.getQuizQuestion()
  ) + "."
}
