package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.SQLDialect
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Goal(
  val goalId: Int,
  val tags: String,
  val enFreeText: String,
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
}
