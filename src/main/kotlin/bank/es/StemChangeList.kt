package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.db.Db

class StemChangeList {
  val stemChanges: List<StemChange>
  val stemChangeByStem: Map<String, StemChange>

  constructor(infList: InfList, db: Db) {
    stemChanges = db.selectAllStemChangeRows().map {
      StemChange(
        it.leafId,
        Tense.valueOf(it.tense),
        infList.byEs(it.infinitiveEs) ?:
          throw CantMakeCard("No inf for ${it.infinitiveEs}"),
        it.stem
      )
    }
    stemChangeByStem = stemChanges.map { Pair(it.stem, it) }.toMap()
  }
  fun byStem(stem: String): StemChange = stemChangeByStem[stem]!!
}
