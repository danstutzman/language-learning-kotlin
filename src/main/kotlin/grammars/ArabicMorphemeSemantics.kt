package com.danstutzman.grammars

data class CVC (
  val c1: String,
  val v: String,
  val c2: String
)

@Suppress("UNCHECKED_CAST")
class ArabicMorphemeSemantics: mouse.runtime.SemanticsBase() {
  var syllables: List<CVC>? = null

  // Result = WaSyllables
  fun Result() {
    syllables = rhs(0).get() as List<CVC>
  }

  fun SyllablesPunctuation() {
    val char = rhs(1).text()
    lhs().put(listOf(CVC(c1 = "", v = "", c2 = "-" + char)))
  }

  // Syllables = "-" Vowel EndConsonant CVC* LastConsonant?
  fun SyllablesStartingWithDashVowelEndConsonant() {
    val v = rhs(1).text()
    val c2 = rhs(2).text()
		val cvc1 = CVC(c1 = "", v = "-" + v, c2 = c2)
    val cvcs = addLastConsonantToLastCvc(3)
    lhs().put(listOf(cvc1) + cvcs)
  }

  // Syllables = "-" Vowel CVC* LastConsonant?
  fun SyllablesStartingWithDashVowel() {
    val v = rhs(1).text()
		val cvc1 = CVC(c1 = "", v = "-" + v, c2 = "")
    val cvcs = addLastConsonantToLastCvc(2)
		lhs().put(listOf(cvc1) + cvcs)
  }

  // Syllables = "-" "o" CVC* LastConsonant?
  fun SyllablesStartingWithDashO() {
		val cvc1 = CVC(c1 = "", v = "", c2 = "-o")
    val cvcs = addLastConsonantToLastCvc(2)
		lhs().put(listOf(cvc1) + cvcs)
  }

  // Syllables = "-" EndConsonant CVC*
  fun SyllablesStartingWithDashEndConsonant() {
    val cvc1 = CVC(c1 = "", v = "", c2 = "-" + rhs(1).text())
		val cvcs = (2..rhsSize() - 1).map { i -> rhs(i).get() as CVC }
		lhs().put(listOf(cvc1) + cvcs)
  }

  // Syllables = "-" CVC* LastConsonant?
  fun SyllablesStartingWithDash() {
		val cvcs = (1..rhsSize() - 1).map { i ->
      val cvc = rhs(i).get() as CVC
      if (i == 1) CVC(c1 = "-" + cvc.c1, v = cvc.v, c2 = cvc.c2) else cvc
    }
		lhs().put(cvcs)
  }

  private fun addLastConsonantToLastCvc(startingI: Int): List<CVC> {
		val cvcs = mutableListOf<CVC>()
		for (i in startingI..rhsSize() - 1) {
			val part = rhs(i).get()
			if (part == null) {
				// Skip last consonant
			} else if (i < rhsSize() - 1 && rhs(i + 1).get() == null) {
				val lastConsonant = rhs(i + 1).text()
				val penultimateCvc = part as CVC
				cvcs.add(CVC(
					c1 = penultimateCvc.c1,
					v = penultimateCvc.v,
					c2 = penultimateCvc.c2 + lastConsonant
				))
			} else {
				cvcs.add(part as CVC)
			}
		}
    return cvcs
  }

  // Syllables = First? Cvc* LastConsonant?
  fun SyllablesNotStartingWithDash() {
    val cvcs = addLastConsonantToLastCvc(0)
		lhs().put(cvcs)
  }

  fun First1() {
		lhs().put(CVC(c1 = "", v = "{", c2 = "l" + rhs(2).text()))
	}
	fun First2() {
		lhs().put(CVC(c1 = "", v = "{", c2 = "lo"))
  }
	fun First3() {
		lhs().put(CVC(c1 = "", v = "{", c2 = "l"))
  }
	fun First4() {
		val c2 = if (rhsSize() == 2) rhs(1).text() else ""
		lhs().put(CVC(c1 = "", v = "{", c2 = c2))
  }
	fun First5() {
		val c2 = if (rhsSize() == 2) rhs(1).text() else ""
		lhs().put(CVC(c1 = "", v = ">a", c2 = c2))
  }
	fun First6() {
		lhs().put(CVC(c1 = "", v = "<i", c2 = "y"))
  }
	fun First7() {
		lhs().put(CVC(c1 = "", v = "<i", c2 = ""))
  }
	fun First8() {
		lhs().put(CVC(c1 = "", v = "Aa", c2 = "ls"))
  }
	fun First9() {
		lhs().put(CVC(c1 = "", v = "Aa", c2 = "lo"))
  }
	fun First10() {
		lhs().put(CVC(c1 = "", v = "Aa", c2 = "l"))
  }
	fun First11() {
		val c2 = if (rhsSize() == 2) rhs(1).text() else ""
		lhs().put(CVC(c1 = "", v = "Ai", c2 = c2))
  }
	fun First12() {
		val v = rhs(0).text()
		val c2 = if (rhsSize() == 2) rhs(1).text() else ""
		lhs().put(CVC(c1 = "", v = v, c2 = c2))
  }

  // CVC = Consonant "ap" {CVCEndsWithAP}
  fun CVCEndsWithAP() {
    val c1 = rhs(0).text() as String
    lhs().put(CVC(c1 = c1, v = "a", c2 = "p"))
  }

  fun CVCStartConsonantDash() {
    val c1 = rhs(0).text() as String
    lhs().put(CVC(c1 = c1 + "-", v = "", c2 = ""))
  }

  // CVC = StartConsonant Vowel EndConsonant
  fun CVCWithEndConsonant() {
    val c1 = rhs(0).text() as String
    val v = rhs(1).text() as String
    val c2 = rhs(2).text() as String
    lhs().put(CVC(c1 = c1, v = v, c2 = c2))
  }

  // CVC = StartConsonant Vowel EndConsonant
  fun CVCWithoutEndConsonant() {
    val c1 = rhs(0).text() as String
    val v = rhs(1).text() as String
    lhs().put(CVC(c1 = c1, v = v, c2 = ""))
  }
}
