package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.IdSequence

val advsWithoutIds = listOf(
  Adv(0, "bien", "well"),
  Adv(0, "cómo", "how")
)

class AdvList {
  val advs: List<Adv>
  val advByEs: Map<String, Adv>

  constructor(cardIdSequence: IdSequence) {
    advs = advsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    advByEs = advs.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Adv? = advByEs[es]
}
