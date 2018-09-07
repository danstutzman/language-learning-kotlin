package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetArVerbRoots(db: Db): String {
  val verbRootRows = db.arVRootsTable.selectAll()
  return com.danstutzman.templates.GetArVerbRoots(verbRootRows)
}