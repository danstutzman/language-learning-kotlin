package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetFrStemChanges(db: Db): String {
  val stemChanges = db.frStemChangesTable.selectAll()

  val infFrMixedByLeafId = db.frInfinitivesTable.selectWithLeafIdIn(
    stemChanges.map { it.infLeafId }.distinct()
  ).map { it.leafId to it.frMixed }.toMap()

  return com.danstutzman.templates.GetFrStemChanges(
    stemChanges, infFrMixedByLeafId)
}