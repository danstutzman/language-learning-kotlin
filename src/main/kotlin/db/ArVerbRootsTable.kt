package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class ArVerbRoot(
  val leafId: Int,
  val en: String,
  val enPast: String,
  val arBuckwalter: String,
  var arPresMiddleVowelBuckwalter: String
)

val AR_VERB_ROOT_TYPE = "ArVRoot"

class ArVerbRootsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<ArVerbRoot> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.AR_BUCKWALTER,
        LEAFS.AR_PRES_MIDDLE_VOWEL_BUCKWALTER)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(AR_VERB_ROOT_TYPE))
      .fetch()
      .map { ArVerbRoot(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.AR_BUCKWALTER),
        it.getValue(LEAFS.AR_PRES_MIDDLE_VOWEL_BUCKWALTER)
      )}

  fun insert(verbRoot: ArVerbRoot): ArVerbRoot =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.AR_BUCKWALTER,
        LEAFS.AR_PRES_MIDDLE_VOWEL_BUCKWALTER)
      .values(AR_VERB_ROOT_TYPE,
        verbRoot.en,
        verbRoot.enPast,
        verbRoot.arBuckwalter,
        verbRoot.arPresMiddleVowelBuckwalter)
      .returning(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_PAST,
        LEAFS.AR_BUCKWALTER,
        LEAFS.AR_PRES_MIDDLE_VOWEL_BUCKWALTER)
      .fetchOne()
      .let {
        ArVerbRoot(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.EN_PAST),
          it.getValue(LEAFS.AR_BUCKWALTER),
          it.getValue(LEAFS.AR_PRES_MIDDLE_VOWEL_BUCKWALTER)
        )
      }

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}