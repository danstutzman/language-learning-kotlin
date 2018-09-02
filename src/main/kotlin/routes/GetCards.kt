package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetCards(db: Db): String {
  val cardRows = db.cardsTable.selectAll()
  return com.danstutzman.templates.GetCards(cardRows)
}