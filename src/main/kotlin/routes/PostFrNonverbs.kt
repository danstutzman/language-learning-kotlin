package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.FrNonverb

fun PostFrNonverbs(db: Db, leafIdsToDelete: List<Int>, newNonverb: Boolean,
  en: String, frMixed: String) {
  for (leafId in leafIdsToDelete) {
    db.frNonverbsTable.delete(leafId)
  }

  if (newNonverb) {
    db.frNonverbsTable.insert(FrNonverb(0, en, frMixed))
  }
}