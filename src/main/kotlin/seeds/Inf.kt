package seeds

data class Inf (
  override val cardId: Int,
  val es: String,
  val enPresent: String,
  val enPast: String
): Card {
  override fun getChildrenCardIds(): List<Int> = listOf()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getKey(): String = es
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, enPresent, es))
  override fun getQuizQuestion(): String = "to ${enPresent}"
}
