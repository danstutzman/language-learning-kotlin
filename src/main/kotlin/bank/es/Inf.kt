package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnVerbs

data class Inf (
  val leafId: Int,
  val es: String,
  val enPresent: String,
  val enPast: String,
  val enDisambiguation: String?
): CardCreator, V {
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, enPresent, es))
  override fun getPrompt(): String =
    if (enDisambiguation != null) "to ${enPresent} (${enDisambiguation})"
      else "to ${enPresent}"
}
