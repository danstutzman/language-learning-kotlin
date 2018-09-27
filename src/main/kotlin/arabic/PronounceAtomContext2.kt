package com.danstutzman.arabic

val TO_IPA = mapOf(
  "a" to "a",
  "aa" to "æ",
  "i" to "i",
  "ii" to "iː",
  "u" to "u",
  "uu" to "uː",
  "'" to "ʔ", // glottal stop
  "D" to "dˤ",
  "H" to "ħ",
  "S" to "sˤ",
  "T" to "tˤ",
  "Z" to "zˤ",
  "b" to "b",
  "c" to "ʕ", // guttural voiced h
  "d" to "d",
  "dh" to "ð", // "these"
  "gh" to "ɣ", // French "parler"
  "f" to "f",
  "h" to "h",
  "j" to "dʒ", // "jam"
  "k" to "k",
  "l" to "l",
  "m" to "m",
  "n" to "n",
  "q" to "q", // "scar"
  "r" to "r", // tapped
  "s" to "s",
  "sh" to "ʃ",
  "t" to "t",
  "th" to "θ", // "three"
  "w" to "w",
  "x" to "x", // "Bach"
  "y" to "j",
  "z" to "z")

class PronounceAtomContext2 {
  companion object {
    fun pronounceAtomContext2(atomContext2: AtomContext2): String {
      val atom = atomContext2.atom
      val left = atomContext2.left
      val right = atomContext2.right
      val right2 = atomContext2.right2

      if (atom == "a" || atom == "aa" || atom == "A" || atom == "ae") {
        if (left == "D" || right == "D" || right2 == "D") return "ɑ"
        if (left == "S" || right == "S" || right2 == "S") return "ɑ"
        if (left == "T" || right == "T" || right2 == "T") return "ɑ"
        if (left == "Z" || right == "Z" || right2 == "Z") return "ɑ"
        if (left == "q" || right == "q" || right2 == "q") return "ɑ"
        return "æ"
      } else if (atom == "i") {
        if (left == "D" || right == "D" || right2 == "D") return "ɘ"
        if (left == "S" || right == "S" || right2 == "S") return "ɘ"
        if (left == "T" || right == "T" || right2 == "T") return "ɘ"
        if (left == "Z" || right == "Z" || right2 == "Z") return "ɘ"
        return "ɪ"
      } else if (atom == "u") {
        if (left == "y") { return "u" }
        if (left == "D" || right == "D" || right2 == "D") return "ɔ"
        if (left == "S" || right == "S" || right2 == "S") return "ɔ"
        if (left == "T" || right == "T" || right2 == "T") return "ɔ"
        if (left == "Z" || right == "Z" || right2 == "Z") return "ɔ"
        return "o"
      } else if (atom == "e") {
        return ""
      } else if (atom == "N") {
        return "n"
      } else if (IS_PUNCTUATION.contains(atom)) {
        return ""
      } else {
        val ipa = TO_IPA[atom]
        if (ipa == null) {
          throw RuntimeException("Unknown pronunciation for atom '$atom'")
        }
        return ipa
      }
    }
  }
}
