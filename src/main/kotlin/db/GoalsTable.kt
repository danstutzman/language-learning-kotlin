package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.impl.DSL

data class Goal(
  val goalId: Int,
  val en: String,
  val es: String,
  val cardId: Int,
  val paragraphId: Int
)

class GoalsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun insert(goal: Goal) =
    create.insertInto(GOALS,
      GOALS.EN,
      GOALS.ES,
      GOALS.CARD_ID,
      GOALS.PARAGRAPH_ID,
      GOALS.UPDATED_AT)
    .values(goal.en,
      goal.es,
      goal.cardId,
      goal.paragraphId,
      now())
    .returning(
      GOALS.GOAL_ID,
      GOALS.EN,
      GOALS.ES,
      GOALS.PARAGRAPH_ID,
      GOALS.CARD_ID)
    .fetchOne()

  fun selectAll(): List<Goal> =
    create
      .select(
        GOALS.GOAL_ID,
        GOALS.EN,
        GOALS.ES,
        GOALS.CARD_ID,
        GOALS.PARAGRAPH_ID)
      .from(GOALS)
      .fetch()
      .map { Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES),
        it.getValue(GOALS.CARD_ID),
        it.getValue(GOALS.PARAGRAPH_ID)
      )}

  fun selectWithParagraphIdIn(paragraphIds: List<Int>): List<Goal> =
    create
      .select(
        GOALS.GOAL_ID,
        GOALS.EN,
        GOALS.ES,
        GOALS.CARD_ID,
        GOALS.PARAGRAPH_ID)
      .from(GOALS)
      .where(GOALS.PARAGRAPH_ID.`in`(paragraphIds))
      .fetch()
      .map { Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES),
        it.getValue(GOALS.CARD_ID),
        it.getValue(GOALS.PARAGRAPH_ID)
      )}
}