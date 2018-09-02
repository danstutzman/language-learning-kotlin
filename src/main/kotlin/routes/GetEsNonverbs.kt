package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetEsNonverbs(db: Db): String {
  val nonverbs = db.esNonverbsTable.selectAll()
  return com.danstutzman.templates.GetEsNonverbs(nonverbs)
}