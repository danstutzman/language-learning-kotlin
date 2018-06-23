package com.danstutzman.bank.es

import com.danstutzman.bank.Card
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.es.Tense

interface V : Card {
  fun getEnVerbFor(number: Int, person: Int, tense: Tense): String
  fun getNumber(): Int
  fun getPerson(): Int
  fun getTense(): Tense
}
