package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class FrUniqueConjugation(
  val leafId: Int,
  val frMixed: String,
  val en: String,
  val infLeafId: Int,
  val number: Int,
  val person: Int,
  val tense: String
)

val FR_UNIQUE_CONJUGATION_TYPE = "FrUniqV"

class FrUniqueConjugationsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<FrUniqueConjugation> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.FR_MIXED,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE,
        LEAFS.EN_DISAMBIGUATION)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(FR_UNIQUE_CONJUGATION_TYPE))
      .fetch()
      .map { FrUniqueConjugation(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.FR_MIXED),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.NUMBER),
        it.getValue(LEAFS.PERSON),
        it.getValue(LEAFS.TENSE)
      )}

  fun insert(uniqueConjugation: FrUniqueConjugation) =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.FR_MIXED,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE)
    .values(FR_UNIQUE_CONJUGATION_TYPE,
        uniqueConjugation.frMixed,
        uniqueConjugation.en,
        uniqueConjugation.infLeafId,
        uniqueConjugation.number,
        uniqueConjugation.person,
        uniqueConjugation.tense)
    .execute()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}