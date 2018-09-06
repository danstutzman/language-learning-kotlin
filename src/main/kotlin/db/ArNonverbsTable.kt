package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class ArNonverb(
  val leafId: Int,
  val en: String,
  val arBuckwalter: String
)

val AR_NONVERB_TYPE = "ArNonverb"

class ArNonverbsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<ArNonverb> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.AR_BUCKWALTER)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(AR_NONVERB_TYPE))
      .fetch()
      .map { ArNonverb(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.AR_BUCKWALTER)
      )}

  fun insert(nonverb: ArNonverb): ArNonverb =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.EN,
        LEAFS.AR_BUCKWALTER)
      .values(AR_NONVERB_TYPE,
        nonverb.en,
        nonverb.arBuckwalter)
      .returning(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.AR_BUCKWALTER)
      .fetchOne()
      .let {
        ArNonverb(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.AR_BUCKWALTER)
        )
      }

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}