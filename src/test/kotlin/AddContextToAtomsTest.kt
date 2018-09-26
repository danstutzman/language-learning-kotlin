package com.danstutzman.arabic

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance
import com.danstutzman.arabic.addContextToAtoms

fun make1(atom: String, endsMorpheme: Boolean): AtomContext1 {
  return AtomContext1(
    atom = atom,
    beginPunctuation = "",
    endPunctuation = "",
    endsMorpheme = endsMorpheme)
}

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class SplitQalamIntoAtomsTest {
  @Test
  fun addsContextToAtoms() {
    val bada1 = make1("b", false)
    val bada2 = make1("a", false)
    val bada3 = make1("d", false)
    val bada4 = make1("a", true)

    assertEquals(listOf<AtomContext2>(
      AtomContext2(bada1, null, null,  "a",  "d", false),
      AtomContext2(bada2, null,  "b",  "d",  "a", true),
      AtomContext2(bada3,  "b",  "a",  "a", null, false),
      AtomContext2(bada4,  "a",  "d", null, null ,true)
    ), addContextToAtoms(listOf(bada1, bada2, bada3, bada4)))
  }
}
