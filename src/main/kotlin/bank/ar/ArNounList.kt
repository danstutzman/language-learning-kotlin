package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class ArNounList {
  val nouns: List<ArNoun>
  val nounByArBuckwalter: Map<String, ArNoun>

  constructor(db: Db) {
    nouns = db.arNounsTable.selectAll().map {
      ArNoun(
        leafId = it.leafId,
        arBuckwalter = it.arBuckwalter,
        en = it.en,
        gender = ArGender.valueOf(it.gender)
      )
    }

    nounByArBuckwalter = nouns.map { Pair(it.arBuckwalter, it) }.toMap()
  }

  fun interpretArBuckwalter(arBuckwalter: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (nounByArBuckwalter[arBuckwalter] !== null) {
      interpretations.add(
        Interpretation("ArNoun", nounByArBuckwalter[arBuckwalter]))
    }
    interpretations.add(Interpretation("ArNoun", null))
    return interpretations
  }
}
