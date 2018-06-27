package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow

data class Inf (
  val leafId: Int,
  val esMixed: String,
  val enPresent: String,
  val enPast: String,
  val enDisambiguation: String?
): CardCreator, V {
  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, enPresent, esMixed))
  override fun getPrompt(): String =
    if (enDisambiguation != null) "to ${enPresent} (${enDisambiguation})"
      else "to ${enPresent}"
}
