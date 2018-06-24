package com.danstutzman.bank.es

import com.danstutzman.bank.IdSequence

val regVPatternsWithoutIds = listOf(
  RegVPattern(0, InfCategory.AR,       1, 1, Tense.PRES, "-o"),
  RegVPattern(0, InfCategory.AR,       1, 2, Tense.PRES, "-as"),
  RegVPattern(0, InfCategory.AR,       1, 3, Tense.PRES, "-a"),
  RegVPattern(0, InfCategory.AR,       2, 1, Tense.PRES, "-amos"),
  RegVPattern(0, InfCategory.AR,       2, 3, Tense.PRES, "-an"),
  RegVPattern(0, InfCategory.AR,       1, 1, Tense.PRET, "-é"),
  RegVPattern(0, InfCategory.AR,       1, 2, Tense.PRET, "-aste"),
  RegVPattern(0, InfCategory.AR,       1, 3, Tense.PRET, "-ó"),
  RegVPattern(0, InfCategory.AR,       2, 1, Tense.PRET, "-amos"),
  RegVPattern(0, InfCategory.AR,       2, 3, Tense.PRET, "-aron"),
  RegVPattern(0, InfCategory.ERIR,     1, 1, Tense.PRES, "-o"),
  RegVPattern(0, InfCategory.ERIR,     1, 2, Tense.PRES, "-es"),
  RegVPattern(0, InfCategory.ERIR,     1, 3, Tense.PRES, "-e"),
  RegVPattern(0, InfCategory.ERIR,     2, 3, Tense.PRES, "-en"),
  RegVPattern(0, InfCategory.ERIR,     1, 1, Tense.PRET, "-í"),
  RegVPattern(0, InfCategory.ERIR,     1, 2, Tense.PRET, "-iste"),
  RegVPattern(0, InfCategory.ERIR,     1, 3, Tense.PRET, "-ió"),
  RegVPattern(0, InfCategory.ERIR,     2, 1, Tense.PRET, "-imos"),
  RegVPattern(0, InfCategory.ERIR,     2, 3, Tense.PRET, "-ieron"),
  RegVPattern(0, InfCategory.ER,       2, 1, Tense.PRES, "-emos"),
  RegVPattern(0, InfCategory.IR,       2, 1, Tense.PRES, "-imos"),
  RegVPattern(0, InfCategory.STEMPRET, 1, 1, Tense.PRET, "-e"),
  RegVPattern(0, InfCategory.STEMPRET, 1, 2, Tense.PRET, "-iste"),
  RegVPattern(0, InfCategory.STEMPRET, 1, 3, Tense.PRET, "-o"),
  RegVPattern(0, InfCategory.STEMPRET, 2, 1, Tense.PRET, "-imos"),
  RegVPattern(0, InfCategory.STEMPRET, 2, 3, Tense.PRET, "-ieron")
)

class RegVPatternList {
  val regVPatterns: List<RegVPattern>
  val regVPatternByKey: Map<String, RegVPattern>

  constructor(cardIdSequence: IdSequence) {
    regVPatterns = regVPatternsWithoutIds.map {
      it.copy(cardId = cardIdSequence.nextId())
    }
    regVPatternByKey = regVPatterns.map { Pair(it.getKey(), it) }.toMap()
  }
  fun byKey(key: String): RegVPattern = regVPatternByKey[key]!!
}
