package com.danstutzman.db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.DSLContext
import org.jooq.SQLDialect
import org.jooq.generated.tables.Cards.CARDS
import org.jooq.generated.tables.CardEmbeddings.CARD_EMBEDDINGS
import org.jooq.generated.tables.Goals.GOALS
import org.jooq.generated.tables.Leafs.LEAFS
import org.jooq.generated.tables.Paragraphs.PARAGRAPHS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Goal(
  val goalId: Int,
  val en: String,
  val es: String,
  val cardId: Int,
  val paragraphId: Int
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
  val tense: String,
  val enDisambiguation: String // "" if none
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

data class GoalCardId(
  val cardId: Int,
  val glossRowStart: Int,
  val glossRowEnd: Int
)

data class CardEmbedding(
  val longerCardId: Int,
  val shorterCardId: Int,
  val firstLeafIndex: Int,
  val lastLeafIndex: Int
)

data class Paragraph(
  val paragraphId: Int,
  val topic: String,
  val enabled: Boolean
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

  fun selectGoalById(goalId: Int): Goal? {
    val maybeRow = create
      .select(
        GOALS.GOAL_ID,
        GOALS.EN,
        GOALS.ES,
        GOALS.CARD_ID,
        GOALS.PARAGRAPH_ID)
      .from(GOALS)
      .where(GOALS.GOAL_ID.eq(goalId))
      .fetchOne()

    return maybeRow?.let {
      Goal(
        it.getValue(GOALS.GOAL_ID),
        it.getValue(GOALS.EN),
        it.getValue(GOALS.ES),
        it.getValue(GOALS.CARD_ID),
        it.getValue(GOALS.PARAGRAPH_ID)
      )
    }
  }

  fun selectAllGoals(): List<Goal> =
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

  fun selectGoalsWithParagraphIdIn(paragraphIds: List<Int>): List<Goal> =
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

  fun updateGoal(goal: Goal) =
    create.update(GOALS)
      .set(GOALS.EN, goal.en)
      .set(GOALS.ES, goal.es)
      .set(GOALS.UPDATED_AT, now())
      .where(GOALS.GOAL_ID.eq(goal.goalId))
      .execute()

  fun deleteGoal(goalId: Int) =
    create.delete(GOALS)
      .where(GOALS.GOAL_ID.eq(goalId))
      .execute()

  fun insertCardRows(cardRows: List<CardRow>) {
    if (cardRows.size == 0) { return }
    var statement = create.insertInto(
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

  fun selectAllCardRows(): List<CardRow> =
    create.select(
        CARDS.CARD_ID,
        CARDS.GLOSS_ROWS_JSON,
        CARDS.LAST_SEEN_AT,
        CARDS.LEAF_IDS_CSV,
        CARDS.MNEMONIC,
        CARDS.PROMPT,
        CARDS.STAGE)
      .from(CARDS)
      .fetch()
      .map { CardRow(
        it.getValue(CARDS.CARD_ID),
        it.getValue(CARDS.GLOSS_ROWS_JSON),
        it.getValue(CARDS.LAST_SEEN_AT)?.let { it.getTime() / 1000 }?.toInt(),
        it.getValue(CARDS.LEAF_IDS_CSV),
        it.getValue(CARDS.MNEMONIC),
        it.getValue(CARDS.PROMPT),
        it.getValue(CARDS.STAGE)
      )}

  fun selectCardRowsWithCardIdIn(cardIds: List<Int>): List<CardRow> =
    create.select(
      CARDS.CARD_ID,
      CARDS.GLOSS_ROWS_JSON,
      CARDS.LAST_SEEN_AT,
      CARDS.LEAF_IDS_CSV,
      CARDS.MNEMONIC,
      CARDS.PROMPT,
      CARDS.STAGE)
    .from(CARDS)
    .where(CARDS.CARD_ID.`in`(cardIds))
    .fetch()
    .map { CardRow(
      it.getValue(CARDS.CARD_ID),
      it.getValue(CARDS.GLOSS_ROWS_JSON),
      it.getValue(CARDS.LAST_SEEN_AT)?.let { it.getTime() / 1000 }?.toInt(),
      it.getValue(CARDS.LEAF_IDS_CSV),
      it.getValue(CARDS.MNEMONIC),
      it.getValue(CARDS.PROMPT),
      it.getValue(CARDS.STAGE)
    )}

  fun selectLeafIdsCsvCardIdPairs(): List<Pair<String, Int>> =
    create.select(CARDS.LEAF_IDS_CSV, CARDS.CARD_ID)
      .from(CARDS)
      .fetch()
      .map { Pair(it.getValue(CARDS.LEAF_IDS_CSV), it.getValue(CARDS.CARD_ID)) }

  fun updateCard(cardUpdate: CardUpdate) =
    create.update(CARDS)
      .set(CARDS.LAST_SEEN_AT,
        cardUpdate.lastSeenAt?.let { Timestamp(it.toLong() * 1000) })
      .set(CARDS.MNEMONIC, cardUpdate.mnemonic)
      .set(CARDS.STAGE, cardUpdate.stage)
      .set(CARDS.UPDATED_AT, now())
      .where(CARDS.CARD_ID.eq(cardUpdate.cardId))
      .execute()

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

  fun insertNonverbRow(nonverb: NonverbRow) =
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
        LEAFS.INFINITIVE_ES_MIXED,
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
        it.getValue(LEAFS.INFINITIVE_ES_MIXED),
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
        LEAFS.INFINITIVE_ES_MIXED,
        LEAFS.NUMBER,
        LEAFS.PERSON,
        LEAFS.TENSE,
        LEAFS.EN_DISAMBIGUATION)
    .values("UniqV",
        uniqueConjugation.esMixed,
        uniqueConjugation.en,
        uniqueConjugation.infinitiveEsMixed,
        uniqueConjugation.number,
        uniqueConjugation.person,
        uniqueConjugation.tense,
        uniqueConjugation.enDisambiguation)
    .execute()

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

  fun selectCardEmbeddingsWithLongerCardIdIn(longerCardIds: List<Int>) :
    List<CardEmbedding> {
    val rows = create
      .select(
        CARD_EMBEDDINGS.LONGER_CARD_ID,
        CARD_EMBEDDINGS.SHORTER_CARD_ID,
        CARD_EMBEDDINGS.FIRST_LEAF_INDEX,
        CARD_EMBEDDINGS.LAST_LEAF_INDEX)
      .from(CARD_EMBEDDINGS)
      .where(CARD_EMBEDDINGS.LONGER_CARD_ID.`in`(longerCardIds))
      .fetch()

    return rows.map {
      CardEmbedding(
        it.getValue(CARD_EMBEDDINGS.LONGER_CARD_ID),
        it.getValue(CARD_EMBEDDINGS.SHORTER_CARD_ID),
        it.getValue(CARD_EMBEDDINGS.FIRST_LEAF_INDEX),
        it.getValue(CARD_EMBEDDINGS.LAST_LEAF_INDEX)
      )
    }
  }

  fun insertCardEmbeddings(cardEmbeddings: List<CardEmbedding>) {
    if (cardEmbeddings.size == 0) { return }
    var statement = create.insertInto(CARD_EMBEDDINGS,
      CARD_EMBEDDINGS.LONGER_CARD_ID,
      CARD_EMBEDDINGS.SHORTER_CARD_ID,
      CARD_EMBEDDINGS.FIRST_LEAF_INDEX,
      CARD_EMBEDDINGS.LAST_LEAF_INDEX)
    for (cardEmbedding in cardEmbeddings) {
      statement = statement.values(cardEmbedding.longerCardId,
        cardEmbedding.shorterCardId,
        cardEmbedding.firstLeafIndex,
        cardEmbedding.lastLeafIndex)
    }
    statement.onDuplicateKeyIgnore().execute()
  }

  fun selectAllParagraphs() : List<Paragraph> =
    create
      .select(
        PARAGRAPHS.PARAGRAPH_ID,
        PARAGRAPHS.TOPIC,
        PARAGRAPHS.ENABLED)
      .from(PARAGRAPHS)
      .fetch()
      .map {
        Paragraph(
          it.getValue(PARAGRAPHS.PARAGRAPH_ID),
          it.getValue(PARAGRAPHS.TOPIC),
          it.getValue(PARAGRAPHS.ENABLED))
      }

  fun selectParagraphById(paragraphId: Int) : Paragraph? =
    create
      .select(
        PARAGRAPHS.PARAGRAPH_ID,
        PARAGRAPHS.TOPIC,
        PARAGRAPHS.ENABLED)
      .from(PARAGRAPHS)
      .where(PARAGRAPHS.PARAGRAPH_ID.eq(paragraphId))
      .fetchOne()
      ?.let {
        Paragraph(
          it.getValue(PARAGRAPHS.PARAGRAPH_ID),
          it.getValue(PARAGRAPHS.TOPIC),
          it.getValue(PARAGRAPHS.ENABLED))
      }

  fun insertParagraph(paragraph: Paragraph): Paragraph =
    create.insertInto(PARAGRAPHS, PARAGRAPHS.TOPIC, PARAGRAPHS.UPDATED_AT)
      .values(paragraph.topic, now())
      .returning(
        PARAGRAPHS.PARAGRAPH_ID,
        PARAGRAPHS.TOPIC,
        PARAGRAPHS.ENABLED)
      .fetchOne().let {
        Paragraph(
          it.getValue(PARAGRAPHS.PARAGRAPH_ID),
          it.getValue(PARAGRAPHS.TOPIC),
          it.getValue(PARAGRAPHS.ENABLED)
        )
      }

  fun updateParagraph(paragraph: Paragraph) =
    create.update(PARAGRAPHS)
      .set(PARAGRAPHS.TOPIC, paragraph.topic)
      .set(PARAGRAPHS.ENABLED, paragraph.enabled)
      .set(GOALS.UPDATED_AT, now())
      .where(PARAGRAPHS.PARAGRAPH_ID.eq(paragraph.paragraphId))
      .execute()

  fun deleteParagraph(paragraphId: Int) =
    create.delete(PARAGRAPHS)
      .where(PARAGRAPHS.PARAGRAPH_ID.eq(paragraphId))
      .execute()
}