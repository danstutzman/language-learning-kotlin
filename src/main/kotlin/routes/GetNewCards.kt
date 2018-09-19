package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Morpheme
import com.danstutzman.grammars.SplitArabicMorphemeIntoSyllables
import com.google.gson.GsonBuilder

data class ResponseJson(
  val cards: List<NewCardJson>
)

data class NewCardJson(
  val id: Int,
  val enTask: String,
  val enContent: String,
  val morphemes: List<MorphemeJson>
)

data class MorphemeJson(
  val id: Int,
  val l2: String,
  val gloss: String,
  val syllables: List<List<String>>
)

fun GetNewCards(db: Db, lang: String, asJson: Boolean): String {
  val newCards = db.newCardsTable.selectByLang(lang)
  val morphemeIds = newCards.flatMap { newCard ->
    newCard.morphemeIdsCsv.split(",").map { it.toInt() }
  }
  val morphemes = db.morphemesTable.selectWithMorphemeIdIn(morphemeIds)
  val morphemeById = morphemes.map { it.morphemeId to it }.toMap()
  if (asJson) {
    val newCards = newCards.map { newCard ->
      NewCardJson(
        id = newCard.newCardId,
        enTask = newCard.enTask,
        enContent = newCard.enContent,
        morphemes = newCard.morphemeIdsCsv.split(",").map { it.toInt() }.map {
          val morpheme = morphemeById[it]!!
          MorphemeJson(
            id = morpheme.morphemeId,
            l2 = morpheme.l2,
            gloss = morpheme.gloss,
            syllables = SplitArabicMorphemeIntoSyllables(morpheme.l2).map {
              listOf(it.c1, it.v, it.c2)
            }
          )
        }
      )
    }
    val response = ResponseJson(cards = newCards)
    return GsonBuilder().serializeNulls().create().toJson(response)
  } else {
    return com.danstutzman.templates.GetNewCards(lang, newCards, morphemeById)
  }
}
