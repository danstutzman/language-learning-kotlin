package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.ArUniqueConjugation

fun PostArUniqueConjugations(db: Db, leafIdsToDelete: List<Int>,
  newUniqueConjugation: Boolean, rootArBuckwalter: String,
  arBuckwalter: String, en: String, gender: String,
  number: Int, person: Int, tense: String) {

  for (leafId in leafIdsToDelete) {
    db.arUniqueConjugationsTable.delete(leafId)
  }

  if (newUniqueConjugation) {
    var root = db.arVRootsTable.findByArBuckwalter(rootArBuckwalter)!!

    db.arUniqueConjugationsTable.insert(ArUniqueConjugation(
      0, arBuckwalter, en, root.leafId, gender, number, person, tense))
  }
}