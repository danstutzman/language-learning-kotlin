package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.IdSequence
import com.danstutzman.db.Db

class UniqVList {
  val uniqVs: List<UniqV>
  val uniqVByEs: Map<String, UniqV>

  constructor(cardIdSequence: IdSequence, infList: InfList, db: Db) {
    uniqVs = db.selectAllUniqueConjugations().map {
      UniqV(
        cardId = cardIdSequence.nextId(),
        es = it.es,
        en = it.en,
        inf = infList.byEs(it.infinitiveEs) ?:
          throw CantMakeCard("Can't find infinitive for es=${it.infinitiveEs}"),
        number = it.number,
        person = it.person,
        tense = Tense.valueOf(it.tense)
      )
    }

    uniqVByEs = uniqVs.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): UniqV? = uniqVByEs[es]
}
