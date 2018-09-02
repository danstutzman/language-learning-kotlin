package com.danstutzman.bank.fr

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class FrUniqVList {
  val uniqVs: List<FrUniqV>
  val uniqVByFrLower: Map<String, FrUniqV>

  constructor(infList: FrInfList, db: Db) {
    uniqVs = db.frUniqueConjugationsTable.selectAll().map {
      FrUniqV(
        leafId = it.leafId,
        frMixed = it.frMixed,
        en = it.en,
        inf = infList.byLeafId(it.infLeafId),
        number = it.number,
        person = it.person,
        tense = FrTense.valueOf(it.tense))
    }

    uniqVByFrLower = uniqVs.map { Pair(it.frMixed.toLowerCase(), it) }.toMap()
  }

  fun byInfNumberPersonTense(
    inf: FrInf, number: Int, person: Int, tense: FrTense): FrUniqV? {
    for (uniqV in uniqVs) {
      if (uniqV.inf.frMixed == inf.frMixed &&
        uniqV.number == number &&
        uniqV.person == person &&
        uniqV.tense == tense) {
        return uniqV
      }
    }
    return null
  }

  fun interpretFrLower(frLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (uniqVByFrLower[frLower] !== null) {
      interpretations.add(Interpretation("FrUniqV", uniqVByFrLower[frLower]))
    }
    interpretations.add(Interpretation("FrUniqV", null))
    return interpretations
  }
}
