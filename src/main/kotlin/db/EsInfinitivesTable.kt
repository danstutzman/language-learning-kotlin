package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class EsInfinitive(
  val leafId: Int,
  val en: String,
  val enDisambiguation: String, // "" if none
  val enPast: String,
  val esMixed: String
)

val ES_INFINITIVE_TYPE = "EsInf"

class EsInfinitivesTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<EsInfinitive> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(ES_INFINITIVE_TYPE))
      .fetch()
      .map { EsInfinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun selectWithLeafIdIn(leafIds: List<Int>): List<EsInfinitive> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(ES_INFINITIVE_TYPE))
      .and(LEAFS.LEAF_ID.`in`(leafIds))
      .fetch()
      .map { EsInfinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun findByEsMixed(esMixed: String): EsInfinitive? =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.ES_MIXED.eq(esMixed))
      .fetchOne()
      ?.let { EsInfinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun insert(infinitive: EsInfinitive) =
    create.insertInto(LEAFS,
      LEAFS.LEAF_TYPE,
      LEAFS.EN,
      LEAFS.EN_DISAMBIGUATION,
      LEAFS.EN_PAST,
      LEAFS.ES_MIXED)
    .values(ES_INFINITIVE_TYPE,
      infinitive.en,
      infinitive.enDisambiguation,
      infinitive.enPast,
      infinitive.esMixed)
    .returning(
      LEAFS.LEAF_ID,
      LEAFS.EN,
      LEAFS.EN_DISAMBIGUATION,
      LEAFS.EN_PAST,
      LEAFS.ES_MIXED)
    .fetchOne()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}