package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetInfinitives(db: Db): String {
  val infinitives = db.leafsTable.selectAllInfinitives()
  return com.danstutzman.templates.GetInfinitives(infinitives)
}