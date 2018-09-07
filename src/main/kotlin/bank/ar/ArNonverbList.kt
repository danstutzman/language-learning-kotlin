package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class ArNonverbList {
  val nonverbs: List<ArNonverb>
  val nonverbByArBuckwalter: Map<String, ArNonverb>

  constructor(db: Db) {
    nonverbs = db.arNonverbsTable.selectAll().map { row ->
      ArNonverb(
        leafId = row.leafId,
        en = row.en,
        arBuckwalter = row.arBuckwalter)
    }
    nonverbByArBuckwalter =
      nonverbs.map { Pair(it.arBuckwalter, it) }.toMap()
  }

  fun interpretArBuckwalter(arBuckwalter: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (nonverbByArBuckwalter[arBuckwalter] != null) {
      interpretations.add(
        Interpretation("ArNonverb", nonverbByArBuckwalter[arBuckwalter]))
    }
    interpretations.add(Interpretation("ArNonverb", null))
    return interpretations
  }
}