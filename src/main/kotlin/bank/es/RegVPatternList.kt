package com.danstutzman.bank.es

class RegVPatternList {
  val regVPatterns = listOf(
    RegVPattern( -1, InfCategory.AR,       1, 1, Tense.PRES, "-o"),
    RegVPattern( -2, InfCategory.AR,       1, 2, Tense.PRES, "-as"),
    RegVPattern( -3, InfCategory.AR,       1, 3, Tense.PRES, "-a"),
    RegVPattern( -4, InfCategory.AR,       2, 1, Tense.PRES, "-amos"),
    RegVPattern( -5, InfCategory.AR,       2, 3, Tense.PRES, "-an"),
    RegVPattern( -6, InfCategory.AR,       1, 1, Tense.PRET, "-é"),
    RegVPattern( -7, InfCategory.AR,       1, 2, Tense.PRET, "-aste"),
    RegVPattern( -8, InfCategory.AR,       1, 3, Tense.PRET, "-ó"),
    RegVPattern( -9, InfCategory.AR,       2, 1, Tense.PRET, "-amos"),
    RegVPattern(-10, InfCategory.AR,       2, 3, Tense.PRET, "-aron"),
    RegVPattern(-11, InfCategory.ERIR,     1, 1, Tense.PRES, "-o"),
    RegVPattern(-12, InfCategory.ERIR,     1, 2, Tense.PRES, "-es"),
    RegVPattern(-13, InfCategory.ERIR,     1, 3, Tense.PRES, "-e"),
    RegVPattern(-14, InfCategory.ERIR,     2, 3, Tense.PRES, "-en"),
    RegVPattern(-15, InfCategory.ERIR,     1, 1, Tense.PRET, "-í"),
    RegVPattern(-16, InfCategory.ERIR,     1, 2, Tense.PRET, "-iste"),
    RegVPattern(-17, InfCategory.ERIR,     1, 3, Tense.PRET, "-ió"),
    RegVPattern(-18, InfCategory.ERIR,     2, 1, Tense.PRET, "-imos"),
    RegVPattern(-19, InfCategory.ERIR,     2, 3, Tense.PRET, "-ieron"),
    RegVPattern(-20, InfCategory.ER,       2, 1, Tense.PRES, "-emos"),
    RegVPattern(-21, InfCategory.IR,       2, 1, Tense.PRES, "-imos"),
    RegVPattern(-22, InfCategory.STEMPRET, 1, 1, Tense.PRET, "-e"),
    RegVPattern(-23, InfCategory.STEMPRET, 1, 2, Tense.PRET, "-iste"),
    RegVPattern(-24, InfCategory.STEMPRET, 1, 3, Tense.PRET, "-o"),
    RegVPattern(-25, InfCategory.STEMPRET, 2, 1, Tense.PRET, "-imos"),
    RegVPattern(-26, InfCategory.STEMPRET, 2, 3, Tense.PRET, "-ieron")
  )
}
