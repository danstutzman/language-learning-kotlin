package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class EsNonverb(
  val leafId: Int,
  val en: String,
  val enDisambiguation: String, // "" if none
  val enPlural: String?,
  val esMixed: String
)

val ES_NONVERB_TYPE = "EsNonverb"

class EsNonverbsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<EsNonverb> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PLURAL,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(ES_NONVERB_TYPE))
      .fetch()
      .map { EsNonverb(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PLURAL),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun insert(nonverb: EsNonverb): EsNonverb =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PLURAL,
        LEAFS.ES_MIXED)
      .values("Nonverb",
        nonverb.en,
        nonverb.enDisambiguation,
        nonverb.enPlural,
        nonverb.esMixed)
      .returning(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PLURAL,
        LEAFS.ES_MIXED)
      .fetchOne()
      .let {
        EsNonverb(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.EN_DISAMBIGUATION),
          it.getValue(LEAFS.EN_PLURAL),
          it.getValue(LEAFS.ES_MIXED)
        )
      }

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}