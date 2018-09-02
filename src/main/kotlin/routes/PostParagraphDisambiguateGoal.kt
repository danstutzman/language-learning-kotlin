package com.danstutzman.routes

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db

fun PostParagraphDisambiguateGoal(db: Db, paragraphId: Int, en: String,
  es: String): String {
  val bank = Bank(db)
  val words = bank.splitEsPhrase(es)
  val interpretationsByWordNum = words.map { bank.interpretEsWord(it) }

  return com.danstutzman.templates.PostParagraphDisambiguateGoal(
    paragraphId, en, es, words, interpretationsByWordNum)
}