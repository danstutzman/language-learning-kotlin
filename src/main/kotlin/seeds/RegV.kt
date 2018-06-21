package seeds

val NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX = linkedMapOf(
  Pair(1, 1) to "",
  Pair(1, 2) to "",
  Pair(1, 3) to "s",
  Pair(2, 1) to "",
  Pair(2, 3) to ""
)

data class RegV (
  override val cardId: Int,
  val inf: Inf,
  val pattern: RegVPattern
): Card {
  fun getEnVerb(): String = when(pattern.tense) {
    Tense.PRES -> inf.enPresent + NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[
      Pair(pattern.number, pattern.person)]!!
    Tense.PRET -> inf.enPast
    else -> throw RuntimeException("Unexpected tense ${pattern.tense}")
  }
  fun getEsVerbPrefix(): String = inf.es.substring(0, inf.es.length - 2) + "-"
  override fun getChildrenCardIds(): List<Int> =
    listOf<Int>(inf.cardId, pattern.cardId)
  override fun getEsWords(): List<String> = listOf(
    inf.es.substring(0, inf.es.length - 2) + pattern.es.substring(1))
  override fun getGlossRows(): List<GlossRow> = listOf(
    GlossRow(inf.cardId, getEnVerb(), getEsVerbPrefix())) +
    pattern.getGlossRows()
  override fun getKey(): String = "${inf.getKey()}${pattern.getKey()}"
  override fun getQuizQuestion(): String =
    "(${pattern.getEnPronoun()}) ${getEnVerb()}"
}
