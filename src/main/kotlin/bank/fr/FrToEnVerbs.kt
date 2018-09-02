package com.danstutzman.bank.fr

import com.danstutzman.bank.fr.FrInf
import com.danstutzman.bank.fr.FrTense

class FrToEnVerbs {
  companion object {
    val NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX = linkedMapOf(
      Pair(1, 1) to "",
      Pair(1, 2) to "",
      Pair(1, 3) to "s",
      Pair(2, 1) to "",
      Pair(2, 3) to ""
    )

    fun getEnVerbFor(inf: FrInf, number: Int, person: Int, tense: FrTense):
      String =
      when (tense) {
        FrTense.PRES ->
          inf.enPresent +
          NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
      }
  }
}
