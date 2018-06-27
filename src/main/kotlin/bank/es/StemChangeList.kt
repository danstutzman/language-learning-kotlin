package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.db.Db

class StemChangeList {
  val stemChanges: List<StemChange>
  val stemChangeByEsLower: Map<String, StemChange>

  constructor(infList: InfList, db: Db) {
    stemChanges = db.selectAllStemChangeRows().map {
      StemChange(
        it.leafId,
        Tense.valueOf(it.tense),
        infList.byEsLower(it.infinitiveEsMixed.toLowerCase()) ?:
          throw CantMakeCard("No inf for ${it.infinitiveEsMixed}"),
        it.esMixed,
        it.en,
        it.enPast,
        it.enDisambiguation
      )
    }
    stemChangeByEsLower =
      stemChanges.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
  }
  fun byEsLower(esLower: String): StemChange = stemChangeByEsLower[esLower]!!
}
