package com.danstutzman.bank.es

import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.IdSequence
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

class EntryList {
  val entries: List<Entry>
  val entryByEs: Map<String, Entry>

  constructor(cardIdSequence: IdSequence, db: Db) {
    entries = db.selectAllEntryRows().flatMap { entryRow ->
      val newEntries = mutableListOf<Entry>()

      newEntries.add(Entry(
        cardId = cardIdSequence.nextId(),
        es = entryRow.es,
        en = entryRow.en,
        enDisambiguation = if (entryRow.enDisambiguation != "")
          entryRow.enDisambiguation else null
      ))

      if (entryRow.enPlural != null) {
        newEntries.add(Entry(
          cardId = cardIdSequence.nextId(),
          es = pluralizeEs(entryRow.es),
          en = entryRow.enPlural,
          enDisambiguation = if (entryRow.enDisambiguation != "")
            entryRow.enDisambiguation else null
        ))
      }

      newEntries
    }
    entryByEs = entries.map { Pair(it.es, it) }.toMap()
  }
  fun byEs(es: String): Entry? = entryByEs[es]
}
