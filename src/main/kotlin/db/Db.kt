package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.SQLDialect
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.generated.tables.Entries.ENTRIES
import org.jooq.generated.tables.Infinitives.INFINITIVES
import org.jooq.generated.tables.StemChanges.STEM_CHANGES
import org.jooq.generated.tables.UniqueConjugations.UNIQUE_CONJUGATIONS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Goal(
  val goalId: Int,
  val tags: String,
  val enFreeText: String,
  val es: String
)

data class EntryRow(
  val entryId: Int,
  val en: String,
  val enDisambiguation: String, // "" if none
  val enPlural: String?,
  val es: String
)

data class Infinitive(
  val infinitiveId: Int,
  val en: String,
  val enDisambiguation: String, // "" if none
  val enPast: String,
  val es: String
)

data class UniqueConjugation(
  val uniqueConjugationId: Int,
  val es: String,
  val en: String,
  val infinitiveEs: String,
  val number: Int,
  val person: Int,
  val tense: String
)

data class StemChangeRow(
  val stemChangeId: Int,
  val infinitiveEs: String,
  val stem: String,
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
          GOALS.TAGS,
          GOALS.EN_FREE_TEXT,
          GOALS.ES,
          GOALS.UPDATED_AT)
      .values(goal.tags,
          goal.enFreeText,
          goal.es,
          now())
      .returning(
          GOALS.GOAL_ID,
          GOALS.TAGS,
          GOALS.EN_FREE_TEXT,
          GOALS.ES)
      .fetchOne()

  fun selectGoalById(goalId: Int): Goal? {
    val maybeRow = create
      .select(
        GOALS.GOAL_ID,
        GOALS.TAGS,
        GOALS.EN_FREE_TEXT,
        GOALS.ES)
      .from(GOALS)
      .where(GOALS.GOAL_ID.eq(goalId))
      .fetchOne()

    return maybeRow?.map {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.TAGS),
        it.getValue(GOALS.EN_FREE_TEXT),
        it.getValue(GOALS.ES)
      )
    }
  }

  fun selectAllGoals(): List<Goal> {
    val rows = create
      .select(
        GOALS.GOAL_ID,
        GOALS.TAGS,
        GOALS.EN_FREE_TEXT,
        GOALS.ES)
      .from(GOALS)
      .fetch()

    return rows.map {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.TAGS),
        it.getValue(GOALS.EN_FREE_TEXT),
        it.getValue(GOALS.ES)
      )
    }
  }

  fun updateGoal(goal: Goal) {
    create.update(GOALS)
      .set(GOALS.TAGS, goal.tags)
      .set(GOALS.EN_FREE_TEXT, goal.enFreeText)
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

  fun selectAllEntryRows(): List<EntryRow> {
    val rows = create
      .select(
        ENTRIES.ENTRY_ID,
        ENTRIES.EN,
        ENTRIES.EN_DISAMBIGUATION,
        ENTRIES.EN_PLURAL,
        ENTRIES.ES)
      .from(ENTRIES)
      .fetch()

    return rows.map {
      EntryRow(
        it.getValue(ENTRIES.ENTRY_ID),
        it.getValue(ENTRIES.EN),
        it.getValue(ENTRIES.EN_DISAMBIGUATION),
        it.getValue(ENTRIES.EN_PLURAL),
        it.getValue(ENTRIES.ES)
      )
    }
  }

  fun insertEntryRow(entry: EntryRow) =
    create
      .insertInto(ENTRIES,
          ENTRIES.EN,
          ENTRIES.EN_DISAMBIGUATION,
          ENTRIES.EN_PLURAL,
          ENTRIES.ES)
      .values(entry.en,
          entry.enDisambiguation,
          entry.enPlural,
          entry.es)
      .returning(
          ENTRIES.ENTRY_ID,
          ENTRIES.EN,
          ENTRIES.EN_DISAMBIGUATION,
          ENTRIES.EN_PLURAL,
          ENTRIES.ES)
      .fetchOne()

  fun deleteEntryRow(entryRow: EntryRow) =
    create.delete(ENTRIES)
      .where(ENTRIES.ENTRY_ID.eq(entryRow.entryId))
      .execute()

  fun selectAllInfinitives(): List<Infinitive> {
    val rows = create
      .select(
        INFINITIVES.INFINITIVE_ID,
        INFINITIVES.EN,
        INFINITIVES.EN_DISAMBIGUATION,
        INFINITIVES.EN_PAST,
        INFINITIVES.ES)
      .from(INFINITIVES)
      .fetch()

    return rows.map {
      Infinitive(
        it.getValue(INFINITIVES.INFINITIVE_ID),
        it.getValue(INFINITIVES.EN),
        it.getValue(INFINITIVES.EN_DISAMBIGUATION),
        it.getValue(INFINITIVES.EN_PAST),
        it.getValue(INFINITIVES.ES)
      )
    }
  }

  fun insertInfinitive(infinitive: Infinitive) =
    create
      .insertInto(INFINITIVES,
          INFINITIVES.EN,
          INFINITIVES.EN_DISAMBIGUATION,
          INFINITIVES.EN_PAST,
          INFINITIVES.ES)
      .values(infinitive.en,
          infinitive.enDisambiguation,
          infinitive.enPast,
          infinitive.es)
      .returning(
          INFINITIVES.INFINITIVE_ID,
          INFINITIVES.EN,
          INFINITIVES.EN_DISAMBIGUATION,
          INFINITIVES.EN_PAST,
          INFINITIVES.ES)
      .fetchOne()

  fun deleteInfinitive(infinitive: Infinitive) =
    create.delete(INFINITIVES)
      .where(INFINITIVES.INFINITIVE_ID.eq(infinitive.infinitiveId))
      .execute()

  fun selectAllUniqueConjugations(): List<UniqueConjugation> {
    val rows = create
      .select(
        UNIQUE_CONJUGATIONS.UNIQUE_CONJUGATION_ID,
        UNIQUE_CONJUGATIONS.ES,
        UNIQUE_CONJUGATIONS.EN,
        UNIQUE_CONJUGATIONS.INFINITIVE_ES,
        UNIQUE_CONJUGATIONS.NUMBER,
        UNIQUE_CONJUGATIONS.PERSON,
        UNIQUE_CONJUGATIONS.TENSE)
      .from(UNIQUE_CONJUGATIONS)
      .fetch()

    return rows.map {
      UniqueConjugation(
        it.getValue(UNIQUE_CONJUGATIONS.UNIQUE_CONJUGATION_ID),
        it.getValue(UNIQUE_CONJUGATIONS.ES),
        it.getValue(UNIQUE_CONJUGATIONS.EN),
        it.getValue(UNIQUE_CONJUGATIONS.INFINITIVE_ES),
        it.getValue(UNIQUE_CONJUGATIONS.NUMBER),
        it.getValue(UNIQUE_CONJUGATIONS.PERSON),
        it.getValue(UNIQUE_CONJUGATIONS.TENSE)
      )
    }
  }

  fun insertUniqueConjugation(uniqueConjugation: UniqueConjugation) =
    create
      .insertInto(UNIQUE_CONJUGATIONS,
          UNIQUE_CONJUGATIONS.ES,
          UNIQUE_CONJUGATIONS.EN,
          UNIQUE_CONJUGATIONS.INFINITIVE_ES,
          UNIQUE_CONJUGATIONS.NUMBER,
          UNIQUE_CONJUGATIONS.PERSON,
          UNIQUE_CONJUGATIONS.TENSE)
      .values(uniqueConjugation.es,
          uniqueConjugation.en,
          uniqueConjugation.infinitiveEs,
          uniqueConjugation.number,
          uniqueConjugation.person,
          uniqueConjugation.tense)
      .returning(
          UNIQUE_CONJUGATIONS.UNIQUE_CONJUGATION_ID,
          UNIQUE_CONJUGATIONS.ES,
          UNIQUE_CONJUGATIONS.EN,
          UNIQUE_CONJUGATIONS.INFINITIVE_ES,
          UNIQUE_CONJUGATIONS.NUMBER,
          UNIQUE_CONJUGATIONS.PERSON,
          UNIQUE_CONJUGATIONS.TENSE)
      .fetchOne()

  fun deleteUniqueConjugation(uniqueConjugation: UniqueConjugation) =
    create.delete(UNIQUE_CONJUGATIONS)
      .where(UNIQUE_CONJUGATIONS.UNIQUE_CONJUGATION_ID.eq(
        uniqueConjugation.uniqueConjugationId))
      .execute()

  fun selectAllStemChangeRows(): List<StemChangeRow> {
    val rows = create
      .select(
        STEM_CHANGES.STEM_CHANGE_ID,
        STEM_CHANGES.INFINITIVE_ES,
        STEM_CHANGES.STEM,
        STEM_CHANGES.TENSE)
      .from(STEM_CHANGES)
      .fetch()

    return rows.map {
      StemChangeRow(
        it.getValue(STEM_CHANGES.STEM_CHANGE_ID),
        it.getValue(STEM_CHANGES.INFINITIVE_ES),
        it.getValue(STEM_CHANGES.STEM),
        it.getValue(STEM_CHANGES.TENSE)
      )
    }
  }

  fun insertStemChangeRow(row: StemChangeRow) =
    create
      .insertInto(STEM_CHANGES,
          STEM_CHANGES.INFINITIVE_ES,
          STEM_CHANGES.STEM,
          STEM_CHANGES.TENSE)
      .values(row.infinitiveEs,
          row.stem,
          row.tense)
      .returning(
          STEM_CHANGES.STEM_CHANGE_ID,
          STEM_CHANGES.INFINITIVE_ES,
          STEM_CHANGES.STEM,
          STEM_CHANGES.TENSE)
      .fetchOne()

  fun deleteStemChangeRow(row: StemChangeRow) =
    create.delete(STEM_CHANGES)
      .where(STEM_CHANGES.STEM_CHANGE_ID.eq(
        row.stemChangeId))
      .execute()
}