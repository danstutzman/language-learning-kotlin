package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetStemChanges(db: Db): String {
  val stemChanges = db.leafsTable.selectAllStemChangeRows()
  val infEsMixedByLeafId = db.leafsTable.selectInfinitivesWithLeafIdIn(
    stemChanges.map { it.infLeafId }.distinct()
  ).map { it.leafId to it.esMixed }.toMap()
  return com.danstutzman.templates.GetStemChanges(
    stemChanges, infEsMixedByLeafId)
}