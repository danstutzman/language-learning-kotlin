package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class EsStemChange(
  val leafId: Int,
  val infLeafId: Int,
  val esMixed: String,
  val tense: String,
  val en: String,
  val enPast: String,
  val enDisambiguation: String // "" if none
)

class EsStemChangesTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<EsStemChange> {
    val rows = create
      .select(
        LEAFS.LEAF_ID,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.ES_MIXED,
        LEAFS.TENSE,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.EN_DISAMBIGUATION)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("StemChange"))
      .fetch()

    return rows.map {
      EsStemChange(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.ES_MIXED),
        it.getValue(LEAFS.TENSE),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.EN_DISAMBIGUATION)
      )
    }
  }

  fun insert(row: EsStemChange) =
    create
      .insertInto(LEAFS,
          LEAFS.LEAF_TYPE,
          LEAFS.INFINITIVE_LEAF_ID,
          LEAFS.ES_MIXED,
          LEAFS.TENSE,
          LEAFS.EN,
          LEAFS.EN_PAST,
          LEAFS.EN_DISAMBIGUATION)
      .values("StemChange",
          row.infLeafId,
          row.esMixed,
          row.tense,
          row.en,
          row.enPast,
          row.enDisambiguation)
      .returning(
          LEAFS.LEAF_ID,
          LEAFS.INFINITIVE_LEAF_ID,
          LEAFS.ES_MIXED,
          LEAFS.TENSE,
          LEAFS.EN,
          LEAFS.EN_PAST,
          LEAFS.EN_DISAMBIGUATION)
      .fetchOne()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}