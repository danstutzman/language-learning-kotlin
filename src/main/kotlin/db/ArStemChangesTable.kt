package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class ArStemChange(
  val leafId: Int,
  val en: String,
  val rootLeafId: Int,
  val arBuckwalter: String,
  val tense: String,
  val personsCsv: String
)

val AR_STEM_CHANGE_TYPE = "ArStemChange"

class ArStemChangesTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<ArStemChange> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.AR_BUCKWALTER,
        LEAFS.TENSE,
        LEAFS.PERSONS_CSV)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(AR_STEM_CHANGE_TYPE))
      .fetch()
      .map { ArStemChange(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.AR_BUCKWALTER),
        it.getValue(LEAFS.TENSE),
        it.getValue(LEAFS.PERSONS_CSV)
      )}

  fun insert(stemChange: ArStemChange): ArStemChange =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.AR_BUCKWALTER,
        LEAFS.TENSE,
        LEAFS.PERSONS_CSV)
      .values(AR_STEM_CHANGE_TYPE,
        stemChange.en,
        stemChange.rootLeafId,
        stemChange.arBuckwalter,
        stemChange.tense,
        stemChange.personsCsv)
      .returning(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.AR_BUCKWALTER,
        LEAFS.TENSE,
        LEAFS.PERSONS_CSV)
      .fetchOne()
      .let {
        ArStemChange(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.INFINITIVE_LEAF_ID),
          it.getValue(LEAFS.AR_BUCKWALTER),
          it.getValue(LEAFS.TENSE),
          it.getValue(LEAFS.PERSONS_CSV)
        )
      }

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}