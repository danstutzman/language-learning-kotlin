package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetUniqueConjugations(db: Db): String {
  val uniqueConjugations = db.leafsTable.selectAllUniqueConjugations()
  val infEsByLeafId = db.leafsTable.selectInfinitivesWithLeafIdIn(
    uniqueConjugations.map { it.infLeafId }.distinct()
  ).map { it.leafId to it.esMixed }.toMap()

  return com.danstutzman.templates.GetUniqueConjugations(
    uniqueConjugations, infEsByLeafId)
}