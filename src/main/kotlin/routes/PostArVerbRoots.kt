package com.danstutzman.routes

import com.danstutzman.db.ArVerbRoot
import com.danstutzman.db.Db

fun PostArVerbRoots(db: Db, leafIdsToDelete: List<Int>, newVerbRoot: Boolean,
    en: String, enPast: String, arBuckwalter: String,
    arPresMiddleVowelBuckwalter: String) {
  for (leafId in leafIdsToDelete) {
    db.arVRootsTable.delete(leafId)
  }

  if (newVerbRoot) {
    db.arVRootsTable.insert(ArVerbRoot(0, en, enPast, arBuckwalter,
      arPresMiddleVowelBuckwalter))
  }
}