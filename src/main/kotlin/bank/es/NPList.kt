package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.IdSequence

val npsWithoutIds = listOf(
  NP(0, "yo", "I"),
  NP(0, "tú", "you"),
  NP(0, "él", "he"),
  NP(0, "qué", "what"),
  NP(0, "ingeniero de software", "software engineer"),
  NP(0, "hola", "hello"),
  NP(0, "buenas días", "good morning"),
  NP(0, "buenas tardes", "good afternoon"),
  NP(0, "español", "Spanish"),
  NP(0, "inglés", "English")
)

class NPList {
  val nps: List<NP>
  val npByEs: Map<String, NP>

  constructor(cardIdSequence: IdSequence) {
    nps = npsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    npByEs = nps.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): NP =
    npByEs[es] ?: throw CantMakeCard("Can't find NP for es=${es}")
}
