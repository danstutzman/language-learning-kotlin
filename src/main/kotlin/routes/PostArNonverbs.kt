package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.ArNonverb

fun PostArNonverbs(db: Db, leafIdsToDelete: List<Int>, newNonverb: Boolean,
  en: String, arBuckwalter: String) {
  for (leafId in leafIdsToDelete) {
    db.arNonverbsTable.delete(leafId)
  }

  if (newNonverb) {
    db.arNonverbsTable.insert(ArNonverb(0, en, arBuckwalter))
  }
}