package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.SQLDialect
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.generated.tables.Entries.ENTRIES
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
}
