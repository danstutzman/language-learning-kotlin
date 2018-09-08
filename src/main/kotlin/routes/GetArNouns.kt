package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetArNouns(db: Db): String {
  val nounRows = db.arNounsTable.selectAll()
  return com.danstutzman.templates.GetArNouns(nounRows)
}