package com.danstutzman.bank.en

import com.danstutzman.bank.es.Inf
import com.danstutzman.bank.es.Tense

class EnVerbs {
  companion object {
    val NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX = linkedMapOf(
      Pair(1, 1) to "",
      Pair(1, 2) to "",
      Pair(1, 3) to "s",
      Pair(2, 1) to "",
      Pair(2, 3) to ""
    )

    fun getEnVerbFor(inf: Inf, number: Int, person: Int, tense: Tense): String =
      when (tense) {
        Tense.PRES ->
          inf.enPresent +
          NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[Pair(number, person)]!!
        Tense.PRET -> inf.enPast
      } + if (inf.enDisambiguation != null) " (${inf.enDisambiguation})" else ""
  }
}
