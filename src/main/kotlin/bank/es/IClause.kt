package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns

val noGlossRows = listOf<GlossRow>()

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
