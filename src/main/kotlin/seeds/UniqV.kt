package seeds

data class UniqV (
  override val cardId: Int,
  val es: String,
  val en: String,
  val inf: Inf,
  val number: Int,
  val person: Int,
  val tense: Tense
): Card {
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  fun getEnVerb(): String = en
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, getEnVerb(), es))
  override fun getKey(): String =
    if (es.startsWith("fu")) "${es}-${inf.es}" else es
  override fun getQuizQuestion(): String =
    "(${EnPronouns.NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]
      }) ${en}"
}
