package com.danstutzman.es

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.IdSequence

val nsWithoutIds = listOf(
  N(0, "brazo", "arm", Gender.M),
  N(0, "pierna", "leg", Gender.F),
  N(0, "corazón", "heart", Gender.M),
  N(0, "estómago", "stomach", Gender.M),
  N(0, "ojo", "eye", Gender.M),
  N(0, "nariz", "nose", Gender.F),
  N(0, "boca", "mouth", Gender.F),
  N(0, "oreja", "ear", Gender.F),
  N(0, "cara", "face", Gender.F),
  N(0, "cuello", "neck", Gender.M),
  N(0, "dedo", "finger", Gender.M),
  N(0, "pie", "foot", Gender.M),
  N(0, "muslo", "thigh", Gender.M),
  N(0, "tobillo", "ankle", Gender.M),
  N(0, "codo", "elbow", Gender.M),
  N(0, "muñeca", "wrist", Gender.F),
  N(0, "cuerpo", "body", Gender.M),
  N(0, "diente", "tooth", Gender.M),
  N(0, "mano", "hand", Gender.F),
  N(0, "espalda", "back", Gender.F),
  N(0, "cadera", "hip", Gender.F),
  N(0, "mandíbula", "jaw", Gender.F),
  N(0, "hombro", "shoulder", Gender.M),
  N(0, "pulgar", "thumb", Gender.M),
  N(0, "lengua", "tongue", Gender.F),
  N(0, "garganta", "throat", Gender.F)
)
val nByQuestion = Assertions.assertUniqKeys(
  nsWithoutIds.map { Pair(it.getQuizQuestion(), it) })

class NList {
  val ns: List<N>
  val nByEs: Map<String, N>

  constructor(cardIdSequence: IdSequence) {
    ns = nsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    nByEs = ns.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): N = nByEs[es]!!
}
