package com.danstutzman.routes

import com.danstutzman.db.EsInfinitive
import com.danstutzman.db.Db

fun PostEsInfinitives(
  db: Db,
  leafIdsToDelete: List<Int>,
  newInfinitive: Boolean,
  en: String,
  enDisambiguation: String,
  enPast: String,
  esMixed: String
) {
  for (leafId in leafIdsToDelete) {
    db.esInfinitivesTable.delete(leafId)
  }

  if (newInfinitive) {
    db.esInfinitivesTable.insert(
      EsInfinitive(
        leafId = 0,
        en = en,
        enDisambiguation = enDisambiguation,
        enPast = enPast,
        esMixed = esMixed))
  }
}