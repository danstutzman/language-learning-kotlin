package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class UniqVList {
  val uniqVs: List<UniqV>
  val uniqVByEsLower: Map<String, UniqV>

  constructor(infList: InfList, db: Db) {
    uniqVs = db.leafsTable.selectAllUniqueConjugations().map {
      UniqV(
        leafId = it.leafId,
        esMixed = it.esMixed,
        en = it.en,
        inf = infList.byLeafId(it.infLeafId),
        number = it.number,
        person = it.person,
        tense = Tense.valueOf(it.tense),
        enDisambiguation =
          if (it.enDisambiguation == "") null else it.enDisambiguation
      )
    }

    uniqVByEsLower = uniqVs.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
  }

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

  fun interpretEsLower(esLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (uniqVByEsLower[esLower] !== null) {
      interpretations.add(Interpretation("UniqV", uniqVByEsLower[esLower]))
    }
    interpretations.add(Interpretation("UniqV", null))
    return interpretations
  }
}
