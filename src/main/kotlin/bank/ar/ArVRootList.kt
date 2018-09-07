package com.danstutzman.bank.ar

import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class ArVRootList {
  val vRoots: List<ArVRoot>
  val vRootByArBuckwalter: Map<String, ArVRoot>
  val vRootByLeafId: Map<Int, ArVRoot>

  constructor(db: Db) {
    vRoots = db.arVRootsTable.selectAll().map {
      ArVRoot(
        leafId                      = it.leafId,
        arBuckwalter                = it.arBuckwalter,
        enPresent                   = it.en,
        enPast                      = it.enPast,
        arPresMiddleVowelBuckwalter = it.arPresMiddleVowelBuckwalter)
    }
    vRootByArBuckwalter = vRoots.map { Pair(it.arBuckwalter, it) }.toMap()
    vRootByLeafId = vRoots.map { it.leafId to it }.toMap()
  }

  fun byArBuckwalter(arBuckwalter: String): ArVRoot? =
    vRootByArBuckwalter[arBuckwalter]

  fun byLeafId(leafId: Int): ArVRoot = vRootByLeafId[leafId]!!

  fun interpretArBuckwalter(arBuckwalter: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (vRootByArBuckwalter[arBuckwalter] != null) {
      interpretations.add(
        Interpretation("ArVRoot", vRootByArBuckwalter[arBuckwalter]))
    }
    return interpretations
  }
}