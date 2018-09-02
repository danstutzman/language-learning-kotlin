package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.EsNonverb

fun PostEsNonverbs(db: Db, leafIdsToDelete: List<Int>, newNonverb: Boolean,
  en: String, enDisambiguation: String, enPlural: String, esMixed: String) {
  for (leafId in leafIdsToDelete) {
    db.esNonverbsTable.delete(leafId)
  }

  if (newNonverb) {
    db.esNonverbsTable.insert(EsNonverb(
      0, en, enDisambiguation, blankToNull(enPlural), esMixed))
  }
}