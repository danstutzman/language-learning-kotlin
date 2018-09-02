package com.danstutzman.bank.fr

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation

class FrVCloud(
  val infList: FrInfList,
  val uniqVList: FrUniqVList,
  val regVPatternList: FrRegVPatternList
) {
  fun interpretFrLower(frLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()

    interpretations.addAll(uniqVList.interpretFrLower(frLower))

    interpretations.addAll(infList.interpretFrLower(frLower))

    val possibleInfs = infList.infs.filter { inf ->
      val base = inf.frMixed.substring(0, inf.frMixed.length - 2).toLowerCase()
      frLower.startsWith(base)
    }
    val possiblePatterns = regVPatternList.regVPatterns.filter { pattern ->
      val ending = pattern.frLower.substring(1)
      frLower.endsWith(ending)
    }
    for (inf in possibleInfs) {
      val infFrLower = inf.frMixed.toLowerCase()
      for (pattern in possiblePatterns) {
        if (FrInfCategory.isInfCategory(infFrLower, pattern.infCategory)) {
          val newV = FrRegV(inf, pattern)
          if (newV.getFrMixed().toLowerCase() == frLower) {
            if (uniqVList.byInfNumberPersonTense(inf, pattern.number,
              pattern.person, pattern.tense) == null) {
              interpretations.add(Interpretation("FrRegV", newV))
            }
          }
        }
      }
    }

    return interpretations
  }
}
