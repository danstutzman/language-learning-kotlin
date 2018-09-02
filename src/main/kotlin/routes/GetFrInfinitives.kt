package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetFrInfinitives(db: Db): String {
  val infs = db.frInfinitivesTable.selectAll()
  return com.danstutzman.templates.GetFrInfinitives(infs)
}