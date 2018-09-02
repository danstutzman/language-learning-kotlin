package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class EsUniqueConjugation(
  val leafId: Int,
  val esMixed: String,
  val en: String,
  val infLeafId: Int,
  val number: Int,
  val person: Int,
  val tense: String,
  val enDisambiguation: String // "" if none
)

val ES_UNIQUE_CONJUGATION_TYPE = "EsUniqueV"

class EsUniqueConjugationsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAll(): List<EsUniqueConjugation> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.ES_MIXED,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE,
        LEAFS.EN_DISAMBIGUATION)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq(ES_UNIQUE_CONJUGATION_TYPE))
      .fetch()
      .map { EsUniqueConjugation(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.ES_MIXED),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.NUMBER),
        it.getValue(LEAFS.PERSON),
        it.getValue(LEAFS.TENSE),
        it.getValue(LEAFS.EN_DISAMBIGUATION)
      )}

  fun insert(uniqueConjugation: EsUniqueConjugation) =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.ES_MIXED,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE,
        LEAFS.EN_DISAMBIGUATION)
    .values(ES_UNIQUE_CONJUGATION_TYPE,
        uniqueConjugation.esMixed,
        uniqueConjugation.en,
        uniqueConjugation.infLeafId,
        uniqueConjugation.number,
        uniqueConjugation.person,
        uniqueConjugation.tense,
        uniqueConjugation.enDisambiguation)
    .execute()

  fun delete(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()
}