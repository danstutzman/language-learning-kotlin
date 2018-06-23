package com.danstutzman.bank.es

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.IdSequence

private data class D2(
  val tense: Tense,
  val infEs: String,
  val stem: String
) {}

private val stemChangesWithoutIds = listOf(
  D2(Tense.PRES, "poder",     "pued-"),
  D2(Tense.PRES, "tener",     "tien-"),
  D2(Tense.PRES, "querer",    "quier-"),
  D2(Tense.PRES, "seguir",    "sig-"),
  D2(Tense.PRES, "encontrar", "encuentr-"),
  D2(Tense.PRES, "venir",     "vien-"),
  D2(Tense.PRES, "pensar",    "piens-"),
  D2(Tense.PRES, "volver",    "vuelv-"),
  D2(Tense.PRES, "sentir",    "sient-"),
  D2(Tense.PRES, "contar",    "cuent-"),
  D2(Tense.PRES, "empezar",   "empiez-"),
  D2(Tense.PRES, "decir",     "dic-"),
  D2(Tense.PRES, "recordar",  "recuerd-"),
  D2(Tense.PRES, "pedir",     "pid-"),
  D2(Tense.PRES, "entender",  "entiend-"),
  D2(Tense.PRET, "andar",     "anduv-"),
  D2(Tense.PRET, "saber",     "sup-"),
  D2(Tense.PRET, "querer",    "quis-"),
  D2(Tense.PRET, "poner",     "pus-"),
  D2(Tense.PRET, "venir",     "vin-"),
  D2(Tense.PRET, "decir",     "dij-"),
  D2(Tense.PRET, "tener",     "tuv-"),
  D2(Tense.PRET, "hacer",     "hic-"),
  D2(Tense.PRET, "poder",     "pud-")
)

class StemChangeList {
  val stemChanges: List<StemChange>
  val stemChangeByKey: Map<String, StemChange>

  constructor(cardIdSequence: IdSequence, infList: InfList) {
    stemChanges = stemChangesWithoutIds.map {
      StemChange(
        cardIdSequence.nextId(),
        it.tense,
        infList.byEs(it.infEs) ?:
          throw RuntimeException("No inf for ${it.infEs}"),
        it.stem
      )
    }
    stemChangeByKey = stemChanges.map { Pair(it.getKey(), it) }.toMap()
    Assertions.assertUniqKeys(stemChanges.map {
      Pair(it.getQuizQuestion(), it) })
  }
  fun byKey(key: String): StemChange = stemChangeByKey[key]!!
}
