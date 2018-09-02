package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetEsInfinitives(db: Db): String {
  val infs = db.esInfinitivesTable.selectAll()
  return com.danstutzman.templates.GetEsInfinitives(infs)
}