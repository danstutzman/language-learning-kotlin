package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetArStemChanges(db: Db): String {
  val stemChanges = db.arStemChangesTable.selectAll()

  val rootArBuckwalterByLeafId = db.arVRootsTable.selectWithLeafIdIn(
    stemChanges.map { it.rootLeafId }.distinct()
  ).map { it.leafId to it.arBuckwalter }.toMap()

  return com.danstutzman.templates.GetArStemChanges(
    stemChanges, rootArBuckwalterByLeafId)
}