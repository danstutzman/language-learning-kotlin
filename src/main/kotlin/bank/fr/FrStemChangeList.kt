package com.danstutzman.bank.fr

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class FrStemChangeList {
  val stemChanges: List<FrStemChange>
  val stemChangeByFrLower: Map<String, FrStemChange>

  constructor(infList: FrInfList, db: Db) {
    stemChanges = db.frStemChangesTable.selectAll().map {
      FrStemChange(
        it.leafId,
        FrTense.valueOf(it.tense),
        infList.byLeafId(it.infLeafId),
        it.frMixed,
        it.en,
        it.enPast
      )
    }
    stemChangeByFrLower =
      stemChanges.map { Pair(it.frMixed.toLowerCase(), it) }.toMap()
  }

  fun interpretFrLower(frLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (stemChangeByFrLower[frLower] != null) {
      interpretations.add(Interpretation("FrStemChange",
        stemChangeByFrLower[frLower]))
    }
    interpretations.add(Interpretation("FrStemChange", null))
    return interpretations
  }
}