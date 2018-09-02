package com.danstutzman.bank.es

class RegVPatternList {
  val regVPatterns = listOf(
    RegVPattern( -1, InfCategory.AR,       1, 1, EsTense.PRES, "-o"),
    RegVPattern( -2, InfCategory.AR,       1, 2, EsTense.PRES, "-as"),
    RegVPattern( -3, InfCategory.AR,       1, 3, EsTense.PRES, "-a"),
    RegVPattern( -4, InfCategory.AR,       2, 1, EsTense.PRES, "-amos"),
    RegVPattern( -5, InfCategory.AR,       2, 3, EsTense.PRES, "-an"),
    RegVPattern( -6, InfCategory.AR,       1, 1, EsTense.PRET, "-é"),
    RegVPattern( -7, InfCategory.AR,       1, 2, EsTense.PRET, "-aste"),
    RegVPattern( -8, InfCategory.AR,       1, 3, EsTense.PRET, "-ó"),
    RegVPattern( -9, InfCategory.AR,       2, 1, EsTense.PRET, "-amos"),
    RegVPattern(-10, InfCategory.AR,       2, 3, EsTense.PRET, "-aron"),
    RegVPattern(-11, InfCategory.ERIR,     1, 1, EsTense.PRES, "-o"),
    RegVPattern(-12, InfCategory.ERIR,     1, 2, EsTense.PRES, "-es"),
    RegVPattern(-13, InfCategory.ERIR,     1, 3, EsTense.PRES, "-e"),
    RegVPattern(-14, InfCategory.ERIR,     2, 3, EsTense.PRES, "-en"),
    RegVPattern(-15, InfCategory.ERIR,     1, 1, EsTense.PRET, "-í"),
    RegVPattern(-16, InfCategory.ERIR,     1, 2, EsTense.PRET, "-iste"),
    RegVPattern(-17, InfCategory.ERIR,     1, 3, EsTense.PRET, "-ió"),
    RegVPattern(-18, InfCategory.ERIR,     2, 1, EsTense.PRET, "-imos"),
    RegVPattern(-19, InfCategory.ERIR,     2, 3, EsTense.PRET, "-ieron"),
    RegVPattern(-20, InfCategory.ER,       2, 1, EsTense.PRES, "-emos"),
    RegVPattern(-21, InfCategory.IR,       2, 1, EsTense.PRES, "-imos"),
    RegVPattern(-22, InfCategory.STEMPRET, 1, 1, EsTense.PRET, "-e"),
    RegVPattern(-23, InfCategory.STEMPRET, 1, 2, EsTense.PRET, "-iste"),
    RegVPattern(-24, InfCategory.STEMPRET, 1, 3, EsTense.PRET, "-o"),
    RegVPattern(-25, InfCategory.STEMPRET, 2, 1, EsTense.PRET, "-imos"),
    RegVPattern(-26, InfCategory.STEMPRET, 2, 3, EsTense.PRET, "-ieron")
  )
}
