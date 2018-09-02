package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetParagraph(db: Db, paragraphId: Int): String {
  val paragraph = db.paragraphsTable.selectById(paragraphId)!!
  val goals = db.goalsTable.selectWithParagraphIdIn(listOf(paragraphId))
  return com.danstutzman.templates.GetParagraph(paragraph, goals)
}
