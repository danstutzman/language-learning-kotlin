package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow

fun capitalizeFirstLetter(s: String) =
  s.substring(0, 1).toUpperCase() + s.substring(1)

fun capitalizeAndAddPunctuation(words: List<String>): List<String> =
  listOf(capitalizeFirstLetter(words[0])) +
  words.slice(1..(words.size - 1)) +
  listOf(words[words.size - 1] + ".")

data class IClauseAction(
  override val cardId: Int,
  val agent: NP?,
  val v: V,
  val dObj: NP?
): Card {
  override fun getChildrenCards(): List<Card> =
    if (agent == null) listOf<Card>() else listOf(agent) +
    listOf(v) +
    if (dObj == null) listOf() else listOf(dObj)
  override fun getEsWords(): List<String> = capitalizeAndAddPunctuation(
    if (agent == null) listOf<String>() else agent.getEsWords() +
    v.getEsWords()
  )
  override fun getGlossRows(): List<GlossRow> =
    if (agent == null) listOf<GlossRow>() else agent.getGlossRows() +
    v.getGlossRows() +
    if (dObj == null) listOf<GlossRow>() else dObj.getGlossRows()
  override fun getKey(): String =
    "agent=${agent?.getKey()} v=${v.getKey()} dObj=${dObj?.getKey()}"
  override fun getQuizQuestion(): String = capitalizeFirstLetter(
    if (agent == null) "" else (agent.getQuizQuestion() + " " ) +
    v.getEnVerb() +
    if (dObj == null) "" else (" " + dObj.getQuizQuestion())
  ) + "."
}
