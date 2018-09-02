package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Paragraph

fun PostParagraphs(db: Db, topic: String, enabled: Boolean) {
  db.paragraphsTable.insert(Paragraph(0, topic, enabled))
}