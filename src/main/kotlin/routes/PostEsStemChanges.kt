package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.EsStemChange

fun PostEsStemChanges(db: Db, leafIdsToDelete: List<Int>, newStemChange: Boolean,
  infinitiveEsMixed: String, esMixed: String, tense: String, en: String,
  enPast: String, enDisambiguation: String) {
  for (leafId in leafIdsToDelete) {
    db.esStemChangesTable.delete(leafId)
  }

  if (newStemChange) {
    var infinitive = db.esInfinitivesTable.findByEsMixed(infinitiveEsMixed)!!

    db.esStemChangesTable.insert(EsStemChange(
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