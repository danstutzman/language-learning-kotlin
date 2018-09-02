package com.danstutzman.routes

import com.danstutzman.db.Infinitive
import com.danstutzman.db.Db

fun PostInfinitives(
  db: Db,
  leafIdsToDelete: List<Int>,
  newInfinitive: Boolean,
  en: String,
  enDisambiguation: String,
  enPast: String,
  enMixed: String
) {
  for (leafId in leafIdsToDelete) {
    db.leafsTable.deleteLeaf(leafId)
  }

  if (newInfinitive) {
    db.leafsTable.insertInfinitive(
      Infinitive(0, en, enDisambiguation, enPast, enMixed))
  }
}