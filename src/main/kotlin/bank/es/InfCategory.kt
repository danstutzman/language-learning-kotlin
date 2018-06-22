package com.danstutzman.bank.es

enum class InfCategory {
  AR,
  ER,
  ERIR,
  IR,
  STEMPRET;

  companion object {
    fun isInfCategory(
      infEs: String,
      infCategory: InfCategory,
      isStemChangePret: Boolean
    ): Boolean =
      if (isStemChangePret)
        (infCategory == STEMPRET)
      else
        when (infCategory) {
          AR -> infEs.endsWith("ar")
          ER -> infEs.endsWith("er")
          IR -> infEs.endsWith("ir")
          ERIR -> infEs.endsWith("er") || infEs.endsWith("ir")
          STEMPRET -> false
        }
  }
}
