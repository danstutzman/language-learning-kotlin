package com.danstutzman.bank.es

import com.danstutzman.db.Db

class InfList {
  val infs: List<Inf>
  val infByEsLower: Map<String, Inf>

  constructor(db: Db) {
    infs = db.selectAllInfinitives().map {
      Inf(
        it.leafId,
        it.esMixed,
        it.en,
        it.enPast,
        if (it.enDisambiguation == "") null else it.enDisambiguation)
    }
    infByEsLower = infs.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
  }
  fun byEsLower(esLower: String): Inf? = infByEsLower[esLower]
}