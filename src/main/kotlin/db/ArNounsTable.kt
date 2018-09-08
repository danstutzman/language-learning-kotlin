package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class ArNounRow(
  val leafId: Int,
  val en: String,
  val arBuckwalter: String,
  val gender: String
)

val AR_NOUN_TYPE = "ArNoun"

class ArNounsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<ArNounRow> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.AR_BUCKWALTER,
        LEAFS.GENDER)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(AR_NOUN_TYPE))
      .fetch()
      .map { ArNounRow(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.AR_BUCKWALTER),
        it.getValue(LEAFS.GENDER)
      )}

  fun insert(noun: ArNounRow): ArNounRow =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.EN,
        LEAFS.AR_BUCKWALTER,
        LEAFS.GENDER)
      .values(AR_NOUN_TYPE,
        noun.en,
        noun.arBuckwalter,
        noun.gender)
      .returning(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.AR_BUCKWALTER,
        LEAFS.GENDER)
      .fetchOne()
      .let {
        ArNounRow(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.AR_BUCKWALTER),
          it.getValue(LEAFS.GENDER)
        )
      }

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}