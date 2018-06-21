package seeds

val NUMBER_AND_PERSON_TO_EN_PRONOUN = linkedMapOf(
  Pair(1, 1) to "I",
  Pair(1, 2) to "you",
  Pair(1, 3) to "he/she",
  Pair(2, 1) to "we",
  Pair(2, 3) to "they"
)

val PERSON_TO_DESCRIPTION = linkedMapOf(
  1 to "1st person",
  2 to "2nd person",
  3 to "3rd person"
)

data class RegVPattern (
  override val cardId: Int,
  val infCategory: InfCategory,
  val number: Int,
  val person: Int,
  val tense: Tense,
  val es: String
): Card {
  fun getEnPronoun(): String =
    NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
  override fun getKey(): String = "${infCategory}${number}${person}${tense}"
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, "(${getEnPronoun()})", es))
  override fun getQuizQuestion(): String =
    "Conjugation for ${infCategory} verbs for ${PERSON_TO_DESCRIPTION[person]
      } ${tense}"
}
