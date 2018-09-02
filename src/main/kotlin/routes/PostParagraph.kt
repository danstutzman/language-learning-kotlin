package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Paragraph

fun PostParagraph(
  db: Db,
  paragraphId: Int,
  submit: String,
  topic: String,
  enabled: Boolean
) {
  if (submit == "Edit Paragraph") {
    val paragraph = Paragraph(paragraphId, topic, enabled)
    db.paragraphsTable.update(paragraph)
  } else if (submit == "Delete Paragraph") {
    db.paragraphsTable.delete(paragraphId)
  } else {
    throw RuntimeException("Unexpected submit value: ${submit}")
  }
}