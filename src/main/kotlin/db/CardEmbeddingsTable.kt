package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.CardEmbeddings.CARD_EMBEDDINGS
import org.jooq.impl.DSL

data class CardEmbedding(
  val longerCardId: Int,
  val shorterCardId: Int,
  val firstLeafIndex: Int,
  val lastLeafIndex: Int
)

class CardEmbeddingsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectWithLongerCardIdIn(longerCardIds: List<Int>) :
    List<CardEmbedding> {
    val rows = create
      .select(
        CARD_EMBEDDINGS.LONGER_CARD_ID,
        CARD_EMBEDDINGS.SHORTER_CARD_ID,
        CARD_EMBEDDINGS.FIRST_LEAF_INDEX,
        CARD_EMBEDDINGS.LAST_LEAF_INDEX)
      .from(CARD_EMBEDDINGS)
      .where(CARD_EMBEDDINGS.LONGER_CARD_ID.`in`(longerCardIds))
      .fetch()

    return rows.map {
      CardEmbedding(
        it.getValue(CARD_EMBEDDINGS.LONGER_CARD_ID),
        it.getValue(CARD_EMBEDDINGS.SHORTER_CARD_ID),
        it.getValue(CARD_EMBEDDINGS.FIRST_LEAF_INDEX),
        it.getValue(CARD_EMBEDDINGS.LAST_LEAF_INDEX)
      )
    }
  }

  fun insertCardEmbeddings(cardEmbeddings: List<CardEmbedding>) {
    if (cardEmbeddings.size == 0) { return }
    var statement = create.insertInto(CARD_EMBEDDINGS,
      CARD_EMBEDDINGS.LONGER_CARD_ID,
      CARD_EMBEDDINGS.SHORTER_CARD_ID,
      CARD_EMBEDDINGS.FIRST_LEAF_INDEX,
      CARD_EMBEDDINGS.LAST_LEAF_INDEX)
    for (cardEmbedding in cardEmbeddings) {
      statement = statement.values(cardEmbedding.longerCardId,
        cardEmbedding.shorterCardId,
        cardEmbedding.firstLeafIndex,
        cardEmbedding.lastLeafIndex)
    }
    statement.onDuplicateKeyIgnore().execute()
  }
}