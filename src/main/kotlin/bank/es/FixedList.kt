package com.danstutzman.bank.es

import com.danstutzman.bank.IdSequence

val fixedsWithoutIds = listOf(
  Fixed(0, "el",   "the"),
  Fixed(0, "la",   "the"),
  Fixed(0, "un",   "a"),
  Fixed(0, "una",  "a"),
  Fixed(0, "mi",   "my"),
  Fixed(0, "este", "this"),
  Fixed(0, "esta", "this"),
  Fixed(0, "cada", "every"),
  Fixed(0, "cómo", "how"),
  Fixed(0, "bien", "well"),
  Fixed(0, "yo", "I"),
  Fixed(0, "tú", "you"),
  Fixed(0, "él", "he"),
  Fixed(0, "ella", "she"),
  Fixed(0, "qué", "what"),
  Fixed(0, "hola", "hello"),
  Fixed(0, "de", "of"),
  Fixed(0, "dónde", "where"),
  Fixed(0, "donde", "where"),
  Fixed(0, "software", "software"),
  Fixed(0, "con", "with"),
  Fixed(0, "quién", "who"),
  Fixed(0, "me", "me"),
  Fixed(0, "te", "you"),
  Fixed(0, "mí", "me"))

class FixedList {
  val fixeds: List<Fixed>
  val fixedByEs: Map<String, Fixed>

  constructor(cardIdSequence: IdSequence) {
    fixeds = fixedsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    fixedByEs = fixeds.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Fixed? = fixedByEs[es]
}
