package com.danstutzman.bank.fr

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class NonverbList {
  val nonverbs: List<Nonverb>
  val nonverbByFrLower: Map<String, Nonverb>

  constructor(db: Db) {
    nonverbs = db.frNonverbsTable.selectAll().map { row ->
      Nonverb(leafId = row.leafId, en = row.en, frMixed = row.frMixed)
    }
    nonverbByFrLower =
      nonverbs.map { Pair(it.frMixed.toLowerCase(), it) }.toMap()
  }

  fun interpretFrLower(frLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (nonverbByFrLower[frLower] != null) {
      interpretations.add(
        Interpretation("FrNonverb", nonverbByFrLower[frLower]))
    }
    interpretations.add(Interpretation("FrNonverb", null))
    return interpretations
  }
}