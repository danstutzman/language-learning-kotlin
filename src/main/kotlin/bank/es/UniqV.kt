package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns

data class UniqV (
  override val cardId: Int,
  val es: String,
  val en: String,
  val inf: Inf,
  val number: Int,
  val person: Int,
  val tense: Tense,
  val enDisambiguation: String?
): Card, V {
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  override fun getEnVerb(): String = en
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, en, es))
  override fun getKey(): String =
    if (es.startsWith("fu")) "${es}-${inf.es}" else es
  override fun getQuizQuestion(): String =
    "(${EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]
      }) ${en}" +
      if (enDisambiguation != null) " (${enDisambiguation})" else ""
}