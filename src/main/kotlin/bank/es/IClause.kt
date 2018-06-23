package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

val noGlossRows = listOf<GlossRow>()
val noWords = listOf<String>()

fun capitalizeFirstLetter(s: String) =
  s.substring(0, 1).toUpperCase() + s.substring(1)

fun capitalizeAndAddPunctuation(words: List<String>, isQuestion: Boolean):
  List<String> =
  listOf(capitalizeFirstLetter(words[0])) +
  words.slice(1..(words.size - 1)) +
  listOf(words[words.size - 1] +
  if (isQuestion) "?" else ".")

data class IClause(
  override val cardId: Int,
  val subject: NP?,
  val v: V,
  val dObj: NP?,
  val advComp: Adv?,
  val isQuestion: Boolean
): Card {
  override fun getChildrenCards(): List<Card> =
    listOf(subject, v, dObj, advComp).filterNotNull()
  fun getEnAuxVerb(): String =
    when (v.getTense()) {
      Tense.PRES ->
        if (v.getNumber() == 1 && v.getPerson() == 3) "does" else "do"
      Tense.PRET -> "did"
    }
  override fun getEsWords(): List<String> = capitalizeAndAddPunctuation(
    (if (subject != null && !isQuestion) subject.getEsWords() else noWords) +
    v.getEsWords() +
    (if (dObj != null) dObj.getEsWords() else noWords) +
    (if (advComp != null) advComp.getEsWords() else noWords) +
    (if (subject != null && isQuestion) subject.getEsWords() else noWords),
    isQuestion)
  override fun getGlossRows(): List<GlossRow> =
    (if (subject != null && !isQuestion) subject.getGlossRows()
      else noGlossRows) +
    v.getGlossRows() +
    (if (dObj != null) dObj.getGlossRows() else noGlossRows) +
    (if (advComp != null) advComp.getGlossRows() else noGlossRows) +
    (if (subject != null && isQuestion) subject.getGlossRows() else noGlossRows)
  override fun getKey(): String =
    "subject=${subject?.getKey() ?: ""}," +
    "v=${v.getKey()}," +
    "dObj=${dObj?.getKey() ?: ""}," +
    "advComp=${advComp?.getKey() ?: ""}," +
    "isQuestion=${isQuestion}"
  override fun getQuizQuestion(): String {
    val subjectEn =
      if (subject == null) "SUBJECT" else subject.getQuizQuestion()
    return capitalizeFirstLetter(
      (if (isQuestion) getEnAuxVerb() + " " else "") +
      subjectEn + " " +
      (if (isQuestion) v.getEnVerbFor(2, 3, Tense.PRES)
        else v.getEnVerbFor(v.getNumber(), v.getPerson(), v.getTense())) +
      (if (dObj != null) " " + dObj.getQuizQuestion() else "") +
      (if (advComp != null) " " + advComp.getQuizQuestion() else "")
    ) + (if (isQuestion) "?" else ".")
  }
}
