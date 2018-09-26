package com.danstutzman.arabic

import com.danstutzman.arabic.addContextToAtoms
import com.danstutzman.arabic.BuckwalterToQalamParser
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance
import org.opentest4j.AssertionFailedError
import mouse.runtime.SourceString
import java.io.BufferedReader
import java.io.InputStreamReader

fun convertBuckwalterToQalam(doubled: String): String {
  val parser = BuckwalterToQalamParser()

  val success: Boolean
  try {
    success = parser.parse(SourceString(doubled))
  } catch (e: RuntimeException) {
    println("Error when parsing $doubled")
    throw e
  }

  if (!success) {
    throw RuntimeException("Couldn't convert Buckwalter to Qalam: $doubled")
  }

  return parser.semantics().qalam!!
}

fun testRoundTripLine(line: String) {
  val values = line.split(",")
  val bookQalam = values[1]
  val correctedQalam = if (values[2] != "") values[2] else bookQalam
  val expectedBuckwalter = values[3]
  val correctedBuckwalter =
    if (values.size >= 5 && values[4] != "") values[4] else expectedBuckwalter
  val buckwalterWords = correctedBuckwalter.split(" ")

  val doubleds = mutableListOf<String>()
  val actualQalams = mutableListOf<String>()
  var roundTripped = ""
  val allAtomContext2s = mutableListOf<AtomContext2>()
  for (buckwalterWord in buckwalterWords) {
    val match1 = "^-".toRegex().find(buckwalterWord)
    val beginHyphen = if (match1 != null) match1.groupValues[0] else ""
    val match2 = "-$".toRegex().find(buckwalterWord)
    val endHyphen = if (match2 != null) match2.groupValues[0] else ""

    val doubled = buckwalterWord
      .replace("^-".toRegex(), "")
      .replace("-$".toRegex(), "")
      .replace("([DHSTZbcdfgjklmnqrstvwyz$*])~".toRegex(), "$1$1")
    doubleds.add(doubled)

    val actualQalam: String
    try {
      actualQalam = convertBuckwalterToQalam(doubled)
    } catch (e: RuntimeException) {
      println("correctedBuckwalter: $correctedBuckwalter")
      println("buckwalterWord: $buckwalterWord")
      println("doubled: $doubled")
      throw e
    }
    actualQalams.add(beginHyphen + actualQalam + endHyphen)

    val atoms = splitQalamIntoAtoms(actualQalam)
    val atomContext1s = atoms.withIndex().map { (j: Int, atom: String) ->
      AtomContext1(
        atom = atom,
        endsMorpheme = (j == atoms.size - 1),
        beginPunctuation = if (j == 0) beginHyphen else "",
        endPunctuation = if (j == atoms.size - 1) endHyphen else "")
    }

    val atomContext2s: List<AtomContext2>
    try {
      atomContext2s = addContextToAtoms(atomContext1s)
    } catch (e: RuntimeException) {
      println("correctedQalam: $correctedQalam")
      println("correctedBuckwalter: $correctedBuckwalter")
      println("buckwalterWord: $buckwalterWord")
      println("doubled: $doubled")
      println("actualQalam: $actualQalam")
      throw e
    }
    allAtomContext2s.addAll(atomContext2s)

    val morphemeRoundTripped: String
    try {
      morphemeRoundTripped = atomContext2s.map { atomContext2 ->
        atomContext2.beginPunctuation +
        convertAtomContext2ToBuckwalter(atomContext2) +
        atomContext2.endPunctuation +
        (if (atomContext2.endsMorpheme) " " else "")
      }.joinToString("")
    } catch (e: RuntimeException) {
      println("correctedQalam: $correctedQalam")
      println("correctedBuckwalter: $correctedBuckwalter")
      println("buckwalterWord: $buckwalterWord")
      println("doubled: $doubled")
      println("actualQalam: $actualQalam")
      println("atomContext2s: $atomContext2s")
      throw e
    }
    roundTripped += morphemeRoundTripped
  }

  val actualQalamsJoined = actualQalams
    .joinToString(" ")
    .replace(" ?- ?".toRegex(), "-")
    .replace("-([.?])".toRegex(), "$1")
  try {
    assertEquals(correctedQalam, actualQalamsJoined)
  } catch (e: AssertionFailedError) {
    println("(expected) correctedQalam: $correctedQalam")
    println("correctedBuckwalter: $correctedBuckwalter")
    println("actualQalamsJoined: $actualQalamsJoined")
    throw e
  }

  roundTripped = roundTripped
    .replace("([DHSTZbcdfgjklmnqrstvwyz$*])o?\\1".toRegex(), "$1~")
    .replace("l~l".toRegex(), "ll~")
    .replace(" $".toRegex(), "")
    .replace("o -([aiuwyAN])".toRegex(), " -$1")
    .replace("> -n".toRegex(), ">o -n")
    .replace("> -w".toRegex(), "& -w")
    .replace("> -y".toRegex(), "} -y")
    .replace("' -u(.)".toRegex(), "& -u$1")
    .replace("' -i(.)".toRegex(), "} -i$1")

  if (correctedBuckwalter + "o" == roundTripped) {
    assertEquals(correctedBuckwalter + "o", roundTripped)
  } else {
    try {
      assertEquals(correctedBuckwalter, roundTripped)
    } catch (e: AssertionFailedError) {
      println("correctedBuckwalter: $correctedBuckwalter")
      println("doubleds: $doubleds")
      println("actualQalams: $actualQalams")
      println("syllables: " + allAtomContext2s.map { atomContext2 ->
        atomContext2.atom +
          (if (atomContext2.endsSyllable) " -" else "") +
          (if (atomContext2.endsMorpheme) "/" else "")
        }.joinToString(" "))
      println("roundTripped: $roundTripped")
      throw e
    }
  }
}

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class RoundTripTest {
  @Test
  fun convertsQalamToBuckwalterAndBack() {
    val reader = BufferedReader(InputStreamReader(
      this.javaClass.getResourceAsStream("/qalam_to_buckwalter.csv")))
    reader.forEachLine { line: String ->
      if (line != "" && !line.startsWith("#")) {
        testRoundTripLine(line)
      }
    }
  }
}



      /*
    }
  } // next line
})
*/
