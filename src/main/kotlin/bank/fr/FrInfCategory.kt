package com.danstutzman.bank.fr

enum class FrInfCategory {
  ER;

  companion object {
    fun isInfCategory(
      infFrLower: String,
      infCategory: FrInfCategory
    ): Boolean =
      when (infCategory) {
        ER -> infFrLower.endsWith("er")
      }
  }
}
