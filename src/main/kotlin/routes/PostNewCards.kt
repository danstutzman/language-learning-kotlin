package com.danstutzman.routes

import com.danstutzman.NewMorpheme
import com.danstutzman.db.Db
import com.danstutzman.db.Morpheme
import com.danstutzman.db.NewCardRow

fun PostNewCards(db: Db, lang: String, newCardIdsToDelete: List<Int>, 
  enTask: String, enContent: String, newMorphemes: List<NewMorpheme>) {
  for (newCardId in newCardIdsToDelete) {
    db.newCardsTable.delete(newCardId)
  }

  if (newMorphemes.size > 0) {
    val morphemeIds = mutableListOf<Int>()
    for (newMorpheme in newMorphemes) {
      val toAdd = Morpheme(
        morphemeId = 0,
        lang = lang, 
        type = "",
        l2 = newMorpheme.l2,
        gloss = newMorpheme.gloss
      )
      val existing = db.morphemesTable.findExisting(toAdd)
      if (existing == null) {
        val withId = db.morphemesTable.insert(toAdd)
        morphemeIds.add(withId.morphemeId)
      } else {
        morphemeIds.add(existing.morphemeId)
      }
    }
    db.newCardsTable.insert(NewCardRow(0, lang, "PhraseCard", enTask, enContent,
      morphemeIds.joinToString(",")))
  }
}