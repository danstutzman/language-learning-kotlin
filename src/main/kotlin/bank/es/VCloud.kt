package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard

class VCloud(
  val infList: InfList,
  val uniqVList: UniqVList,
  val regVPatternList: RegVPatternList,
  val stemChangeList: StemChangeList
) {
  val createdCardsByEsLower = linkedMapOf<String, V>()

  fun byEsLower(esLower: String): V? {
    val maybeExistingCard = createdCardsByEsLower[esLower]
    if (maybeExistingCard != null) {
      return maybeExistingCard
    }

    val maybeUniqV = uniqVList.byEsLower(esLower)
    if (maybeUniqV != null) {
      return maybeUniqV
    }

    val maybeInf = infList.byEsLower(esLower)
    if (maybeInf != null) {
      return maybeInf
    }

    val possibleInfs = infList.infs.filter { inf ->
      val base = inf.esMixed.substring(0, inf.esMixed.length - 2).toLowerCase()
      esLower.startsWith(base)
    }
    val possiblePatterns = regVPatternList.regVPatterns.filter { pattern ->
      val ending = pattern.esLower.substring(1)
      esLower.endsWith(ending)
    }
    for (inf in possibleInfs) {
      val infEsLower = inf.esMixed.toLowerCase()
      for (pattern in possiblePatterns) {
        if (InfCategory.isInfCategory(infEsLower, pattern.infCategory, false)) {
          val newV = RegV(inf, pattern)
          if (newV.getEsMixed().toLowerCase() == esLower) {
            if (uniqVList.byInfNumberPersonTense(inf, pattern.number,
              pattern.person, pattern.tense) == null) {
              createdCardsByEsLower[esLower] = newV
              return newV
            }
          }
        }
      }
    }

    for (stemChange in stemChangeList.stemChanges) {
      val base = stemChange.esMixed.substring(0,
        stemChange.esMixed.length - 1).toLowerCase()
      if (esLower.startsWith(base)) {
        for (pattern in possiblePatterns) {
          if (pattern.tense == stemChange.tense && InfCategory.isInfCategory(
            stemChange.inf.esMixed.toLowerCase(),
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
