package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.DSLContext
import org.jooq.SQLDialect
import org.jooq.generated.tables.Cards.CARDS
import org.jooq.generated.tables.CardEmbeddings.CARD_EMBEDDINGS
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.generated.tables.Paragraphs.PARAGRAPHS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

class Db(
  private val conn: Connection
) {
  val cardsTable = CardsTable(conn)
  val cardEmbeddingsTable = CardEmbeddingsTable(conn)
  val goalsTable = GoalsTable(conn)
  val leafsTable = LeafsTable(conn)
  val paragraphsTable = ParagraphsTable(conn)
}