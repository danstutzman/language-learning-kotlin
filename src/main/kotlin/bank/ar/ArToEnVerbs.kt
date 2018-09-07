package com.danstutzman.bank.ar

import com.danstutzman.bank.ar.ArTense
import com.danstutzman.bank.ar.ArVRoot

class ArToEnVerbs {
  companion object {
    val NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX = linkedMapOf(
      Pair(1, 1) to "",
      Pair(1, 2) to "",
      Pair(1, 3) to "s",
      Pair(2, 1) to "",
      Pair(2, 2) to "",
      Pair(2, 3) to "",
      Pair(3, 1) to "",
      Pair(3, 2) to "",
      Pair(3, 3) to ""
    )

    fun getEnVerbFor(root: ArVRoot, number: Int, person: Int, tense: ArTense):
      String =
      when (tense) {
        ArTense.PAST -> root.enPast
        ArTense.PRES ->
          root.enPresent +
          NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
      }
  }
}
