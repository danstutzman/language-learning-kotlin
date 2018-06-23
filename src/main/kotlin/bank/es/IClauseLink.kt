package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

data class IClauseLink(
  override val cardId: Int,
  val subject: NP?,
  val v: V,
  val nomComp: Card?,
  val advComp: Adv?
): Card {
  override fun getChildrenCards(): List<Card> =
    listOf(subject, v, nomComp, advComp).filterNotNull()
  override fun getEsWords(): List<String> = capitalizeAndAddPunctuation(
    (if (subject == null) listOf<String>() else subject.getEsWords()) +
    v.getEsWords() +
    (if (nomComp == null) listOf<String>() else nomComp.getEsWords()) +
    (if (advComp == null) listOf<String>() else advComp.getEsWords())
  )
  override fun getGlossRows(): List<GlossRow> =
    (if (subject == null) listOf<GlossRow>() else subject.getGlossRows()) +
    v.getGlossRows() +
    (if (nomComp == null) listOf<GlossRow>() else nomComp.getGlossRows()) +
    (if (advComp == null) listOf<GlossRow>() else advComp.getGlossRows())
  override fun getKey(): String =
    "subject=${subject?.getKey() ?: ""}," +
    "v=${v.getKey()}," +
    "nomComp=${nomComp?.getKey() ?: ""}," +
    "advComp=${advComp?.getKey() ?: ""}"
  override fun getQuizQuestion(): String = capitalizeFirstLetter(
    (if (subject == null) "" else (subject.getQuizQuestion() + " " )) +
    v.getEnVerb() +
    (if (nomComp == null) "" else (" " + nomComp.getQuizQuestion())) +
    (if (advComp == null) "" else (" " + advComp.getQuizQuestion()))
  ) + "."
}
