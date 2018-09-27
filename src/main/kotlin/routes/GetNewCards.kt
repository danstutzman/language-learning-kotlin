package com.danstutzman.routes

import com.danstutzman.arabic.AtomAlignment
import com.danstutzman.db.Db
import com.danstutzman.db.Morpheme
import com.google.gson.Gson
import com.google.gson.GsonBuilder

data class ResponseJson(
  val cards: List<NewCardJson>,
  val morphemes: List<MorphemeJson>
)

data class NewCardJson(
  val id: Int,
  val enTask: String,
  val enContent: String,
  val morphemeIds: List<Int>
)

data class MorphemeJson(
  val id: Int,
  val l2: String,
  val gloss: String,
  val atoms: List<AtomAlignment>
)

fun GetNewCards(db: Db, lang: String, asJson: Boolean): String {
  val newCards = db.newCardsTable.selectByLang(lang)
  val morphemeIds = newCards.flatMap { newCard ->
    newCard.morphemeIdsCsv.split(",").map { it.toInt() }
  }
  val morphemes = db.morphemesTable.selectWithMorphemeIdIn(morphemeIds)
  val morphemeJsons = morphemes.map {
    val atomsList = Gson().fromJson(it.atomsJson, List::class.java)
    val atoms = atomsList.map {
      val map = it as Map<*, *>
      AtomAlignment(
        atom = map.get("atom") as String,
        buckwalter = map.get("buckwalter") as String,
        ipa = map.get("ipa") as String,
        endsSyllable = map.get("endsSyllable") as Boolean,
        endsMorpheme = map.get("endsMorpheme") as Boolean,
        beginsWithHyphen = map.get("beginsWithHyphen") as Boolean,
        endsWithHyphen = map.get("endsWithHyphen") as Boolean)
    }
    MorphemeJson(
      id = it.morphemeId,
      l2 = it.l2,
      gloss = it.gloss,
      atoms = atoms)
  }

  val morphemeById = morphemes.map { it.morphemeId to it }.toMap()
  if (asJson) {
    val newCards = newCards.map { newCard ->
      NewCardJson(
        id = newCard.newCardId,
        enTask = newCard.enTask,
        enContent = newCard.enContent,
        morphemeIds = newCard.morphemeIdsCsv.split(",").map { it.toInt() }
      )
    }
    val response = ResponseJson(cards = newCards, morphemes = morphemeJsons)
    return GsonBuilder().serializeNulls().create().toJson(response)
  } else {
    return com.danstutzman.templates.GetNewCards(lang, newCards, morphemeById)
  }
}
