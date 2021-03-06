package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class StemChangeList {
  val stemChanges: List<StemChange>
  val stemChangeByEsLower: Map<String, StemChange>

  constructor(infList: InfList, db: Db) {
    stemChanges = db.esStemChangesTable.selectAll().map {
      StemChange(
        it.leafId,
        EsTense.valueOf(it.tense),
        infList.byLeafId(it.infLeafId),
        it.esMixed,
        it.en,
        it.enPast,
        it.enDisambiguation
      )
    }
    stemChangeByEsLower =
      stemChanges.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
  }

  fun interpretEsLower(esLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (stemChangeByEsLower[esLower] != null) {
      interpretations.add(Interpretation("EsStemChange",
        stemChangeByEsLower[esLower]))
    }
    interpretations.add(Interpretation("EsStemChange", null))
    return interpretations
  }
}