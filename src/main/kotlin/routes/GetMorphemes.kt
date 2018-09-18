package com.danstutzman.routes

import com.danstutzman.db.Db

fun GetMorphemes(db: Db, lang: String): String {
  val morphemes = db.morphemesTable.selectByLang(lang)
  return com.danstutzman.templates.GetMorphemes(lang, morphemes)
}