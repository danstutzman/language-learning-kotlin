package com.danstutzman.arabic

import com.danstutzman.arabic.addContextToAtoms
import com.danstutzman.arabic.PronounceAtomContext2
import com.danstutzman.arabic.splitQalamIntoAtoms
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance
import org.opentest4j.AssertionFailedError

fun pronounce(qalam: String): String {
  val atoms = splitQalamIntoAtoms(qalam)
  val contexts2 = addContextToAtoms(atoms)
  val pronunciations = contexts2.map { context ->
    PronounceAtomContext2.pronounceAtomContext2(context) +
    (if (context.endsSyllable) "." else "")
  }
  return pronunciations.joinToString("").replace("\\.$".toRegex(), "")
}

// Examples from https://www.lebanesearabicinstitute.com/arabic-alphabet/

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class PronounceAtomContext2Test {
  @Test
  fun testAdjustsVowelsBasedOnSurroundingConsonants() {
    assertEquals("sˤɑ.ʕiːd", pronounce("Saciid"))
    assertEquals("sæ.ʕiːd", pronounce("saciid"))
    assertEquals("ħɑ.sˤɘd", pronounce("HaaSid"))
    assertEquals("ħæ.sɪd", pronounce("Haasid"))
    assertEquals("ħæ.rɑsˤ", pronounce("HaraS"))
    assertEquals("ħæ.ræs", pronounce("Haras"))
    assertEquals("tˤɑʔ", pronounce("Taa'"))
    assertEquals("tæʔ", pronounce("taa'"))
    assertEquals("ju.rɑtˤ.tˤɘb", pronounce("yuraTTib"))
    assertEquals("ju.ræt.tɪb", pronounce("yurattib"))
    assertEquals("ħɑtˤ", pronounce("HaaT"))
    assertEquals("ħæt", pronounce("Haat"))
    assertEquals("zˤɑ.liːl", pronounce("Zaliil"))
    assertEquals("ðæ.liːl", pronounce("dhaliil"))
    assertEquals("mɑħ.zˤuːr", pronounce("maHZuur"))
    assertEquals("mæħ.ðuːr", pronounce("maHdhuur"))
    assertEquals("bɑzˤzˤ", pronounce("baZZ"))
    assertEquals("bæðð", pronounce("badhdh"))
    assertEquals("dˤɑrr", pronounce("Darr"))
    assertEquals("dærr", pronounce("darr"))
    assertEquals("tæ.ħɑdˤ.dˤɔr", pronounce("taHaDDur"))
    assertEquals("tæ.ħæd.dor", pronounce("taHaddur"))
    assertEquals("rɔ.dˤuːdˤ", pronounce("ruDuuD"))
    assertEquals("ro.duːd", pronounce("ruduud"))
    assertEquals("kælb", pronounce("kalb"))
    assertEquals("qɑlb", pronounce("qalb"))
    assertEquals("tæk.riːr", pronounce("takriir"))
    assertEquals("tɑq.riːr", pronounce("taqriir"))
    assertEquals("ħækk", pronounce("Hakk"))
    assertEquals("ħɑqq", pronounce("Haqq"))
  }
}