package com.danstutzman.arabic

import com.danstutzman.arabic.AtomContext2

val VOWELS = mapOf(
  "A" to "`",
  "a" to "a",
  "aa" to "A",
  "ae" to "Y",
  "e" to "{",
  "i" to "i",
  "ii" to "y",
  "u" to "u",
  "uu" to "w")

val CONSONANTS = mapOf(
  "D" to "D",
  "H" to "H",
  "S" to "S",
  "T" to "T",
  "Z" to "Z",
  "b" to "b",
  "c" to "E",
  "d" to "d",
  "dh" to "*",
  "f" to "f",
  "gh" to "g",
  "h" to "h",
  "j" to "j",
  "k" to "k",
  "l" to "l",
  "m" to "m",
  "n" to "n",
  "q" to "q",
  "r" to "r",
  "s" to "s",
  "sh" to "$",
  "t" to "t",
  "th" to "v",
  "w" to "w",
  "x" to "x",
  "y" to "y",
  "z" to "z")

val NO_O_AFTER_AL = setOf("l", "T", "r", "sh", "'")

val IS_CASE_ENDING = setOf("a", "i", "u")

fun notFound(left: String?, atom: String, right: String?): RuntimeException {
  return RuntimeException(
    "Can't find buckwalter for ${left ?: ""},${atom},${right ?: ""}")
}

fun handleMedialHamza(left: String?, right: String?): String {
  // hamza after laam-'alif ligature
  if (left == "l" && right == "u") return ">"

  // medial aloof hamza
  if (left == "uu" && right == "a") return "'"
  if (left == "aa" && right == "a") return "'"
  if (left == "aa" && right == "aa") return "'"

  // yaa' seat
  if (left == "i" || left == "y" || left == "ii" ||
      right == "i" || right == "y" || right == "ii") return "}"

  // waaw seat
  if (left == "u" || right == "u" || right == "uu") {
    if (right == "aa") return "&A"
    if (CONSONANTS.contains(right)) return "&o"
    return "&"
  }

  // 'alif madda
  if (right == "aa") return "|"

  // 'alif seat
  if (left == "a" && right == "a") { return ">" }
  if (CONSONANTS.contains(left) && right == "a") { return ">" }
  if (left == "a" && CONSONANTS.contains(right)) { return ">o" }

  throw notFound(left, "'", right)
}

fun handleHamza(left: String?, right: String?, right2: String?): String {
  if (left == null) {
    // initial hamza
    if (right == "a") return ">"
    if (right == "aa") return "|"
    if (right == "i") return "<"
    if (right == "ii") return "<i"
    if (right == "u") return ">"
    throw notFound(left, "'", right)
  } else if (right == null || IS_CASE_ENDING.contains(right) && right2 == null){
    // final hamza
    if (left == "a") return ">"
    if (left == "aa") return "'"
    if (left == "u") return "&"
    if (left == "i") return "}"
    if (left == "uu") return "'"
    if (left == "ii") return "'"
    if (left == "y") return "'"
    if (CONSONANTS.contains(left)) return "'"
    throw notFound(left, "'", right)
  } else {
    return handleMedialHamza(left, right)
  }
}

fun handleConsonant(atomContext2: AtomContext2, buckwalter: String): String {
  val atom         = atomContext2.atom
  val left         = atomContext2.left
  val left2        = atomContext2.left2
  val right        = atomContext2.right
  val endsMorpheme = atomContext2.endsMorpheme
  val endsSyllable = atomContext2.endsSyllable

  if (atom == "l" && (left == "e" || (left == "a" && left2 == "'")) &&
    NO_O_AFTER_AL.contains(right)) {
    return "l"
  }

  if (left == "l" && (left2 == "e" || left2 == "a") &&
    NO_O_AFTER_AL.contains(atom)) {
    return buckwalter
  }

  if (atom == "h" && endsMorpheme && (left == "a" || left == "aa")) {
    return "p"
  }

  if (endsSyllable)              return buckwalter + "o"
  if (right == "'")              return buckwalter + "o"
  if (CONSONANTS[right] != null) return buckwalter + "o"
  return buckwalter
}

fun handleVowel(atomContext2: AtomContext2, simpleVowel: String): String {
  val atom   = atomContext2.atom
  val left   = atomContext2.left
  val left2  = atomContext2.left2
  val right  = atomContext2.right

  if (atom == "i" && right == "N") return ""
  if (atom == "u" && right == "N") return ""
  if (atom == "a" && right == "N") return "A"
  if (atom == "u" && left == "'" && left2 == "A") return ""
  if (atom == "a" && left == "'" && right == "l" && left2 == null) return ""
  if (atom == "aa" && left == "'" && left2 !== "aa") return ""
  return simpleVowel
}

fun handleN(left: String?): String {
  if (left == "ae" || left == "aa" || left == "a") return "F"
  if (left == "i") return "K"
  if (left == "h") return "K"
  if (left == "u") return "N"
  throw notFound(left, "N", "?")
}

fun convertAtomContext2ToBuckwalter(atomContext2: AtomContext2): String {
  val atom   = atomContext2.atom
  val left   = atomContext2.left
  val right  = atomContext2.right
  val right2 = atomContext2.right2

  if (atom == "'") return handleHamza(left, right, right2)

  if (atom == "N") return handleN(left)

  if (CONSONANTS[atom] !== null)
    return handleConsonant(atomContext2, CONSONANTS[atom]!!)

  if (VOWELS[atom] !== null)
    return handleVowel(atomContext2, VOWELS[atom]!!)

  throw notFound(left, atom, right)
}
