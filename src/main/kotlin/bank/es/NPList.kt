package com.danstutzman.bank.es

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.IdSequence

val npsWithoutIds = listOf(
  NP(0, "yo", "I")
)
val npByQuestion = Assertions.assertUniqKeys(
	npsWithoutIds.map { Pair(it.getQuizQuestion(), it) })

class NPList {
  val nps: List<NP>
  val npByEs: Map<String, NP>

  constructor(cardIdSequence: IdSequence) {
    nps = npsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    npByEs = nps.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): NP = npByEs[es]!!
}
