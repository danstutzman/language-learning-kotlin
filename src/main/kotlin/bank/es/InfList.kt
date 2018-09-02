package com.danstutzman.bank.es

import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class InfList {
  val infs: List<Inf>
  val infByEsLower: Map<String, Inf>
  val infByLeafId: Map<Int, Inf>

  constructor(db: Db) {
    infs = db.esInfinitivesTable.selectAll().map {
      Inf(
        it.leafId,
        it.esMixed,
        it.en,
        it.enPast,
        if (it.enDisambiguation == "") null else it.enDisambiguation)
    }
    infByEsLower = infs.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
    infByLeafId = infs.map { it.leafId to it }.toMap()
  }

  fun byEsLower(esLower: String): Inf? = infByEsLower[esLower]

  fun byLeafId(leafId: Int): Inf = infByLeafId[leafId]!!

  fun interpretEsLower(esLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (infByEsLower[esLower] != null) {
      interpretations.add(Interpretation("EsInf", infByEsLower[esLower]))
    }
    interpretations.add(Interpretation("EsInf", null))
    return interpretations
  }
}