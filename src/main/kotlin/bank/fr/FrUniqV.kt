package com.danstutzman.bank.fr

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V
import com.danstutzman.bank.en.EnPronouns

data class FrUniqV (
  val leafId: Int,
  val frMixed: String,
  val en: String,
  val inf: FrInf,
  val number: Int,
  val person: Int,
  val tense: FrTense
): CardCreator, V {
  override fun explainDerivation(): String {
    return "infinitive=${inf.frMixed} en=${inf.enPresent} " +
      "number=${number} person=${person} tense=${tense}"
  }
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(inf) + inf.getChildCardCreators()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, frMixed))
  override fun getPrompt(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)] + " " +
      en
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
