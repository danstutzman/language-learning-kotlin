package com.danstutzman.bank.es

enum class InfCategory {
  AR,
  ER,
  ERIR,
  IR,
  STEMPRET;

  companion object {
    fun isInfCategory(
      infEsLower: String,
      infCategory: InfCategory,
      isStemChangePret: Boolean
    ): Boolean =
      if (isStemChangePret)
        (infCategory == STEMPRET)
      else
        when (infCategory) {
          AR -> infEsLower.endsWith("ar")
          ER -> infEsLower.endsWith("er")
          IR -> infEsLower.endsWith("ir")
          ERIR -> infEsLower.endsWith("er") || infEsLower.endsWith("ir")
          STEMPRET -> false
        }
  }
}
