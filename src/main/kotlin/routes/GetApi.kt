package com.danstutzman.routes

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db
import com.google.gson.GsonBuilder

fun GetApi(db: Db, lang: String): String {
  val bank = Bank(db)
  val response = bank.getCardDownloads(lang)
  return GsonBuilder().serializeNulls().create().toJson(response)
}