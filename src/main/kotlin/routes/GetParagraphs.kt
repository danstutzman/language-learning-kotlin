package com.danstutzman.routes

import com.danstutzman.db.CardEmbedding
import com.danstutzman.db.Db
import com.danstutzman.db.Goal

fun GetParagraphs(db: Db, lang: String): String {
  val paragraphs = db.paragraphsTable.selectForLang(lang)
  val allGoals = db.goalsTable.selectWithParagraphIdIn(
    paragraphs.map { it.paragraphId })
  val goalsByParagraphId = paragraphs.map {
    Pair(it.paragraphId, mutableListOf<Goal>())
  }.toMap()
  for (goal in allGoals) {
    goalsByParagraphId[goal.paragraphId]?.add(goal) ?:
      throw RuntimeException(
        "Can't find paragraphId ${goal.paragraphId} from goal ${goal}")
  }

  val goalCardIds = allGoals.map { it.cardId }
  val cardEmbeddingsByCardId = allGoals.map {
    Pair(it.cardId, mutableListOf<CardEmbedding>())
  }.toMap().toMutableMap()
  val subCardIds = mutableListOf<Int>()
  for (cardEmbedding in
    db.cardEmbeddingsTable.selectWithLongerCardIdIn(goalCardIds)) {
    cardEmbeddingsByCardId[cardEmbedding.longerCardId]!!.add(cardEmbedding)
    subCardIds.add(cardEmbedding.shorterCardId)
  }
  val allCardIds = (goalCardIds + subCardIds).distinct()
  val cardByCardId = db.cardsTable.selectWithCardIdIn(allCardIds)
    .map { Pair(it.cardId, it) }.toMap()

  return com.danstutzman.templates.GetParagraphs(lang, paragraphs,
    goalsByParagraphId, cardByCardId, cardEmbeddingsByCardId)
}