package com.danstutzman.arabic

val IS_PUNCTUATION = setOf(".", "?", "!")

data class AtomContext2 (
  val atom: String,
  val endsMorpheme: Boolean,
  val left2: String?,
  val left: String?,
  val right: String?,
  val right2: String?,
  val endsSyllable: Boolean
)

val COUNTS_AS_CONSONANT = setOf(
  "D", "H", "S", "N", "T", "Z", "b", "c", "d", "dh", "f", "gh", "h", "j",
  "k", "l", "m", "n", "q", "r", "s", "sh", "t", "th", "w", "x", "y", "z", "'")

val COUNTS_AS_VOWEL =
  setOf("A", "a", "aa", "ae", "e", "i", "ii", "u", "uu", "w", "y")

// Assumes atoms param makes up one and only one morpheme
fun addContextToAtoms(atoms: List<String>): List<AtomContext2> {
  val atomContext2s = mutableListOf<AtomContext2>()
  var currentSyllableHasVowel = false
  var currentSyllableHasInitialConsonant = false

  for (i in atoms.size - 1 downTo 0) {
    val atom = atoms[i]
    val left = if (i > 0) atoms[i - 1] else null
    val right = if (i < atoms.size - 1) atoms[i + 1] else null
    val left2 = if (i > 1) atoms[i - 2] else null
    val right2 = if (i < atoms.size - 2) atoms[i + 2] else null
    val isLast = (i == atoms.size - 1)

    if (COUNTS_AS_CONSONANT.contains(atom)) {
      if (currentSyllableHasInitialConsonant) {
        atomContext2s.add(0, AtomContext2(
          atom, isLast, left2, left, right, right2, endsSyllable=true))
        currentSyllableHasVowel = false
        currentSyllableHasInitialConsonant = false
      } else {
        atomContext2s.add(0, AtomContext2(
          atom, isLast, left2, left, right, right2, endsSyllable=isLast))
        if (currentSyllableHasVowel) {
          currentSyllableHasInitialConsonant = true
        }
      }
    } else if (COUNTS_AS_VOWEL.contains(atom)) {
      if (currentSyllableHasInitialConsonant) {
        atomContext2s.add(0, AtomContext2(
          atom, isLast, left2, left, right, right2, endsSyllable=true))
        currentSyllableHasVowel = true
        currentSyllableHasInitialConsonant = false
      } else {
        atomContext2s.add(0, AtomContext2(
          atom, isLast, left2, left, right, right2, endsSyllable=isLast))
        currentSyllableHasVowel = true
      }
    } else if (IS_PUNCTUATION.contains(atom)) {
      atomContext2s.add(0, AtomContext2(
        atom, isLast, left2, left, right, right2, endsSyllable=isLast))
    } else {
      throw RuntimeException("Can't handle atom '$atom'")
    }
  }

  return atomContext2s
}
