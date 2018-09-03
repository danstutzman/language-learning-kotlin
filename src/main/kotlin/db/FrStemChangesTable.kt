package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class FrStemChange(
  val leafId: Int,
  val infLeafId: Int,
  val frMixed: String,
  val tense: String,
  val en: String,
  val enPast: String
)

val FR_STEM_CHANGE_TYPE = "FrStemChange"

class FrStemChangesTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<FrStemChange> {
    val rows = create
      .select(
        LEAFS.LEAF_ID,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.FR_MIXED,
        LEAFS.TENSE,
        LEAFS.EN,
        LEAFS.EN_PAST)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(FR_STEM_CHANGE_TYPE))
      .fetch()

    return rows.map {
      FrStemChange(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.FR_MIXED),
        it.getValue(LEAFS.TENSE),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST)
      )
    }
  }

  fun insert(row: FrStemChange) =
    create
      .insertInto(LEAFS,
          LEAFS.LEAF_TYPE,
          LEAFS.INFINITIVE_LEAF_ID,
          LEAFS.FR_MIXED,
          LEAFS.TENSE,
          LEAFS.EN,
          LEAFS.EN_PAST)
      .values(FR_STEM_CHANGE_TYPE,
          row.infLeafId,
          row.frMixed,
          row.tense,
          row.en,
          row.enPast)
      .returning(
          LEAFS.LEAF_ID,
          LEAFS.INFINITIVE_LEAF_ID,
          LEAFS.FR_MIXED,
          LEAFS.TENSE,
          LEAFS.EN,
          LEAFS.EN_PAST)
      .fetchOne()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}