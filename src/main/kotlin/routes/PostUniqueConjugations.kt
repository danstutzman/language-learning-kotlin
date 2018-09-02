package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.UniqueConjugation

fun PostUniqueConjugations(db: Db, leafIdsToDelete: List<Int>,
  newUniqueConjugation: Boolean, infinitiveEsMixed: String,
  esMixed: String, en: String, number: Int, person: Int, tense: String,
  enDisambiguation: String) {

  for (leafId in leafIdsToDelete) {
    db.leafsTable.deleteLeaf(leafId)
  }

  if (newUniqueConjugation) {
    var infinitive = db.leafsTable.findInfinitiveByEsMixed(infinitiveEsMixed)!!
    db.leafsTable.insertUniqueConjugation(UniqueConjugation(
      0, esMixed, en, infinitive.leafId, number, person, tense,
      enDisambiguation))
  }
}