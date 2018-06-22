package com.danstutzman.es

import com.danstutzman.seeds.Card
import com.danstutzman.seeds.GlossRow

data class Det (
  override val cardId: Int,
  val es: String,
  val en: String,
  val gender: Gender?
): Card {
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(cardId, en, es))
  override fun getKey(): String = es
  override fun getQuizQuestion(): String =
    if (gender == null) en else "${en} (${GENDER_TO_DESCRIPTION[gender]})"
}
