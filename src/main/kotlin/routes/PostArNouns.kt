package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.ArNounRow

fun PostArNouns(db: Db, leafIdsToDelete: List<Int>, newNoun: Boolean,
  en: String, arBuckwalter: String, gender: String) {
  for (leafId in leafIdsToDelete) {
    db.arNounsTable.delete(leafId)
  }

  if (newNoun) {
    db.arNounsTable.insert(ArNounRow(0, en, arBuckwalter, gender))
  }
}