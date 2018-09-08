package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation

class ArCompoundNounCloud(
  val nounList: ArNounList,
  val caseList: ArNounCaseList,
  val suffixPronounList: ArSuffixPronounList
) {
  fun interpretArBuckwalter(word: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()

    interpretations.addAll(nounList.interpretArBuckwalter(word))

    for (noun in nounList.nouns) {
      if (word.startsWith(noun.arBuckwalter)) {
        for (case in caseList.cases) {
          // With a case, without a pronoun
          val newCompoundNoun = ArCompoundNoun(noun, case, null)
          if (newCompoundNoun.getArBuckwalter() == word) {
            interpretations.add(
              Interpretation("ArCompoundNoun", newCompoundNoun))
          }

          // With both case and pronoun
          for (pronoun in suffixPronounList.pronouns) {
            val newCompoundNoun = ArCompoundNoun(noun, case, pronoun)
            if (newCompoundNoun.getArBuckwalter() == word) {
              interpretations.add(
                Interpretation("ArCompoundNoun", newCompoundNoun))
            }
          }
        }

        // With pronoun but not case
        for (pronoun in suffixPronounList.pronouns) {
          val newCompoundNoun = ArCompoundNoun(noun, null, pronoun)
          if (newCompoundNoun.getArBuckwalter() == word) {
            interpretations.add(
              Interpretation("ArCompoundNoun", newCompoundNoun))
          }
        }
      }
    }

    return interpretations
  }
}