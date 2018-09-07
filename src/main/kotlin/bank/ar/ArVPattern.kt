package com.danstutzman.bank.ar

import com.danstutzman.bank.CardCreator
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.en.EnPronouns
import com.danstutzman.bank.en.EnVerbs

data class ArVPattern (
  val leafId: Int,
  val gender: ArGender?,
  val number: Int,
  val person: Int,
  val tense: ArTense,
  val prefixBuckwalter: String?,
  val suffixBuckwalter: String
): CardCreator {
  override fun explainDerivation(): String =
    "tense=${tense} number=${number} gender=${gender} person=${person}"

  override fun getChildCardCreators(): List<CardCreator> = listOf<CardCreator>()

  fun getEnPronoun(): String =
    EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!

  fun getEnVerb(): String = 
    when (tense) {
      ArTense.PAST -> "wrote"
      ArTense.PRES -> "write" +
        EnVerbs.NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
    }

  fun getPrefixGlossRows(): List<GlossRow> =
    if (prefixBuckwalter != null)
      listOf(GlossRow(leafId, "(${getEnPronoun()})", prefixBuckwalter))
    else listOf<GlossRow>()

  fun getSuffixGlossRows(): List<GlossRow> =
    listOf(GlossRow(leafId, "(${getEnPronoun()})", suffixBuckwalter))

  override fun getGlossRows(): List<GlossRow> {
    val arVerb = when (tense) {
      ArTense.PAST -> "katab-"
      ArTense.PRES -> "ktub-"
    }
    return getPrefixGlossRows() +
      listOf(GlossRow(leafId, getEnVerb(), arVerb)) +
      getSuffixGlossRows()
  }

  override fun getPrompt(): String = "(${getEnPronoun()} ${getEnVerb()})"

  override fun serializeLeafIds(): String = "leafId=${leafId}"
}