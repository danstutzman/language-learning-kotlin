package com.danstutzman.routes

import com.danstutzman.bank.Bank
import com.danstutzman.bank.GlossRow
import com.danstutzman.db.CardUpdate
import com.danstutzman.db.Db
import com.google.gson.Gson

data class CardsUpload(
  val cards: List<CardUpload>
)

data class CardUpload (
  val cardId: Int,
  val glossRows: List<GlossRow>,
  val mnemonic: String,
  val lastSeenAt: Int?,
  val stage: Int
)

fun PostApi(db: Db, body: String): String {
  val cardsUpload = Gson().fromJson(body, CardsUpload::class.java)
  val bank = Bank(db)
  bank.saveCardUpdates(cardsUpload.cards.map {
    CardUpdate(
      cardId = it.cardId,
      lastSeenAt = it.lastSeenAt,
      mnemonic = it.mnemonic,
      stage = it.stage)
  })
  return "{}"
}