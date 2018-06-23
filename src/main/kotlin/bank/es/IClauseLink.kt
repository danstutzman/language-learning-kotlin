package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

val noGlossRows = listOf<GlossRow>()
val noWords = listOf<String>()

data class IClauseLink(
  override val cardId: Int,
  val subject: NP?,
  val v: V,
  val nomComp: Card?,
  val advComp: Adv?,
  val isQuestion: Boolean
): Card {
  override fun getChildrenCards(): List<Card> =
    listOf(subject, v, nomComp, advComp).filterNotNull()
  override fun getEsWords(): List<String> = capitalizeAndAddPunctuation(
    (if (subject != null && !isQuestion) subject.getEsWords() else noWords) +
    v.getEsWords() +
    (if (nomComp != null) nomComp.getEsWords() else noWords) +
    (if (advComp != null) advComp.getEsWords() else noWords) +
    (if (subject != null && isQuestion) subject.getEsWords() else noWords),
    isQuestion)
  override fun getGlossRows(): List<GlossRow> =
    (if (subject != null && !isQuestion) subject.getGlossRows()
      else noGlossRows) +
    v.getGlossRows() +
    (if (nomComp != null) nomComp.getGlossRows() else noGlossRows) +
    (if (advComp != null) advComp.getGlossRows() else noGlossRows) +
    (if (subject != null && isQuestion) subject.getGlossRows() else noGlossRows)
  override fun getKey(): String =
    "subject=${subject?.getKey() ?: ""}," +
    "v=${v.getKey()}," +
    "nomComp=${nomComp?.getKey() ?: ""}," +
    "advComp=${advComp?.getKey() ?: ""}," +
    "isQuestion=${isQuestion}"
  override fun getQuizQuestion(): String = capitalizeFirstLetter(
    (if (subject != null && !isQuestion) subject.getQuizQuestion() + " "
      else "") +
    v.getEnVerb() +
    (if (subject != null && isQuestion) " " + subject.getQuizQuestion()
      else "") +
    (if (nomComp != null) " " + nomComp.getQuizQuestion() else "") +
    (if (advComp != null) " " + advComp.getQuizQuestion() else "")
  ) + (if (isQuestion) "?" else ".")
}
