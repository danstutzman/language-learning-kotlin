package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation

class ArVCloud(
  val vRootList: ArVRootList,
  val vPatternList: ArVPatternList,
  val stemChangeList: ArStemChangeList
) {
  fun interpretArBuckwalter(arBuckwalter: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()

    interpretations.addAll(vRootList.interpretArBuckwalter(arBuckwalter))

    // TODO narrow down search based on word's prefix!
    val possibleRoots = vRootList.vRoots
    val possiblePatterns = vPatternList.patterns
    for (root in possibleRoots) {
      for (pattern in possiblePatterns) {
        val newV = ArRegV(root, pattern)
        if (newV.getArBuckwalter() == arBuckwalter) {
          interpretations.add(Interpretation("ArRegV", newV))
        }
      }
    }

    // TODO narrow down search based on word's prefix!
    for (stemChange in stemChangeList.stemChanges) {
      for (pattern in possiblePatterns) {
        if (pattern.tense == stemChange.tense &&
          stemChange.persons.contains(pattern.person)) {
          val newV = ArStemChangeV(stemChange, pattern)
          if (newV.getArBuckwalter() == arBuckwalter) {
            interpretations.add(Interpretation("ArStemChangeV",
              ArStemChangeV(stemChange, pattern)))
          }
        }
      }
    }

    return interpretations
  }

}