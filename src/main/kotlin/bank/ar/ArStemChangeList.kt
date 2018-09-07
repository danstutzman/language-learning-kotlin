package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class ArStemChangeList {
  val stemChanges: List<ArStemChange>

  constructor(rootList: ArVRootList, db: Db) {
    stemChanges = db.arStemChangesTable.selectAll().map {
      ArStemChange(
        leafId       = it.leafId,
        tense        = ArTense.valueOf(it.tense),
        root         = rootList.byLeafId(it.rootLeafId),
        arBuckwalter = it.arBuckwalter,
        en           = it.en,
        persons      = it.personsCsv.split(",").map { it.toInt() }
      )
    }
  }
}