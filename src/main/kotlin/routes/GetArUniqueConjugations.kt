package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetArUniqueConjugations(db: Db): String {
  val uniqueConjugations = db.arUniqueConjugationsTable.selectAll()

  val rootBuckwalterByLeafId = db.arVRootsTable.selectWithLeafIdIn(
    uniqueConjugations.map { it.rootLeafId }.distinct()
  ).map { it.leafId to it.arBuckwalter }.toMap()

  return com.danstutzman.templates.GetArUniqueConjugations(
    uniqueConjugations, rootBuckwalterByLeafId)
}