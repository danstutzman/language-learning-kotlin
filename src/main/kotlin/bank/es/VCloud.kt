package com.danstutzman.bank.es

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.IdSequence

class VCloud(
  val cardIdSequence: IdSequence,
  val infList: InfList,
  val uniqVList: UniqVList,
  val regVPatternList: RegVPatternList
) {
  fun byEs(conjugation: String): V {
    val maybeUniqV = uniqVList.byEs(conjugation)
    if (maybeUniqV != null) {
      return maybeUniqV
    }

    val maybeInf = infList.byEs(conjugation)
    if (maybeInf != null) {
      return maybeInf
    }

    val possibleInfs = infList.infs.filter { inf ->
      val base = inf.es.substring(0, inf.es.length - 2)
      conjugation.startsWith(base)
    }
    val possiblePatterns = regVPatternList.regVPatterns.filter { pattern ->
      val ending = pattern.es.substring(1)
      conjugation.endsWith(ending)
    }
    for (inf in possibleInfs) {
      for (pattern in possiblePatterns) {
        if (InfCategory.isInfCategory(inf.es, pattern.infCategory, false)) {
          val newV = RegV(0, inf, pattern)
          if (newV.getEs() == conjugation) {
            return newV.copy(cardId = cardIdSequence.nextId())
          }
        }
      }
    }

    throw RuntimeException("Couldn't find V for es=${conjugation}")
  }
}
