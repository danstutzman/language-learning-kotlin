package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V

data class ArVRoot (
  val leafId: Int,
  val enPresent: String,
  val enPast: String,
  val arBuckwalter: String,
  val arPresMiddleVowelBuckwalter: String
): CardCreator, V {
  private val ROOT_REGEX = "^([^aeiou])([^aeiou])([iA])?([^aeiou])$".toRegex()

  val c1: String
  val c2: String
  val v2: String
  val c3: String

  init {
    val match = ROOT_REGEX.find(arBuckwalter) ?: throw RuntimeException(
      "Expected root ${arBuckwalter} to match ${ROOT_REGEX}")
    c1 = match.groupValues[1]
    c2 = match.groupValues[2]
    v2 = if (match.groupValues[3] != "") match.groupValues[3] else "a"
    c3 = match.groupValues[4]
  }

  override fun explainDerivation(): String =
    "root=${arBuckwalter} enPresent=${enPresent} enPast=${enPast}"
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, enPresent, arBuckwalter))
  override fun getPrompt(): String = "to ${enPresent}"
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
