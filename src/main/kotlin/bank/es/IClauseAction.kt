package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

fun capitalizeFirstLetter(s: String) =
  s.substring(0, 1).toUpperCase() + s.substring(1)

fun capitalizeAndAddPunctuation(words: List<String>, isQuestion: Boolean):
  List<String> =
  listOf(capitalizeFirstLetter(words[0])) +
  words.slice(1..(words.size - 1)) +
  listOf(words[words.size - 1] +
  if (isQuestion) "?" else ".")

data class IClauseAction(
  override val cardId: Int,
  val agent: NP?,
  val v: V,
  val dObj: NP?,
  val isQuestion: Boolean
): Card {
  override fun getChildrenCards(): List<Card> =
    listOf(agent, v, dObj).filterNotNull()
  override fun getEsWords(): List<String> = capitalizeAndAddPunctuation(
    (if (agent != null && !isQuestion) agent.getEsWords() else noWords) +
    v.getEsWords() +
    (if (dObj != null) dObj.getEsWords() else noWords) +
    (if (agent != null && isQuestion) agent.getEsWords() else noWords),
    isQuestion)
  override fun getGlossRows(): List<GlossRow> =
    (if (agent != null && !isQuestion) agent.getGlossRows() else noGlossRows) +
    v.getGlossRows() +
    (if (dObj != null) dObj.getGlossRows() else noGlossRows) +
    (if (agent != null && isQuestion) agent.getGlossRows() else noGlossRows)
  override fun getKey(): String =
    "agent=${agent?.getKey()}," +
    "v=${v.getKey()}," +
    "dObj=${dObj?.getKey() ?: ""}," +
    "isQuestion=${isQuestion}"
  override fun getQuizQuestion(): String = capitalizeFirstLetter(
    (if (agent != null && !isQuestion) agent.getQuizQuestion() + " " else "") +
    v.getEnVerb() +
    (if (agent != null && isQuestion) " " + agent.getQuizQuestion() else "") +
    (if (dObj != null) " " + dObj.getQuizQuestion() else "")
  ) + (if (isQuestion) "?" else ".")
}
