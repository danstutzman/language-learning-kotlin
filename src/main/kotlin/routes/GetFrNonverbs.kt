package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetFrNonverbs(db: Db): String {
  val nonverbs = db.frNonverbsTable.selectAll()
  return com.danstutzman.templates.GetFrNonverbs(nonverbs)
}