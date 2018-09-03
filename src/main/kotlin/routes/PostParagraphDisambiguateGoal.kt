package com.danstutzman.routes

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db

fun PostParagraphDisambiguateGoal(db: Db, lang: String, paragraphId: Int,
  en: String, l2: String): String {
  val bank = Bank(db)
  val words = bank.splitL2Phrase(lang, l2)
  val interpretationsByWordNum = words.map { bank.interpretL2Word(lang, it) }

  return com.danstutzman.templates.PostParagraphDisambiguateGoal(
    lang, paragraphId, en, l2, words, interpretationsByWordNum)
}