package com.danstutzman.grammars

import mouse.runtime.SourceString

val SQUIGGLE_REGEXP = "([btvjHxd*rzs\$SDTZEgfqklmnhwyaA])([aiu])?~".toRegex()

fun SplitArabicMorphemeIntoSyllables(morphemeBuckwalter: String): List<CVC> {
  val doubled = morphemeBuckwalter
		.replace(SQUIGGLE_REGEXP, "$1$1$2")

  val parser = ArabicMorphemeParser()

  val success: Boolean
  try {
    success = parser.parse(SourceString(doubled))
  } catch (e: RuntimeException) {
    println("Error when parsing $doubled")
    throw e
  }

  if (!success) {
    throw RuntimeException("Couldn't split Arabic morpheme: $doubled")
  }

  val cvcs = parser.semantics().syllables!!

//  val matchedText = cvcs.map { it.c1 + it.v + it.c2 }.joinToString("")
 // if (matchedText.length < doubled.length) {
  //  throw RuntimeException(
   //   "Attempted parse of Arabic morpheme '$doubled' was $cvcs")
//  }

  return cvcs
}
