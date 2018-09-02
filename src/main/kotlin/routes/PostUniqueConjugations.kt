package com.danstutzman.routes

import com.danstutzman.db.Db
import com.danstutzman.db.EsUniqueConjugation

fun PostEsUniqueConjugations(db: Db, leafIdsToDelete: List<Int>,
  newUniqueConjugation: Boolean, infinitiveEsMixed: String,
  esMixed: String, en: String, number: Int, person: Int, tense: String,
  enDisambiguation: String) {

  for (leafId in leafIdsToDelete) {
    db.esUniqueConjugationsTable.delete(leafId)
  }

  if (newUniqueConjugation) {
    var infinitive = db.esInfinitivesTable.findByEsMixed(infinitiveEsMixed)!!

    db.esUniqueConjugationsTable.insert(EsUniqueConjugation(
      0, esMixed, en, infinitive.leafId, number, person, tense,
      enDisambiguation))
  }
}