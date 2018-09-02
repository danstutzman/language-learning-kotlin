package com.danstutzman.routes

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db
import com.google.gson.GsonBuilder

fun GetApi(db: Db): String {
  val bank = Bank(db)
  val response = bank.getCardDownloads()
  return GsonBuilder().serializeNulls().create().toJson(response)
}