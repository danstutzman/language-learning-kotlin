package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class FrInfinitive(
  val leafId: Int,
  val en: String,
  val enPast: String,
  val frMixed: String
)

val FR_INFINITIVE_TYPE = "FrInf"

class FrInfinitivesTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<FrInfinitive> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.FR_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(FR_INFINITIVE_TYPE))
      .fetch()
      .map { FrInfinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.FR_MIXED)
      )}

  fun selectWithLeafIdIn(leafIds: List<Int>): List<FrInfinitive> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.FR_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(FR_INFINITIVE_TYPE))
      .and(LEAFS.LEAF_ID.`in`(leafIds))
      .fetch()
      .map { FrInfinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.FR_MIXED)
      )}

  fun findByFrMixed(frMixed: String): FrInfinitive? =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.FR_MIXED)
      .from(LEAFS)
      .where(LEAFS.FR_MIXED.eq(frMixed))
      .fetchOne()
      ?.let { FrInfinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.FR_MIXED)
      )}

  fun insert(infinitive: FrInfinitive) =
    create.insertInto(LEAFS,
      LEAFS.LEAF_TYPE,
      LEAFS.EN,
      LEAFS.EN_PAST,
      LEAFS.FR_MIXED)
    .values(FR_INFINITIVE_TYPE,
      infinitive.en,
      infinitive.enPast,
      infinitive.frMixed)
    .returning(
      LEAFS.LEAF_ID,
      LEAFS.EN,
      LEAFS.EN_PAST,
      LEAFS.FR_MIXED)
    .fetchOne()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}