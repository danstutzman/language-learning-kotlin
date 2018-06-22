package seeds

data class RegV (
  override val cardId: Int,
  val inf: Inf,
  val pattern: RegVPattern
): Card {
  fun getEsVerbPrefix(): String = inf.es.substring(0, inf.es.length - 2) + "-"
  override fun getChildrenCardIds(): List<Int> =
    listOf<Int>(inf.cardId, pattern.cardId)
  fun getEnVerb() =
    inf.getEnVerb(pattern.number, pattern.person, pattern.tense)
  override fun getEsWords(): List<String> = listOf(
    inf.es.substring(0, inf.es.length - 2) + pattern.es.substring(1))
  override fun getGlossRows(): List<GlossRow> = listOf(
    GlossRow(inf.cardId, getEnVerb(), getEsVerbPrefix())) +
    pattern.getGlossRows()
  override fun getKey(): String = "${inf.getKey()}${pattern.getKey()}"
  override fun getQuizQuestion(): String =
    "(${pattern.getEnPronoun()}) ${getEnVerb()}"
}
