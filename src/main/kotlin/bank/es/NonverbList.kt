package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.Interpretation
import com.danstutzman.db.Db

fun pluralizeEs(base: String): String {
  if (base.endsWith("a") ||
    base.endsWith("e") ||
    base.endsWith("o")) {
    return base + "s"
  } else if (base.endsWith("ión")) {
    return base.substring(0, base.length - 3) + "iones"
  } else if (base.endsWith("d") ||
    base.endsWith("l") ||
    base.endsWith("n") ||
    base.endsWith("r")) {
    return base + "es"
  } else if (base.endsWith("z")) {
    return base.substring(0, base.length - 1) + "ces"
  } else {
    throw CantMakeCard("Don't know how to pluralize es ${base}")
  }
}

class NonverbList {
  val nonverbs: List<Nonverb>
  val nonverbByEsLower: Map<String, Nonverb>

  constructor(db: Db) {
    nonverbs = db.esNonverbsTable.selectAll().flatMap { row ->
      val newNonverbs = mutableListOf<Nonverb>()

      newNonverbs.add(Nonverb(
        leafId = row.leafId,
        esMixed = row.esMixed,
        en = row.en,
        enDisambiguation = if (row.enDisambiguation != "")
          row.enDisambiguation else null
      ))

     if (row.enPlural != null) {
        newNonverbs.add(Nonverb(
          leafId = row.leafId,
          esMixed = pluralizeEs(row.esMixed),
          en = row.enPlural,
          enDisambiguation = if (row.enDisambiguation != "")
            row.enDisambiguation else null
        ))
     }

      newNonverbs
    }
    nonverbByEsLower =
      nonverbs.map { Pair(it.esMixed.toLowerCase(), it) }.toMap()
  }

  fun interpretEsLower(esLower: String): List<Interpretation> {
    val interpretations = mutableListOf<Interpretation>()
    if (nonverbByEsLower[esLower] != null) {
      interpretations.add(Interpretation("Nonverb", nonverbByEsLower[esLower]))
    }
    interpretations.add(Interpretation("Nonverb", null))
    return interpretations
  }
}