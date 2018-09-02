package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetEsUniqueConjugations(db: Db): String {
  val uniqueConjugations = db.esUniqueConjugationsTable.selectAll()

  val infEsByLeafId = db.esInfinitivesTable.selectWithLeafIdIn(
    uniqueConjugations.map { it.infLeafId }.distinct()
  ).map { it.leafId to it.esMixed }.toMap()

  return com.danstutzman.templates.GetEsUniqueConjugations(
    uniqueConjugations, infEsByLeafId)
}