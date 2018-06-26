package com.danstutzman.bank.es

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow

data class Nonverb (
  val leafId: Int,
  val es: String,
  val en: String,
  val enDisambiguation: String?
): CardCreator {
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(leafId, en, es))
  override fun getPrompt(): String =
    if (enDisambiguation != null) "${en} (${enDisambiguation})" else en
}
