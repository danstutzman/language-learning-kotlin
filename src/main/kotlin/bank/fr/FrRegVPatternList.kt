package com.danstutzman.bank.fr

class FrRegVPatternList {
  val regVPatterns = listOf(
    FrRegVPattern( -101, FrInfCategory.ER,   1, 1, FrTense.PRES, "-e"),
    FrRegVPattern( -102, FrInfCategory.ER,   1, 2, FrTense.PRES, "-es"),
    FrRegVPattern( -103, FrInfCategory.ER,   1, 3, FrTense.PRES, "-e"),
    FrRegVPattern( -104, FrInfCategory.ER,   2, 1, FrTense.PRES, "-ons"),
    FrRegVPattern( -105, FrInfCategory.ER,   2, 2, FrTense.PRES, "-ez"),
    FrRegVPattern( -106, FrInfCategory.ER,   2, 3, FrTense.PRES, "-ent"),
    FrRegVPattern( -111, FrInfCategory.ENIR, 1, 1, FrTense.PRES, "-iens"),
    FrRegVPattern( -112, FrInfCategory.ENIR, 1, 2, FrTense.PRES, "-iens"),
    FrRegVPattern( -113, FrInfCategory.ENIR, 1, 3, FrTense.PRES, "-ient"),
    FrRegVPattern( -114, FrInfCategory.ENIR, 2, 1, FrTense.PRES, "-enons"),
    FrRegVPattern( -115, FrInfCategory.ENIR, 2, 2, FrTense.PRES, "-enez"),
    FrRegVPattern( -116, FrInfCategory.ENIR, 2, 3, FrTense.PRES, "-iennent")
  )
}
