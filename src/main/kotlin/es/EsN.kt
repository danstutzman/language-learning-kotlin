package es

data class EsN(
    val es: String?,
    val en: String?
) {
  fun isComplete() = (es != null) && (en != null)
  fun isSavable() = (es != null) || (en != null)
}