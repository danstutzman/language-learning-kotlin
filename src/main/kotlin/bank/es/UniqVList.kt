package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.db.Db

class UniqVList {
  val uniqVs: List<UniqV>
  val uniqVByEsLower: Map<String, UniqV>

  constructor(infList: InfList, db: Db) {
    uniqVs = db.selectAllUniqueConjugations().map {
      UniqV(
        leafId = it.leafId,
        esMixed = it.esMixed,
        en = it.en,
        inf = infList.byEsLower(it.infinitiveEsMixed.toLowerCase()) ?:
          throw CantMakeCard(
            "Can't find infinitive for es=${it.infinitiveEsMixed}"),
        number = it.number,
        person = it.person,
        tense = Tense.valueOf(it.tense)
      )
    }

    uniqVByEsLower = uniqVs.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
  }
  fun byEsLower(esLower: String): UniqV? = uniqVByEsLower[esLower]
  fun byInfNumberPersonTense(inf: Inf, number: Int, person: Int, tense: Tense):
    UniqV? {
    for (uniqV in uniqVs) {
      if (uniqV.inf.esMixed == inf.esMixed &&
        uniqV.number == number &&
        uniqV.person == person &&
        uniqV.tense == tense) {
        return uniqV
      }
    }
    return null
  }
}
