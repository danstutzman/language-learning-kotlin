package com.danstutzman.bank.es

import com.danstutzman.bank.IdSequence
import com.danstutzman.db.Db

class InfList {
  val infs: List<Inf>
  val infByEs: Map<String, Inf>

  constructor(cardIdSequence: IdSequence, db: Db) {
    infs = db.selectAllInfinitives().map { infinitive ->
      Inf(
        cardIdSequence.nextId(),
        infinitive.es,
        infinitive.en,
        infinitive.enPast,
        if (infinitive.enDisambiguation == "") null
          else infinitive.enDisambiguation)
    }
    infByEs = infs.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Inf? = infByEs[es]
}
