package com.danstutzman.arabic

import com.danstutzman.arabic.addContextToAtoms

data class AtomAlignment (
  val atom: String,
  val buckwalter: String,
  val ipa: String,
  val endsSyllable: Boolean,
  val endsMorpheme: Boolean,
  val beginsWithHyphen: Boolean,
  val endsWithHyphen: Boolean
)

class ConvertMorphemeToBuckwalter {
  companion object {
    fun convertMorphemeToBuckwalter(
      morphemeQalam: String,
      beginsWithHyphen: Boolean,
      endsWithHyphen: Boolean
    ): List<AtomAlignment> {
      val atoms = splitQalamIntoAtoms(morphemeQalam)

      val atomContext2s = addContextToAtoms(atoms)

      return atomContext2s.withIndex().map { (i: Int, atomContext2: AtomContext2) ->
        AtomAlignment(
          atom = atomContext2.atom,
          buckwalter = convertAtomContext2ToBuckwalter(atomContext2),
          ipa = PronounceAtomContext2.pronounceAtomContext2(atomContext2),
          endsSyllable = atomContext2.endsSyllable,
          endsMorpheme = atomContext2.endsMorpheme,
          beginsWithHyphen = (i == 0 && beginsWithHyphen),
          endsWithHyphen = (i == atoms.size - 1 && endsWithHyphen))
      }
    }
  }
}