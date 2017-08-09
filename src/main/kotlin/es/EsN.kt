package es

data class EsN(
    val id: Int?,
    val es: String?,
    val en: String?,
    val gender: EsGender?,
    val numRepeatedSuccesses: Int
) {
  fun isComplete() = es != null &&
      en != null &&
      gender != null

  fun isSavable() = (es != null) || (en != null)
}