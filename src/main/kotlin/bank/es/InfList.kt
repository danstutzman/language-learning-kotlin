package com.danstutzman.bank.es

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.IdSequence

private val infsWithoutIds = listOf(
  Inf(0, "andar",     "walk",       "walked",     null),
  Inf(0, "comer",     "eat",        "ate",        null),
  Inf(0, "conocer",   "know",       "knew",       "person"),
  Inf(0, "contar",    "tell",       "told",       null),
  Inf(0, "dar",       "give",       "gave",       null),
  Inf(0, "decir",     "say",        "said",       null),
  Inf(0, "empezar",   "start",      "started",    null),
  Inf(0, "encontrar", "find",       "found",      null),
  Inf(0, "entender",  "understand", "understood", null),
  Inf(0, "enviar",    "send",       "sent",       null),
  Inf(0, "estar",     "be",         "was",        "how"),
  Inf(0, "hacer",     "do",         "did",        null),
  Inf(0, "ir",        "go",         "went",       null),
  Inf(0, "parecer",   "seem",       "seemed",     null),
  Inf(0, "pedir",     "request",    "requested",  null),
  Inf(0, "pensar",    "think",      "thought",    null),
  Inf(0, "poder",     "can",        "could",      null),
  Inf(0, "poner",     "put",        "put",        null),
  Inf(0, "preguntar", "ask",        "asked",      null),
  Inf(0, "querer",    "want",       "wanted",     null),
  Inf(0, "recordar",  "remember",   "remembered", null),
  Inf(0, "saber",     "know",       "knew",       "thing"),
  Inf(0, "salir",     "go out",       "went out", null),
  Inf(0, "seguir",    "follow",     "followed",   null),
  Inf(0, "sentir",    "feel",       "felt",       null),
  Inf(0, "ser",       "be",         "was",        "what"),
  Inf(0, "tener",     "have",       "had",        null),
  Inf(0, "ver",       "see",        "saw",        null),
  Inf(0, "venir",     "come",       "came",       null),
  Inf(0, "volver",    "return",     "returned",   null)
)
private val infByQuestion = Assertions.assertUniqKeys(infsWithoutIds.map {
  Pair(it.getQuizQuestion(), it)
})

class InfList {
  val infs: List<Inf>
  val infByEs: Map<String, Inf>

  constructor(cardIdSequence: IdSequence) {
    infs = infsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    infByEs = infs.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Inf? = infByEs[es]
}