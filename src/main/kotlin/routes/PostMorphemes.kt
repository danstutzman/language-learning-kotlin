package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Morpheme

fun PostMorphemes(db: Db, lang: String, morphemeIdsToDelete: List<Int>,
  newMorpheme: Boolean, type: String, l2: String, gloss: String) {
  for (morphemeId in morphemeIdsToDelete) {
    db.morphemesTable.delete(morphemeId)
  }

  if (newMorpheme) {
    db.morphemesTable.insert(Morpheme(0, lang, type, l2, gloss))
  }
}