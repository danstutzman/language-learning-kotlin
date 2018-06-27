package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.db.Db

class StemChangeList {
  val stemChanges: List<StemChange>
  val stemChangeByStemLower: Map<String, StemChange>

  constructor(infList: InfList, db: Db) {
    stemChanges = db.selectAllStemChangeRows().map {
      StemChange(
        it.leafId,
        Tense.valueOf(it.tense),
        infList.byEsLower(it.infinitiveEsMixed.toLowerCase()) ?:
          throw CantMakeCard("No inf for ${it.infinitiveEsMixed}"),
        it.stemMixed
      )
    }
    stemChangeByStemLower =
      stemChanges.map { Pair(it.stemMixed.toLowerCase(), it) }.toMap()
  }
  fun byStemLower(stemLower: String): StemChange =
    stemChangeByStemLower[stemLower]!!
}
