package com.danstutzman.bank.fr

enum class FrInfCategory(val length: Int) {
  ER(2),
  ENIR(4);

  companion object {
    fun isInfCategory(
      infFrLower: String,
      infCategory: FrInfCategory
    ): Boolean =
      when (infCategory) {
        ER -> infFrLower.endsWith("er")
        ENIR -> infFrLower.endsWith("enir")
      }
  }
}
