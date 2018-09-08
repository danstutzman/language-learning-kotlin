package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class ArUniqueConjugation(
  val leafId: Int,
  val arBuckwalter: String,
  val en: String,
  val rootLeafId: Int,
  val gender: String, // blank if non-applicable
  val number: Int,
  val person: Int,
  val tense: String
)

val AR_UNIQUE_CONJUGATION_TYPE = "ArUniqV"

class ArUniqueConjugationsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<ArUniqueConjugation> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.AR_BUCKWALTER,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.GENDER,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(AR_UNIQUE_CONJUGATION_TYPE))
      .fetch()
      .map { ArUniqueConjugation(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.AR_BUCKWALTER),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.GENDER),
        it.getValue(LEAFS.NUMBER),
        it.getValue(LEAFS.PERSON),
        it.getValue(LEAFS.TENSE)
      )}

  fun insert(uniqueConjugation: ArUniqueConjugation) =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.AR_BUCKWALTER,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.GENDER,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE)
    .values(AR_UNIQUE_CONJUGATION_TYPE,
        uniqueConjugation.arBuckwalter,
        uniqueConjugation.en,
        uniqueConjugation.rootLeafId,
        uniqueConjugation.gender,
        uniqueConjugation.number,
        uniqueConjugation.person,
        uniqueConjugation.tense)
    .execute()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}