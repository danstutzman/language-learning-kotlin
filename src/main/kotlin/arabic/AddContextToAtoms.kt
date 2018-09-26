package com.danstutzman.arabic

data class AtomContext1 (
  val atom: String,
  val endsMorpheme: Boolean,
  val beginPunctuation: String,
  val endPunctuation: String
)

data class AtomContext2 (
  val atom: String,
  val endsMorpheme: Boolean,
  val beginPunctuation: String,
  val endPunctuation: String,

  val left2: String?,
  val left: String?,
  val right: String?,
  val right2: String?,
  val endsSyllable: Boolean
) {
  constructor(
    atomContext1: AtomContext1,
    left2: String?,
    left: String?,
    right: String?,
    right2: String?,
    endsSyllable: Boolean
  ): this(
    atomContext1.atom,
    atomContext1.endsMorpheme,
    atomContext1.beginPunctuation,
    atomContext1.endPunctuation,
    left2,
    left,
    right,
    right2,
    endsSyllable
  )
}

val COUNTS_AS_CONSONANT = setOf(
  "D", "H", "S", "N", "T", "Z", "b", "c", "d", "dh", "f", "gh", "h", "j",
  "k", "l", "m", "n", "q", "r", "s", "sh", "t", "th", "w", "x", "y", "z", "'")

val COUNTS_AS_VOWEL =
  setOf("A", "a", "aa", "ae", "e", "i", "ii", "u", "uu", "w", "y")

fun addContextToAtoms(atomContext1s: List<AtomContext1>): List<AtomContext2> {
  val atomContext2s = mutableListOf<AtomContext2>()
  var currentSyllableHasVowel = false
  var currentSyllableHasInitialConsonant = false

  for (i in atomContext1s.size - 1 downTo 0) {
    val atomContext1 = atomContext1s[i]
    val atom = atomContext1s[i].atom
    val left = if (i > 0) atomContext1s[i - 1].atom else null
    val right = if (i < atomContext1s.size - 1) atomContext1s[i + 1].atom
      else null
    val left2 = if (i > 1) atomContext1s[i - 2].atom else null
    val right2 = if (i < atomContext1s.size - 2) atomContext1s[i + 2].atom
      else null
    val isLast = (i == atomContext1s.size - 1)

    if (COUNTS_AS_CONSONANT.contains(atom)) {
      if (currentSyllableHasInitialConsonant) {
        atomContext2s.add(0, AtomContext2(
          atomContext1, left2, left, right, right2, endsSyllable=true))
        currentSyllableHasVowel = false
        currentSyllableHasInitialConsonant = false
      } else {
        atomContext2s.add(0, AtomContext2(
          atomContext1, left2, left, right, right2, endsSyllable=isLast))
        if (currentSyllableHasVowel) {
          currentSyllableHasInitialConsonant = true
        }
      }
    } else if (COUNTS_AS_VOWEL.contains(atom)) {
      if (currentSyllableHasInitialConsonant) {
        atomContext2s.add(0, AtomContext2(
          atomContext1, left2, left, right, right2, endsSyllable=true))
        currentSyllableHasVowel = true
        currentSyllableHasInitialConsonant = false
      } else {
        atomContext2s.add(0, AtomContext2(
          atomContext1, left2, left, right, right2, endsSyllable=isLast))
        currentSyllableHasVowel = true
      }
    } else {
      throw RuntimeException("Can't handle $atom")
    }
  }

  return atomContext2s
}
