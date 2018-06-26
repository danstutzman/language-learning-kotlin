package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.db.Db

fun pluralizeEs(base: String): String {
  if (base.endsWith("a") ||
    base.endsWith("e") ||
    base.endsWith("o")) {
    return base + "s"
  } else if (base.endsWith("ión")) {
    return base.substring(0, base.length - 3) + "iones"
  } else if (base.endsWith("l") ||
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
  val nonverbByEs: Map<String, Nonverb>

  constructor(db: Db) {
    nonverbs = db.selectAllNonverbRows().flatMap { row ->
      val newNonverbs = mutableListOf<Nonverb>()

      newNonverbs.add(Nonverb(
        leafId = row.leafId,
        es = row.es,
        en = row.en,
        enDisambiguation = if (row.enDisambiguation != "")
          row.enDisambiguation else null
      ))

     if (row.enPlural != null) {
        newNonverbs.add(Nonverb(
          leafId = row.leafId,
          es = pluralizeEs(row.es),
          en = row.enPlural,
          enDisambiguation = if (row.enDisambiguation != "")
            row.enDisambiguation else null
        ))
     }

      newNonverbs
    }
    nonverbByEs = nonverbs.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Nonverb? = nonverbByEs[es]
}