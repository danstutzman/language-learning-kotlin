package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.NonverbRow

fun PostNonverbs(db: Db, leafIdsToDelete: List<Int>, newNonverb: Boolean,
  en: String, enDisambiguation: String, enPlural: String, esMixed: String) {
  for (leafId in leafIdsToDelete) {
    db.leafsTable.deleteLeaf(leafId)
  }

  if (newNonverb) {
    db.leafsTable.insertNonverbRow(NonverbRow(
      0, en, enDisambiguation, blankToNull(enPlural), esMixed))
  }
}