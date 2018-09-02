package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.FrUniqueConjugation

fun PostFrUniqueConjugations(db: Db, leafIdsToDelete: List<Int>,
  newUniqueConjugation: Boolean, infinitiveFrMixed: String,
  frMixed: String, en: String, number: Int, person: Int, tense: String) {

  for (leafId in leafIdsToDelete) {
    db.frUniqueConjugationsTable.delete(leafId)
  }

  if (newUniqueConjugation) {
    var infinitive = db.frInfinitivesTable.findByFrMixed(infinitiveFrMixed)!!

    db.frUniqueConjugationsTable.insert(FrUniqueConjugation(
      0, frMixed, en, infinitive.leafId, number, person, tense))
  }
}