package com.danstutzman.bank.es

import com.danstutzman.db.Db

class InfList {
  val infs: List<Inf>
  val infByEs: Map<String, Inf>

  constructor(db: Db) {
    infs = db.selectAllInfinitives().map {
      Inf(
        it.leafId,
        it.es,
        it.en,
        it.enPast,
        if (it.enDisambiguation == "") null else it.enDisambiguation)
    }
    infByEs = infs.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Inf? = infByEs[es]
}