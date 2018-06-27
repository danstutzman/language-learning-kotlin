package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.DSLContext
import org.jooq.SQLDialect
import org.jooq.generated.tables.Cards.CARDS
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Goal(
  val goalId: Int,
  val tagsCsv: String,
  val en: String,
  val es: String,
  val leafIdsCsv: String
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

data class CardUpdate(
  val cardId: Int,
  val lastSeenAt: Int?,
  val mnemonic: String,
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
  val esMixed: String,
  val tense: String,
  val en: String,
  val enPast: String,
  val enDisambiguation: String // "" if none
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

  private fun insertGoal(txn: DSLContext, goal: Goal) =
    txn.insertInto(GOALS,
          GOALS.TAGS_CSV,
          GOALS.EN,
          GOALS.ES,
          GOALS.LEAF_IDS_CSV,
          GOALS.UPDATED_AT)
      .values(goal.tagsCsv,
          goal.en,
          goal.es,
          goal.leafIdsCsv,
          now())
      .returning(
          GOALS.GOAL_ID,
          GOALS.TAGS_CSV,
          GOALS.EN,
          GOALS.ES,
          GOALS.LEAF_IDS_CSV)
      .fetchOne()

  fun selectGoalById(goalId: Int): Goal? {
    val maybeRow = create
      .select(
        GOALS.GOAL_ID,
        GOALS.TAGS_CSV,
        GOALS.EN,
        GOALS.ES,
        GOALS.LEAF_IDS_CSV)
      .from(GOALS)
      .where(GOALS.GOAL_ID.eq(goalId))
      .fetchOne()

    return maybeRow?.let {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.TAGS_CSV),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES),
        it.getValue(GOALS.LEAF_IDS_CSV)
      )
    }
  }

  fun selectAllGoals(): List<Goal> {
    val rows = create
      .select(
        GOALS.GOAL_ID,
        GOALS.TAGS_CSV,
        GOALS.EN,
        GOALS.ES,
        GOALS.LEAF_IDS_CSV)
      .from(GOALS)
      .fetch()

    return rows.map {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.TAGS_CSV),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES),
        it.getValue(GOALS.LEAF_IDS_CSV)
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

  fun deleteGoal(goalId: Int) {
    create.delete(GOALS)
      .where(GOALS.GOAL_ID.eq(goalId))
      .execute()
  }

  private fun insertCardRows(txn: DSLContext, cardRows: List<CardRow>) {
    if (cardRows.size == 0) { return }
    var statement = txn.insertInto(
      CARDS,
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
        row.lastSeenAt?.let { Timestamp(it.toLong() * 1000) },
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

  fun updateCard(cardUpdate: CardUpdate) {
    create.update(CARDS)
      .set(CARDS.LAST_SEEN_AT,
        cardUpdate.lastSeenAt?.let { Timestamp(it.toLong() * 1000) })
      .set(CARDS.MNEMONIC, cardUpdate.mnemonic)
      .set(CARDS.STAGE, cardUpdate.stage)
      .set(CARDS.UPDATED_AT, now())
      .where(CARDS.CARD_ID.eq(cardUpdate.cardId))
      .execute()
  }

  fun selectAllNonverbRows(): List<NonverbRow> {
    val rows = create
      .select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PLURAL,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("Nonverb"))
      .fetch()

    return rows.map {
      NonverbRow(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PLURAL),
        it.getValue(LEAFS.ES_MIXED)
      )
    }
  }

  fun insertNonverbRow(nonverb: NonverbRow) {
    create
      .insertInto(LEAFS,
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
  }

  fun deleteLeaf(leafId: Int) =
    create.delete(LEAFS)
      .where(LEAFS.LEAF_ID.eq(leafId))
      .execute()

  fun selectAllInfinitives(): List<Infinitive> {
    val rows = create
      .select(
        LEAFS.LEAF_ID,
        LEAFS.EN,
        LEAFS.EN_DISAMBIGUATION,
        LEAFS.EN_PAST,
        LEAFS.ES_MIXED)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("Inf"))
      .fetch()

    return rows.map {
      Infinitive(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_DISAMBIGUATION),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.ES_MIXED)
      )
    }
  }

  fun insertInfinitive(infinitive: Infinitive) {
    create
      .insertInto(LEAFS,
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
  }

  fun selectAllUniqueConjugations(): List<UniqueConjugation> {
    val rows = create
      .select(
        LEAFS.LEAF_ID,
        LEAFS.ES_MIXED,
        LEAFS.EN,
        LEAFS.INFINITIVE_ES_MIXED,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE)
      .from(LEAFS)
      .where(LEAFS.LEAF_TYPE.eq("UniqV"))
      .fetch()

    return rows.map {
      UniqueConjugation(
        it.getValue(LEAFS.LEAF_ID),
        it.getValue(LEAFS.ES_MIXED),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.INFINITIVE_ES_MIXED),
        it.getValue(LEAFS.NUMBER),
        it.getValue(LEAFS.PERSON),
        it.getValue(LEAFS.TENSE)
      )
    }
  }

  fun insertUniqueConjugation(uniqueConjugation: UniqueConjugation) {
    create
      .insertInto(LEAFS,
          LEAFS.LEAF_TYPE,
          LEAFS.ES_MIXED,
          LEAFS.EN,
          LEAFS.INFINITIVE_ES_MIXED,
          LEAFS.NUMBER,
          LEAFS.PERSON,
          LEAFS.TENSE)
      .values("UniqV",
          uniqueConjugation.esMixed,
          uniqueConjugation.en,
          uniqueConjugation.infinitiveEsMixed,
          uniqueConjugation.number,
          uniqueConjugation.person,
          uniqueConjugation.tense)
      .returning(
          LEAFS.LEAF_ID,
          LEAFS.ES_MIXED,
          LEAFS.EN,
          LEAFS.INFINITIVE_ES_MIXED,
          LEAFS.NUMBER,
          LEAFS.PERSON,
          LEAFS.TENSE)
      .fetchOne()
  }

  fun selectAllStemChangeRows(): List<StemChangeRow> {
    val rows = create
      .select(
        LEAFS.LEAF_ID,
        LEAFS.INFINITIVE_ES_MIXED,
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
        it.getValue(LEAFS.INFINITIVE_ES_MIXED),
        it.getValue(LEAFS.ES_MIXED),
        it.getValue(LEAFS.TENSE),
        it.getValue(LEAFS.EN),
        it.getValue(LEAFS.EN_PAST),
        it.getValue(LEAFS.EN_DISAMBIGUATION)
      )
    }
  }

  fun insertStemChangeRow(row: StemChangeRow) {
    create
      .insertInto(LEAFS,
          LEAFS.LEAF_TYPE,
          LEAFS.INFINITIVE_ES_MIXED,
          LEAFS.ES_MIXED,
          LEAFS.TENSE)
      .values("StemChange",
          row.infinitiveEsMixed,
          row.esMixed,
          row.tense)
      .returning(
          LEAFS.LEAF_ID,
          LEAFS.INFINITIVE_ES_MIXED,
          LEAFS.ES_MIXED,
          LEAFS.TENSE)
      .fetchOne()
  }

  fun insertGoalAndCardRows(goal: Goal, cardRows: List<CardRow>) {
    create.transaction { config ->
      val txn = DSL.using(config)
      insertGoal(txn, goal)
      insertCardRows(txn, cardRows)
    }
  }
}