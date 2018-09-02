package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetEsStemChanges(db: Db): String {
  val stemChanges = db.esStemChangesTable.selectAll()

  val infEsMixedByLeafId = db.esInfinitivesTable.selectWithLeafIdIn(
    stemChanges.map { it.infLeafId }.distinct()
  ).map { it.leafId to it.esMixed }.toMap()

  return com.danstutzman.templates.GetEsStemChanges(
    stemChanges, infEsMixedByLeafId)
}