package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL

data class NonverbRow(
  val leafId: Int,
  val en: String,
  val enDisambiguation: String, // "" if none
  val enPlural: String?,
  val esMixed: String
)

data class Infinitive(
  val leafId: Int,
  val en: String,
  val enDisambiguation: String, // "" if none
  val enPast: String,
  val esMixed: String
)

data class UniqueConjugation(
  val leafId: Int,
  val esMixed: String,
  val en: String,
  val infLeafId: Int,
  val number: Int,
  val person: Int,
  val tense: String,
  val enDisambiguation: String // "" if none
)

data class StemChangeRow(
  val leafId: Int,
  val infLeafId: Int,
  val esMixed: String,
  val tense: String,
  val en: String,
  val enPast: String,
  val enDisambiguation: String // "" if none
)

class LeafsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectAllNonverbRows(): List<NonverbRow> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PLURAL,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("Nonverb"))
      .fetch()
      .map { NonverbRow(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PLURAL),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun insertNonverbRow(nonverb: NonverbRow): NonverbRow =
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
        NonverbRow(
          it.getValue(LEAFS.LEAF_ID),
          it.getValue(LEAFS.EN),
          it.getValue(LEAFS.EN_DISAMBIGUATION),
          it.getValue(LEAFS.EN_PLURAL),
          it.getValue(LEAFS.ES_MIXED)
        )
      }

  fun deleteLeaf(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()

  fun selectAllInfinitives(): List<Infinitive> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("Inf"))
      .fetch()
      .map { Infinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun selectInfinitivesWithLeafIdIn(leafIds: List<Int>): List<Infinitive> =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("Inf"))
      .and(LEAFS.LEAF_ID.`in`(leafIds))
      .fetch()
      .map { Infinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun findInfinitiveByEsMixed(esMixed: String): Infinitive? =
    create.select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.ES_MIXED.eq(esMixed))
      .fetchOne()
      ?.let { Infinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )}

  fun insertInfinitive(infinitive: Infinitive) =
    create.insertInto(LEAFS,
      LEAFS.LEAF_TYPE,
      LEAFS.EN,
      LEAFS.EN_DISAMBIGUATION,
      LEAFS.EN_PAST,
      LEAFS.ES_MIXED)
    .values("Inf",
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

  fun selectAllUniqueConjugations(): List<UniqueConjugation> =
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
      .where(LEAFS.LEAF_TYPE.eq("UniqV"))
      .fetch()
      .map { UniqueConjugation(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.ES_MIXED),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.INFINITIVE_LEAF_ID),
        it.getValue(LEAFS.NUMBER),
        it.getValue(LEAFS.PERSON),
        it.getValue(LEAFS.TENSE),
        it.getValue(LEAFS.EN_DISAMBIGUATION)
      )}

  fun insertUniqueConjugation(uniqueConjugation: UniqueConjugation) =
    create.insertInto(LEAFS,
        LEAFS.LEAF_TYPE,
        LEAFS.ES_MIXED,
        LEAFS.EN,
        LEAFS.INFINITIVE_LEAF_ID,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE,
        LEAFS.EN_DISAMBIGUATION)
    .values("UniqV",
        uniqueConjugation.esMixed,
        uniqueConjugation.en,
        uniqueConjugation.infLeafId,
        uniqueConjugation.number,
        uniqueConjugation.person,
        uniqueConjugation.tense,
        uniqueConjugation.enDisambiguation)
    .execute()

  fun selectAllStemChangeRows(): List<StemChangeRow> {
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
      StemChangeRow(
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

  fun insertStemChangeRow(row: StemChangeRow) =
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
}