package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.StemChangeRow

fun PostStemChanges(db: Db, leafIdsToDelete: List<Int>, newStemChange: Boolean,
  infinitiveEsMixed: String, esMixed: String, tense: String, en: String,
  enPast: String, enDisambiguation: String) {
  for (leafId in leafIdsToDelete) {
    db.leafsTable.deleteLeaf(leafId)
  }

  if (newStemChange) {
    var infinitive = db.leafsTable.findInfinitiveByEsMixed(infinitiveEsMixed)!!
    db.leafsTable.insertStemChangeRow(StemChangeRow(
      leafId = 0,
      infLeafId = infinitive.leafId,
      esMixed = esMixed,
      tense = tense,
      en = en,
      enPast = enPast,
      enDisambiguation = enDisambiguation
    ))
  }
}