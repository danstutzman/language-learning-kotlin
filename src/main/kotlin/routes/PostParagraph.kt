package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Paragraph

fun PostParagraph(
  db: Db,
  paragraphId: Int,
  submit: String,
  lang: String,
  topic: String,
  enabled: Boolean
) {
  if (submit == "Update Paragraph") {
    val paragraph = Paragraph(paragraphId, lang, topic, enabled)
    db.paragraphsTable.update(paragraph)
  } else if (submit == "Delete Paragraph") {
    db.paragraphsTable.delete(paragraphId)
  } else {
    throw RuntimeException("Unexpected submit value: ${submit}")
  }
}