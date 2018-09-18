package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Morpheme
import com.google.gson.GsonBuilder

data class NewCardJson(
  val id: Int,
  val enTask: String,
  val enContent: String,
  val morphemeIdsCsv: String,
  val morphemes: List<MorphemeJson>
)

data class MorphemeJson(
  val id: Int,
  val l2: String,
  val gloss: String
)

fun GetNewCards(db: Db, lang: String, asJson: Boolean): String {
  val newCards = db.newCardsTable.selectByLang(lang)
  val morphemeIds = newCards.flatMap { newCard ->
    newCard.morphemeIdsCsv.split(",").map { it.toInt() }
  }
  val morphemes = db.morphemesTable.selectWithMorphemeIdIn(morphemeIds)
  val morphemeById = morphemes.map { it.morphemeId to it }.toMap()
  if (asJson) {
    val newCardsWithMorphemes = newCards.map { newCard ->
      NewCardJson(
        id = newCard.newCardId,
        enTask = newCard.enTask,
        enContent = newCard.enContent,
        morphemeIdsCsv = newCard.morphemeIdsCsv,
        morphemes = newCard.morphemeIdsCsv.split(",").map { it.toInt() }.map {
          val morpheme = morphemeById[it]!!
          MorphemeJson(morpheme.morphemeId, morpheme.l2, morpheme.gloss)
        }
      )
    }
    return GsonBuilder().serializeNulls().create().toJson(newCardsWithMorphemes)
  } else {
    return com.danstutzman.templates.GetNewCards(lang, newCards, morphemeById)
  }
}