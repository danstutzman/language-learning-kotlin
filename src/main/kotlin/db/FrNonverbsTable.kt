package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class FrNonverb(
  val leafId: Int,
  val en: String,
  val frMixed: String
)

val FR_NONVERB_TYPE = "FrNonverb"

class FrNonverbsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<FrNonverb> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.FR_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(FR_NONVERB_TYPE))
      .fetch()
      .map { FrNonverb(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.FR_MIXED)
      )}

  fun insert(nonverb: FrNonverb): FrNonverb =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.EN,
        LEAFS.FR_MIXED)
      .values(FR_NONVERB_TYPE,
        nonverb.en,
        nonverb.frMixed)
      .returning(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.FR_MIXED)
      .fetchOne()
      .let {
        FrNonverb(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.FR_MIXED)
        )
      }

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}