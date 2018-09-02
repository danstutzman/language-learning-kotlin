package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetNonverbs(db: Db): String {
  val nonverbs = db.leafsTable.selectAllNonverbRows()
  return com.danstutzman.templates.GetNonverbs(nonverbs)
}