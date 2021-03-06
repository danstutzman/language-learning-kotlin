package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.V
import com.danstutzman.bank.en.EnPronouns

data class UniqV (
  val leafId: Int,
  val esMixed: String,
  val en: String,
  val inf: Inf,
  val number: Int,
  val person: Int,
  val tense: EsTense,
  val enDisambiguation: String?
): CardCreator, V {
  override fun explainDerivation(): String {
    val en = inf.enPresent + if (inf.enDisambiguation != null)
      " (${inf.enDisambiguation})" else ""
    return "infinitive=${inf.esMixed} en=${en} " +
      "number=${number} person=${person} tense=${tense}"
  }
  override fun getChildCardCreators(): List<CardCreator> =
    listOf(inf) + inf.getChildCardCreators()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, esMixed))
  override fun getPrompt(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)] + " " +
      en +
      (if (enDisambiguation != "") " (${enDisambiguation})" else "")
  override fun serializeLeafIds(): String = "leafId=${leafId}"
}
