package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation

class VCloud(
  val infList: InfList,
  val uniqVList: UniqVList,
  val regVPatternList: RegVPatternList,
  val stemChangeList: StemChangeList
) {
  fun interpretEsLower(esLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()

    interpretations.addAll(uniqVList.interpretEsLower(esLower))

    interpretations.addAll(infList.interpretEsLower(esLower))

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
              interpretations.add(Interpretation("EsRegV", newV))
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
            interpretations.add(Interpretation("EsStemChangeV",
              StemChangeV(stemChange, pattern)))
          }
        }
      }
    }

    return interpretations
  }
}
