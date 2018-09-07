package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation

class ArVCloud(
  val vRootList: ArVRootList,
  val vPatternList: ArVPatternList
) {

  fun interpretArBuckwalter(arBuckwalter: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()

    interpretations.addAll(vRootList.interpretArBuckwalter(arBuckwalter))

    // TODO narrow down search based on word's prefix!
    val possibleRoots = vRootList.vRoots
    val possiblePatterns = vPatternList.patterns
    for (root in possibleRoots) {
      for (pattern in possiblePatterns) {
        val newV = ArV(root, pattern)
        if (newV.getArBuckwalter() == arBuckwalter) {
          interpretations.add(Interpretation("ArV", newV))
        }
      }
    }

    return interpretations
  }

}