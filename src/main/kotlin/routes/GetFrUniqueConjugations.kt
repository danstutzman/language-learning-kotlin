package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetFrUniqueConjugations(db: Db): String {
  val uniqueConjugations = db.frUniqueConjugationsTable.selectAll()

  val infFrByLeafId = db.frInfinitivesTable.selectWithLeafIdIn(
    uniqueConjugations.map { it.infLeafId }.distinct()
  ).map { it.leafId to it.frMixed }.toMap()

  return com.danstutzman.templates.GetFrUniqueConjugations(
    uniqueConjugations, infFrByLeafId)
}