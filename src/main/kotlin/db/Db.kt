package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.SQLDialect
import org.jooq.generated.Sequences.LEAF_IDS
import org.jooq.generated.tables.Cards.CARDS
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.generated.tables.Infinitives.INFINITIVES
import org.jooq.generated.tables.Nonverbs.NONVERBS
import org.jooq.generated.tables.StemChanges.STEM_CHANGES
import org.jooq.generated.tables.UniqueConjugations.UNIQUE_CONJUGATIONS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Goal(
  val goalId: Int,
  val tagsCsv: String,
  val en: String,
  val es: String
)

data class CardRow(
  val cardId: Int,
  val glossRowsJson: String,
  val lastSeenAt: Int?,
  val leafIdsCsv: String,
  val mnemonic: String,
  val prompt: String,
  val stage: Int
)

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
  val infinitiveEsMixed: String,
  val number: Int,
  val person: Int,
  val tense: String
)

data class StemChangeRow(
  val leafId: Int,
  val infinitiveEsMixed: String,
  val stemMixed: String,
  val tense: String
)

class Db(
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  fun now() = Timestamp(System.currentTimeMillis().toLong())

  private fun mustAffectOneRow(numRowsAffected: Int) =
    if (numRowsAffected != 1) {
      throw RuntimeException("numRowsAffected ${numRowsAffected} != 1")
    } else {}

  fun insertGoal(goal: Goal) =
    create
      .insertInto(GOALS,
          GOALS.TAGS_CSV,
          GOALS.EN,
          GOALS.ES,
          GOALS.UPDATED_AT)
      .values(goal.tagsCsv,
          goal.en,
          goal.es,
          now())
      .returning(
          GOALS.GOAL_ID,
          GOALS.TAGS_CSV,
          GOALS.EN,
          GOALS.ES)
      .fetchOne()

  fun selectGoalById(goalId: Int): Goal? {
    val maybeRow = create
      .select(
        GOALS.GOAL_ID,
        GOALS.TAGS_CSV,
        GOALS.EN,
        GOALS.ES)
      .from(GOALS)
      .where(GOALS.GOAL_ID.eq(goalId))
      .fetchOne()

    return maybeRow?.map {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.TAGS_CSV),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES)
      )
    }
  }

  fun selectAllGoals(): List<Goal> {
    val rows = create
      .select(
        GOALS.GOAL_ID,
        GOALS.TAGS_CSV,
        GOALS.EN,
        GOALS.ES)
      .from(GOALS)
      .fetch()

    return rows.map {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.TAGS_CSV),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES)
      )
    }
  }

  fun updateGoal(goal: Goal) {
    create.update(GOALS)
      .set(GOALS.TAGS_CSV, goal.tagsCsv)
      .set(GOALS.EN, goal.en)
      .set(GOALS.ES, goal.es)
      .set(GOALS.UPDATED_AT, now())
      .where(GOALS.GOAL_ID.eq(goal.goalId))
      .execute()
  }

  fun deleteGoal(goal: Goal) {
    create.delete(GOALS)
      .where(GOALS.GOAL_ID.eq(goal.goalId))
      .execute()
  }

  fun insertCardRows(cardRows: List<CardRow>) {
    if (cardRows.size == 0) { return }
    var statement = create
      .insertInto(CARDS,
          CARDS.GLOSS_ROWS_JSON,
          CARDS.LAST_SEEN_AT,
          CARDS.LEAF_IDS_CSV,
          CARDS.MNEMONIC,
          CARDS.PROMPT,
          CARDS.STAGE,
          CARDS.UPDATED_AT)
    for (row in cardRows) {
      statement = statement.values(
        row.glossRowsJson,
        row.lastSeenAt?.let { java.sql.Timestamp(it.toLong() * 1000) },
        row.leafIdsCsv,
        row.mnemonic,
        row.prompt,
        row.stage,
        now())
    }
    statement.onDuplicateKeyIgnore().execute()
  }

  fun selectAllCardRows(): List<CardRow> {
    val rows = create
      .select(
        CARDS.CARD_ID,
        CARDS.GLOSS_ROWS_JSON,
        CARDS.LAST_SEEN_AT,
        CARDS.LEAF_IDS_CSV,
        CARDS.MNEMONIC,
        CARDS.PROMPT,
        CARDS.STAGE)
      .from(CARDS)
      .fetch()

    return rows.map {
      CardRow(
        it.getValue(CARDS.CARD_ID),
        it.getValue(CARDS.GLOSS_ROWS_JSON),
        it.getValue(CARDS.LAST_SEEN_AT)?.let { it.getTime() / 1000 }?.toInt(),
        it.getValue(CARDS.LEAF_IDS_CSV),
        it.getValue(CARDS.MNEMONIC),
        it.getValue(CARDS.PROMPT),
        it.getValue(CARDS.STAGE)
      )
    }
  }

  fun selectAllNonverbRows(): List<NonverbRow> {
    val rows = create
      .select(
        NONVERBS.LEAF_ID,
        NONVERBS.EN,
        NONVERBS.EN_DISAMBIGUATION,
        NONVERBS.EN_PLURAL,
        NONVERBS.ES_MIXED)
      .from(NONVERBS)
      .fetch()

    return rows.map {
      NonverbRow(
        it.getValue(NONVERBS.LEAF_ID),
        it.getValue(NONVERBS.EN),
        it.getValue(NONVERBS.EN_DISAMBIGUATION),
        it.getValue(NONVERBS.EN_PLURAL),
        it.getValue(NONVERBS.ES_MIXED)
      )
    }
  }

  fun insertNonverbRow(nonverb: NonverbRow) {
    val leafId = create.nextval(LEAF_IDS).toInt()

    create
      .insertInto(NONVERBS,
          NONVERBS.LEAF_ID,
          NONVERBS.EN,
          NONVERBS.EN_DISAMBIGUATION,
          NONVERBS.EN_PLURAL,
          NONVERBS.ES_MIXED)
      .values(leafId,
          nonverb.en,
          nonverb.enDisambiguation,
          nonverb.enPlural,
          nonverb.esMixed)
      .returning(
          NONVERBS.LEAF_ID,
          NONVERBS.EN,
          NONVERBS.EN_DISAMBIGUATION,
          NONVERBS.EN_PLURAL,
          NONVERBS.ES_MIXED)
      .fetchOne()
  }

  fun deleteNonverbRow(nonverbRow: NonverbRow) =
    create.delete(NONVERBS)
      .where(NONVERBS.LEAF_ID.eq(nonverbRow.leafId))
      .execute()

  fun selectAllInfinitives(): List<Infinitive> {
    val rows = create
      .select(
        INFINITIVES.LEAF_ID,
        INFINITIVES.EN,
        INFINITIVES.EN_DISAMBIGUATION,
        INFINITIVES.EN_PAST,
        INFINITIVES.ES_MIXED)
      .from(INFINITIVES)
      .fetch()

    return rows.map {
      Infinitive(
        it.getValue(INFINITIVES.LEAF_ID),
        it.getValue(INFINITIVES.EN),
        it.getValue(INFINITIVES.EN_DISAMBIGUATION),
        it.getValue(INFINITIVES.EN_PAST),
        it.getValue(INFINITIVES.ES_MIXED)
      )
    }
  }

  fun insertInfinitive(infinitive: Infinitive) {
    val leafId = create.nextval(LEAF_IDS).toInt()

    create
      .insertInto(INFINITIVES,
          INFINITIVES.LEAF_ID,
          INFINITIVES.EN,
          INFINITIVES.EN_DISAMBIGUATION,
          INFINITIVES.EN_PAST,
          INFINITIVES.ES_MIXED)
      .values(leafId,
          infinitive.en,
          infinitive.enDisambiguation,
          infinitive.enPast,
          infinitive.esMixed)
      .returning(
          INFINITIVES.LEAF_ID,
          INFINITIVES.EN,
          INFINITIVES.EN_DISAMBIGUATION,
          INFINITIVES.EN_PAST,
          INFINITIVES.ES_MIXED)
      .fetchOne()
  }

  fun deleteInfinitive(infinitive: Infinitive) =
    create.delete(INFINITIVES)
      .where(INFINITIVES.LEAF_ID.eq(infinitive.leafId))
      .execute()

  fun selectAllUniqueConjugations(): List<UniqueConjugation> {
    val rows = create
      .select(
        UNIQUE_CONJUGATIONS.LEAF_ID,
        UNIQUE_CONJUGATIONS.ES_MIXED,
        UNIQUE_CONJUGATIONS.EN,
        UNIQUE_CONJUGATIONS.INFINITIVE_ES_MIXED,
        UNIQUE_CONJUGATIONS.NUMBER,
        UNIQUE_CONJUGATIONS.PERSON,
        UNIQUE_CONJUGATIONS.TENSE)
      .from(UNIQUE_CONJUGATIONS)
      .fetch()

    return rows.map {
      UniqueConjugation(
        it.getValue(UNIQUE_CONJUGATIONS.LEAF_ID),
        it.getValue(UNIQUE_CONJUGATIONS.ES_MIXED),
        it.getValue(UNIQUE_CONJUGATIONS.EN),
        it.getValue(UNIQUE_CONJUGATIONS.INFINITIVE_ES_MIXED),
        it.getValue(UNIQUE_CONJUGATIONS.NUMBER),
        it.getValue(UNIQUE_CONJUGATIONS.PERSON),
        it.getValue(UNIQUE_CONJUGATIONS.TENSE)
      )
    }
  }

  fun insertUniqueConjugation(uniqueConjugation: UniqueConjugation) {
    val leafId = create.nextval(LEAF_IDS).toInt()

    create
      .insertInto(UNIQUE_CONJUGATIONS,
          UNIQUE_CONJUGATIONS.LEAF_ID,
          UNIQUE_CONJUGATIONS.ES_MIXED,
          UNIQUE_CONJUGATIONS.EN,
          UNIQUE_CONJUGATIONS.INFINITIVE_ES_MIXED,
          UNIQUE_CONJUGATIONS.NUMBER,
          UNIQUE_CONJUGATIONS.PERSON,
          UNIQUE_CONJUGATIONS.TENSE)
      .values(leafId,
          uniqueConjugation.esMixed,
          uniqueConjugation.en,
          uniqueConjugation.infinitiveEsMixed,
          uniqueConjugation.number,
          uniqueConjugation.person,
          uniqueConjugation.tense)
      .returning(
          UNIQUE_CONJUGATIONS.LEAF_ID,
          UNIQUE_CONJUGATIONS.ES_MIXED,
          UNIQUE_CONJUGATIONS.EN,
          UNIQUE_CONJUGATIONS.INFINITIVE_ES_MIXED,
          UNIQUE_CONJUGATIONS.NUMBER,
          UNIQUE_CONJUGATIONS.PERSON,
          UNIQUE_CONJUGATIONS.TENSE)
      .fetchOne()
  }

  fun deleteUniqueConjugation(uniqueConjugation: UniqueConjugation) =
    create.delete(UNIQUE_CONJUGATIONS)
      .where(UNIQUE_CONJUGATIONS.LEAF_ID.eq(uniqueConjugation.leafId))
      .execute()

  fun selectAllStemChangeRows(): List<StemChangeRow> {
    val rows = create
      .select(
        STEM_CHANGES.LEAF_ID,
        STEM_CHANGES.INFINITIVE_ES_MIXED,
        STEM_CHANGES.STEM_MIXED,
        STEM_CHANGES.TENSE)
      .from(STEM_CHANGES)
      .fetch()

    return rows.map {
      StemChangeRow(
        it.getValue(STEM_CHANGES.LEAF_ID),
        it.getValue(STEM_CHANGES.INFINITIVE_ES_MIXED),
        it.getValue(STEM_CHANGES.STEM_MIXED),
        it.getValue(STEM_CHANGES.TENSE)
      )
    }
  }

  fun insertStemChangeRow(row: StemChangeRow) {
    val leafId = create.nextval(LEAF_IDS).toInt()

    create
      .insertInto(STEM_CHANGES,
          STEM_CHANGES.LEAF_ID,
          STEM_CHANGES.INFINITIVE_ES_MIXED,
          STEM_CHANGES.STEM_MIXED,
          STEM_CHANGES.TENSE)
      .values(leafId,
          row.infinitiveEsMixed,
          row.stemMixed,
          row.tense)
      .returning(
          STEM_CHANGES.LEAF_ID,
          STEM_CHANGES.INFINITIVE_ES_MIXED,
          STEM_CHANGES.STEM_MIXED,
          STEM_CHANGES.TENSE)
      .fetchOne()
  }

  fun deleteStemChangeRow(row: StemChangeRow) =
    create.delete(STEM_CHANGES)
      .where(STEM_CHANGES.LEAF_ID.eq(row.leafId))
      .execute()
}