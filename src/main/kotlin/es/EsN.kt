package es

data class EsN(
    val en: String?
) {
  fun isComplete() = (en != null)
}