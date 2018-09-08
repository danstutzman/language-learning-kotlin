package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs

data class ArSuffixPronoun (
  val leafId: Int,
  val gender: ArGender?,
  val number: Int,
  val person: Int,
  val arBuckwalter: String
): CardCreator {
  override fun explainDerivation(): String =
    "gender=$gender number=$number person=$person"

  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()

  fun getEnPronoun(): String =
    when (number) {
      1 -> when (person) {
        1 -> "my"
        2 -> "your"
        3 -> "his/her"
        else -> throw RuntimeException("Unexpected person $person")
      }
      2 -> when (person) {
        1 -> "our"
        2 -> "your"
        3 -> "their"
        else -> throw RuntimeException("Unexpected person $person")
      }
      3 -> when (person) {
        1 -> "our"
        2 -> "your"
        3 -> "their"
        else -> throw RuntimeException("Unexpected person $person")
      }
      else -> throw RuntimeException("Unexpected number $number")
    }

  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, getEnPronoun(), arBuckwalter))

  override fun getPrompt(): String = "Suffix pronoun for ${getEnPronoun()}"

  override fun serializeLeafIds(): String = "leafId=${leafId}"
}