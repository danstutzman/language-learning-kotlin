package com.danstutzman.arabic

fun splitQalamIntoAtoms(qalam: String): List<String> {
  val phonemes = mutableListOf<String>()
  val charsWithExtraBlanks = qalam.split("")
  val chars = charsWithExtraBlanks.slice(1..charsWithExtraBlanks.size - 2)

  // consider all character pairs
  var i = 0
  while (i < chars.size - 1) {
    val char = chars[i]
    val nextChar = chars[i + 1]
    if (char == "a" && nextChar == "a") {
      phonemes.add("aa")
      i += 2
    } else if (char == "a" && nextChar == "e") {
      phonemes.add("ae")
      i += 2
    } else if (char == "i" && nextChar == "i") {
      phonemes.add("ii")
      i += 2
    } else if (char == "u" && nextChar == "u") {
      phonemes.add("uu")
      i += 2
    } else if (char == "s" && nextChar == "h") {
      phonemes.add("sh")
      i += 2
    } else if (char == "d" && nextChar == "h") {
      phonemes.add("dh")
      i += 2
    } else if (char == "g" && nextChar == "h") {
      phonemes.add("gh")
      i += 2
    } else if (char == "t" && nextChar == "h") {
      phonemes.add("th")
      i += 2
    } else {
      phonemes.add(char)
      i += 1
    }
  }

  // handle last char if not handled already
  if (i == chars.size - 1) {
    phonemes.add(chars[i])
  }

  return phonemes
}
