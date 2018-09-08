package com.danstutzman.bank.ar

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class ArUniqVList {
  val uniqVs: List<ArUniqV>
  val uniqVByArBuckwalter: Map<String, ArUniqV>

  constructor(rootList: ArVRootList, db: Db) {
    uniqVs = db.arUniqueConjugationsTable.selectAll().map {
      ArUniqV(
        leafId = it.leafId,
        arBuckwalter = it.arBuckwalter,
        en = it.en,
        root = rootList.byLeafId(it.rootLeafId),
        gender = if (it.gender != "") ArGender.valueOf(it.gender) else null,
        number = it.number,
        person = it.person,
        tense = ArTense.valueOf(it.tense))
    }

    uniqVByArBuckwalter = uniqVs.map { Pair(it.arBuckwalter, it) }.toMap()
  }

  fun interpretArBuckwalter(arBuckwalter: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (uniqVByArBuckwalter[arBuckwalter] !== null) {
      interpretations.add(
        Interpretation("ArUniqV", uniqVByArBuckwalter[arBuckwalter]))
    }
    interpretations.add(Interpretation("ArUniqV", null))
    return interpretations
  }
}
