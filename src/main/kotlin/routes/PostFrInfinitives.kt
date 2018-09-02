package com.danstutzman.routes

import com.danstutzman.db.FrInfinitive
import com.danstutzman.db.Db

fun PostFrInfinitives(
  db: Db,
  leafIdsToDelete: List<Int>,
  newInfinitive: Boolean,
  en: String,
  enPast: String,
  frMixed: String
) {
  for (leafId in leafIdsToDelete) {
    db.frInfinitivesTable.delete(leafId)
  }

  if (newInfinitive) {
    db.frInfinitivesTable.insert(FrInfinitive(
      leafId = 0,
      en = en,
      enPast = enPast,
      frMixed = frMixed))
  }
}