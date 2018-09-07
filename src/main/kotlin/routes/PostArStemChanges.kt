package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.ArStemChange

fun PostArStemChanges(db: Db, leafIdsToDelete: List<Int>, newStemChange: Boolean,
  rootArBuckwalter: String, arBuckwalter: String, tense: String,
  en: String, personsCsv: String) {
  for (leafId in leafIdsToDelete) {
    db.arStemChangesTable.delete(leafId)
  }

  if (newStemChange) {
    var root = db.arVRootsTable.findByArBuckwalter(rootArBuckwalter)!!

    db.arStemChangesTable.insert(ArStemChange(
      leafId = 0,
      rootLeafId = root.leafId,
      arBuckwalter = arBuckwalter,
      tense = tense,
      en = en,
      personsCsv = personsCsv))
  }
}