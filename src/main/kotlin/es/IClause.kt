package es

import seeds.Card
import seeds.GlossRow

fun capitalizeFirstLetter(s: String) =
  s.substring(0, 1).toUpperCase() + s.substring(1)

data class IClause(
  override val cardId: Int,
  val agent: NP,
  val v: RegV
): Card {
  override fun getChildrenCardIds(): List<Int> =
    listOf<Int>(agent.cardId, v.cardId)
  override fun getEsWords(): List<String> =
    listOf(capitalizeFirstLetter(agent.getEsWords()[0])) +
    listOf(v.getEsWords()[0] + ".")
  override fun getGlossRows(): List<GlossRow> =
    agent.getGlossRows() + v.getGlossRows()
  override fun getKey(): String = "agent=${agent.getKey()} v=${v.getKey()}"
  override fun getQuizQuestion(): String =
    capitalizeFirstLetter(agent.getQuizQuestion()) + " " + v.getEnVerb() + "."
}
