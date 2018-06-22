package com.danstutzman.es

import com.danstutzman.seeds.Assertions
import com.danstutzman.seeds.IdSequence

val regVPatternsWithoutIds = listOf(
  RegVPattern(0, InfCategory.AR, 1, 1, Tense.PRES, "-o"),
  RegVPattern(0, InfCategory.AR, 1, 3, Tense.PRES, "-a"),
  RegVPattern(0, InfCategory.ER, 1, 1, Tense.PRES, "-o"),
  RegVPattern(0, InfCategory.ER, 1, 3, Tense.PRES, "-e"),
  RegVPattern(0, InfCategory.AR, 1, 1, Tense.PRET, "-é"),
  RegVPattern(0, InfCategory.AR, 1, 3, Tense.PRET, "-ó")
)
val regVPatternByQuestion =
  Assertions.assertUniqKeys(regVPatternsWithoutIds.map {
    Pair(it.getQuizQuestion(), it)
  })

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
