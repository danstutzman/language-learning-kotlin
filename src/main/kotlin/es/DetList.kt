package es

import seeds.Assertions
import seeds.IdSequence

val detsWithoutIds = listOf(
  Det(0, "el",   "the",   Gender.M),
  Det(0, "la",   "the",   Gender.F),
  Det(0, "un",   "a",     Gender.M),
  Det(0, "una",  "a",     Gender.F),
  Det(0, "mi",   "my",    null),
  Det(0, "este", "this",  Gender.M),
  Det(0, "esta", "this",  Gender.F),
  Det(0, "cada", "every", null)
)
val detByQuestion = Assertions.assertUniqKeys(
	detsWithoutIds.map { Pair(it.getQuizQuestion(), it) })

class DetList {
  val dets: List<Det>
  val detByEs: Map<String, Det>

  constructor(cardIdSequence: IdSequence) {
    dets = detsWithoutIds.map { it.copy(cardId = cardIdSequence.nextId()) }
    detByEs = dets.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Det = detByEs[es]!!
}
