package com.danstutzman.arabic

import com.danstutzman.arabic.BuckwalterToQalamParser
import com.danstutzman.arabic.ConvertMorphemeToBuckwalter
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

  val doubleds = mutableListOf<String>()
  val actualQalams = mutableListOf<String>()
  val atomAlignments = mutableListOf<AtomAlignment>()
  for (morphemeBuckwalter in correctedBuckwalter.split(" ")) {
    val match1 = "^-".toRegex().find(morphemeBuckwalter)
    val beginsWithHyphen = (match1 != null)
    val match2 = "-$".toRegex().find(morphemeBuckwalter)
    val endsWithHyphen = (match2 != null)

    val doubled = morphemeBuckwalter
      .replace("^-".toRegex(), "")
      .replace("-$".toRegex(), "")
      .replace("([DHSTZbcdfgjklmnqrstvwyz$*])~".toRegex(), "$1$1")
    doubleds.add(doubled)

    val actualQalam: String
    try {
      actualQalam = convertBuckwalterToQalam(doubled)
    } catch (e: RuntimeException) {
      println("correctedBuckwalter: $correctedBuckwalter")
      println("morphemeBuckwalter: $morphemeBuckwalter")
      println("doubled: $doubled")
      throw e
    }
    actualQalams.add(
      (if (beginsWithHyphen) "-" else "") +
      actualQalam +
      (if (endsWithHyphen) "-" else ""))

    val morphemeAtomAlignments: List<AtomAlignment>
    try {
      morphemeAtomAlignments =
        ConvertMorphemeToBuckwalter.convertMorphemeToBuckwalter(
          actualQalam, beginsWithHyphen, endsWithHyphen)
    } catch (e: RuntimeException) {
      println("correctedQalam: $correctedQalam")
      println("correctedBuckwalter: $correctedBuckwalter")
      println("morphemeBuckwalter: $morphemeBuckwalter")
      println("doubled: $doubled")
      println("atomAlignments: $atomAlignments")
      throw e
    }
    atomAlignments += morphemeAtomAlignments
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

  val roundTripped = atomAlignments.map {
    (if (it.beginsWithHyphen) "-" else "") +
    it.buckwalter +
    (if (it.endsWithHyphen) "-" else "") +
    (if (it.endsMorpheme) " " else "")
  }.joinToString("")
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
      println("syllables: " + atomAlignments.map { atomAlignment ->
        atomAlignment.atom +
          (if (atomAlignment.endsSyllable) " -" else "") +
          (if (atomAlignment.endsMorpheme) "/" else "")
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
