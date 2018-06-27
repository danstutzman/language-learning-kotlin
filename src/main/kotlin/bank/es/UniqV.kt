package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns

data class UniqV (
  val leafId: Int,
  val esMixed: String,
  val en: String,
  val inf: Inf,
  val number: Int,
  val person: Int,
  val tense: Tense
): CardCreator, V {
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(inf) + inf.getChildCardCreators()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, esMixed))
  override fun getPrompt(): String = "(" +
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)] +
    ") " +
    inf.getPrompt()
}
