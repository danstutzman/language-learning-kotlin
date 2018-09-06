package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetArNonverbs(db: Db): String {
  val nonverbs = db.arNonverbsTable.selectAll()
  return com.danstutzman.templates.GetArNonverbs(nonverbs)
}