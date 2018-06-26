package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard

class VCloud(
  val infList: InfList,
  val uniqVList: UniqVList,
  val regVPatternList: RegVPatternList,
  val stemChangeList: StemChangeList
) {
  val createdCardsByConjugation = linkedMapOf<String, V>()

  fun byEs(conjugation: String): V? {
    val maybeExistingCard = createdCardsByConjugation[conjugation]
    if (maybeExistingCard != null) {
      return maybeExistingCard
    }

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
          val newV = RegV(inf, pattern)
          if (newV.getEs() == conjugation) {
            createdCardsByConjugation[conjugation] = newV
            return newV
          }
        }
      }
    }

    for (stemChange in stemChangeList.stemChanges) {
      val base = stemChange.stem.substring(0, stemChange.stem.length - 1)
      if (conjugation.startsWith(base)) {
        for (pattern in possiblePatterns) {
          if (pattern.tense == stemChange.tense && InfCategory.isInfCategory(
            stemChange.inf.es,
            pattern.infCategory,
            pattern.tense == Tense.PRET)) {
            return StemChangeV(stemChange, pattern)
          }
        }
      }
    }

    return null
  }
}
