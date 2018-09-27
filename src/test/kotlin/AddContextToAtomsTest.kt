package com.danstutzman.arabic

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance
import com.danstutzman.arabic.addContextToAtoms

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class SplitQalamIntoAtomsTest {
  @Test
  fun addsContextToAtoms() {
    assertEquals(listOf<AtomContext2>(
      AtomContext2("b", false, null, null,  "a",  "d", false),
      AtomContext2("a", false, null,  "b",  "d",  "a", true),
      AtomContext2("d", false,  "b",  "a",  "a", null, false),
      AtomContext2("a",  true,  "a",  "d", null, null ,true)
    ), addContextToAtoms(listOf("b", "a", "d", "a")))
  }
}
