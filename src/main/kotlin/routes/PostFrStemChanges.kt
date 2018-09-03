package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.FrStemChange

fun PostFrStemChanges(db: Db, leafIdsToDelete: List<Int>, newStemChange: Boolean,
  infinitiveFrMixed: String, frMixed: String, tense: String, en: String,
  enPast: String) {
  for (leafId in leafIdsToDelete) {
    db.frStemChangesTable.delete(leafId)
  }

  if (newStemChange) {
    var infinitive = db.frInfinitivesTable.findByFrMixed(infinitiveFrMixed)!!

    db.frStemChangesTable.insert(FrStemChange(
      leafId = 0,
      infLeafId = infinitive.leafId,
      frMixed = frMixed,
      tense = tense,
      en = en,
      enPast = enPast))
  }
}