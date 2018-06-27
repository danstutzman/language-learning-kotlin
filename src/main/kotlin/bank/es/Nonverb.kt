package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow

data class Nonverb (
  val leafId: Int,
  val esMixed: String,
  val en: String,
  val enDisambiguation: String?
): CardCreator {
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, en, esMixed))
  override fun getPrompt(): String =
    if (enDisambiguation != null) "${en} (${enDisambiguation})" else en
}
