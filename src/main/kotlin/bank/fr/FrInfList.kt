package com.danstutzman.bank.fr

import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

class FrInfList {
  val infs: List<FrInf>
  val infByFrLower: Map<String, FrInf>
  val infByLeafId: Map<Int, FrInf>

  constructor(db: Db) {
    infs = db.frInfinitivesTable.selectAll().map {
      FrInf(
        leafId    = it.leafId,
        frMixed   = it.frMixed,
        enPresent = it.en,
        enPast    = it.enPast)
    }
    infByFrLower = infs.map { Pair(it.frMixed.toLowerCase(), it) }.toMap()
    infByLeafId = infs.map { it.leafId to it }.toMap()
  }

  fun byFrLower(frLower: String): FrInf? = infByFrLower[frLower]

  fun byLeafId(leafId: Int): FrInf = infByLeafId[leafId]!!

  fun interpretFrLower(frLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (infByFrLower[frLower] != null) {
      interpretations.add(Interpretation("FrInf", infByFrLower[frLower]))
    }
    interpretations.add(Interpretation("FrInf", null))
    return interpretations
  }
}