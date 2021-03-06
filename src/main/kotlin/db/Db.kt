package com.danstutzman.db

import java.sql.Connection

class Db(
  private val conn: Connection
) {
  val arNonverbsTable = ArNonverbsTable(conn)
  val arNounsTable = ArNounsTable(conn)
  val arStemChangesTable = ArStemChangesTable(conn)
  val arUniqueConjugationsTable = ArUniqueConjugationsTable(conn)
  val arVRootsTable = ArVerbRootsTable(conn)
  val cardsTable = CardsTable(conn)
  val cardEmbeddingsTable = CardEmbeddingsTable(conn)
  val esInfinitivesTable = EsInfinitivesTable(conn)
  val esNonverbsTable = EsNonverbsTable(conn)
  val esStemChangesTable = EsStemChangesTable(conn)
  val esUniqueConjugationsTable = EsUniqueConjugationsTable(conn)
  val frInfinitivesTable = FrInfinitivesTable(conn)
  val frNonverbsTable = FrNonverbsTable(conn)
  val frStemChangesTable = FrStemChangesTable(conn)
  val frUniqueConjugationsTable = FrUniqueConjugationsTable(conn)
  val goalsTable = GoalsTable(conn)
  val morphemesTable = MorphemesTable(conn)
  val newCardsTable = NewCardsTable(conn)
  val paragraphsTable = ParagraphsTable(conn)
}