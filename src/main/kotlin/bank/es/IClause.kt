package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns

val noGlossRows = listOf<GlossRow>()
val noWords = listOf<String>()

data class IClause(
  override val cardId: Int,
  val prompt: String,
  val subject: NP?,
  val v: V,
  val dObj: NP?,
  val advComp: Adv?,
  val isQuestion: Boolean
): Card {
  override fun getChildrenCards(): List<Card> =
    listOf(subject, v, dObj, advComp).filterNotNull()
  override fun getEsWords(): List<String> =
    (if (subject != null && !isQuestion) subject.getEsWords() else noWords) +
    v.getEsWords() +
    (if (dObj != null) dObj.getEsWords() else noWords) +
    (if (advComp != null) advComp.getEsWords() else noWords) +
    (if (subject != null && isQuestion) subject.getEsWords() else noWords)
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
}
