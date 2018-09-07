package com.danstutzman.bank.en

class EnPronouns {
  companion object {
    val NUMBER_AND_PERSON_TO_EN_PRONOUN = linkedMapOf(
      Pair(1, 1) to "I",
      Pair(1, 2) to "you",
      Pair(1, 3) to "he/she",
      Pair(2, 1) to "we",
      Pair(2, 2) to "you",
      Pair(2, 3) to "they",
      Pair(3, 1) to "we",
      Pair(3, 2) to "you",
      Pair(3, 3) to "they"
    )
  }
}
