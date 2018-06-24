package com.danstutzman.bank.es

import com.danstutzman.bank.IdSequence

val flexiblesWithoutIds = listOf(
  Flexible(0, "brazo", "arm"),
  Flexible(0, "pierna", "leg"),
  Flexible(0, "corazón", "heart"),
  Flexible(0, "estómago", "stomach"),
  Flexible(0, "ojo", "eye"),
  Flexible(0, "nariz", "nose"),
  Flexible(0, "boca", "mouth"),
  Flexible(0, "oreja", "ear"),
  Flexible(0, "cara", "face"),
  Flexible(0, "cuello", "neck"),
  Flexible(0, "dedo", "finger"),
  Flexible(0, "pie", "foot"),
  Flexible(0, "muslo", "thigh"),
  Flexible(0, "tobillo", "ankle"),
  Flexible(0, "codo", "elbow"),
  Flexible(0, "muñeca", "wrist"),
  Flexible(0, "cuerpo", "body"),
  Flexible(0, "diente", "tooth"),
  Flexible(0, "mano", "hand"),
  Flexible(0, "espalda", "back"),
  Flexible(0, "cadera", "hip"),
  Flexible(0, "mandíbula", "jaw"),
  Flexible(0, "hombro", "shoulder"),
  Flexible(0, "pulgar", "thumb"),
  Flexible(0, "lengua", "tongue"),
  Flexible(0, "garganta", "throat"),
  Flexible(0, "español", "Spanish"),
  Flexible(0, "inglés", "English"),
  Flexible(0, "bueno", "good"),
  Flexible(0, "día", "day"),
  Flexible(0, "tarde", "afternoon"),
  Flexible(0, "ingeniero", "engineer"),
  Flexible(0, "lista", "list")
)

class FlexibleList {
  val flexibles: List<Flexible>
  val flexibleByEs: Map<String, Flexible>

  constructor(cardIdSequence: IdSequence) {
    flexibles = flexiblesWithoutIds.map {
      it.copy(cardId = cardIdSequence.nextId()) }
    flexibleByEs = flexibles.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Flexible? = flexibleByEs[es]
}
