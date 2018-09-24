package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.Morpheme

fun PostMorphemes(db: Db, lang: String, morphemeIdsToDelete: List<Int>,
  morphemesToSave: List<Pair<Int, String>>,
  newMorpheme: Boolean, type: String, l2: String, gloss: String) {
  for (morphemeId in morphemeIdsToDelete) {
    db.morphemesTable.delete(morphemeId)
  }

  for (pair in morphemesToSave) {
    db.morphemesTable.updateL2(pair.first, pair.second)
  }

  if (newMorpheme) {
    db.morphemesTable.insert(Morpheme(0, lang, type, l2, gloss))
  }
}
