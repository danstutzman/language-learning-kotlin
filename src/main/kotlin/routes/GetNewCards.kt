package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetNewCards(db: Db, lang: String): String {
  val newCards = db.newCardsTable.selectByLang(lang)
  val morphemeIds = newCards.flatMap { newCard ->
    newCard.morphemeIdsCsv.split(",").map { it.toInt() }
  }
  val morphemes = db.morphemesTable.selectWithMorphemeIdIn(morphemeIds)
  val morphemeById = morphemes.map { it.morphemeId to it }.toMap()
  return com.danstutzman.templates.GetNewCards(lang, newCards, morphemeById)
}