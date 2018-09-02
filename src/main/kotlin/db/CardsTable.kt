package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Cards.CARDS
import org.jooq.impl.DSL

data class CardRow(
  val cardId: Int,
  val glossRowsJson: String,
  val lastSeenAt: Int?,
  val leafIdsCsv: String,
  val mnemonic: String,
  val prompt: String,
  val stage: Int
)

data class CardUpdate(
  val cardId: Int,
  val lastSeenAt: Int?,
  val mnemonic: String,
  val stage: Int
)

class CardsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectWithCardIdIn(cardIds: List<Int>): List<CardRow> =
    create.select(
      CARDS.CARD_ID,
      CARDS.GLOSS_ROWS_JSON,
      CARDS.LAST_SEEN_AT,
      CARDS.LEAF_IDS_CSV,
      CARDS.MNEMONIC,
      CARDS.PROMPT,
      CARDS.STAGE)
    .from(CARDS)
    .where(CARDS.CARD_ID.`in`(cardIds))
    .fetch()
    .map { CardRow(
      it.getValue(CARDS.CARD_ID),
      it.getValue(CARDS.GLOSS_ROWS_JSON),
      it.getValue(CARDS.LAST_SEEN_AT)?.let { it.getTime() / 1000 }?.toInt(),
      it.getValue(CARDS.LEAF_IDS_CSV),
      it.getValue(CARDS.MNEMONIC),
      it.getValue(CARDS.PROMPT),
      it.getValue(CARDS.STAGE)
    )}

  fun selectLeafIdsCsvCardIdPairs(): List<Pair<String, Int>> =
    create.select(CARDS.LEAF_IDS_CSV, CARDS.CARD_ID)
      .from(CARDS)
      .fetch()
      .map { Pair(it.getValue(CARDS.LEAF_IDS_CSV), it.getValue(CARDS.CARD_ID)) }

  fun insert(cardRows: List<CardRow>) {
    if (cardRows.size == 0) { return }
    var statement = create.insertInto(
      CARDS,
      CARDS.GLOSS_ROWS_JSON,
      CARDS.LAST_SEEN_AT,
      CARDS.LEAF_IDS_CSV,
      CARDS.MNEMONIC,
      CARDS.PROMPT,
      CARDS.STAGE,
      CARDS.UPDATED_AT)
    for (row in cardRows) {
      statement = statement.values(
        row.glossRowsJson,
        row.lastSeenAt?.let { Timestamp(it.toLong() * 1000) },
        row.leafIdsCsv,
        row.mnemonic,
        row.prompt,
        row.stage,
        now())
    }
    statement.onDuplicateKeyIgnore().execute()
  }

  fun update(cardUpdate: CardUpdate) =
    create.update(CARDS)
      .set(CARDS.LAST_SEEN_AT,
        cardUpdate.lastSeenAt?.let { Timestamp(it.toLong() * 1000) })
      .set(CARDS.MNEMONIC, cardUpdate.mnemonic)
      .set(CARDS.STAGE, cardUpdate.stage)
      .set(CARDS.UPDATED_AT, now())
      .where(CARDS.CARD_ID.eq(cardUpdate.cardId))
      .execute()
}