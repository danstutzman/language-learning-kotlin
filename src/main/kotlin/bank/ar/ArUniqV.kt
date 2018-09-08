package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V
import com.danstutzman.bank.en.EnPronouns

data class ArUniqV (
  val leafId: Int,
  val arBuckwalter: String,
  val en: String,
  val root: ArVRoot,
  val gender: ArGender?,
  val number: Int,
  val person: Int,
  val tense: ArTense
): CardCreator, V {
  override fun explainDerivation(): String {
    return "infinitive=${root.arBuckwalter} en=${root.enPresent} " +
      "gender=${gender} " +
      "number=${number} person=${person} tense=${tense}"
  }

  override fun getChildCardCreators(): List<CardCreator> =
    listOf(root) + root.getChildCardCreators()

  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, arBuckwalter))

  override fun getPrompt(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)] + " " +
      en

  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
