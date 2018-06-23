package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns

data class UniqV (
  override val cardId: Int,
  val es: String,
  val en: String,
  val inf: Inf,
  @get:JvmName("getNumber_") val number: Int,
  @get:JvmName("getPerson_") val person: Int,
  @get:JvmName("getTense_") val tense: Tense,
  val enDisambiguation: String?
): Card, V {
  override fun getChildrenCards(): List<Card> = listOf<Card>()
  override fun getEnVerbFor(number: Int, person: Int, tense: Tense): String =
    if (number == this.number && person == this.person && tense == this.tense)
      en
    else inf.getEnVerbFor(number, person, tense)
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, en, es))
  override fun getKey(): String =
    if (es.startsWith("fu")) "${es}-${inf.es}" else es
  override fun getNumber(): Int = number
  override fun getPerson(): Int = person
  override fun getQuizQuestion(): String =
    "(${EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]
      }) ${en}" +
      if (enDisambiguation != null) " (${enDisambiguation})" else ""
  override fun getTense(): Tense = tense
}
