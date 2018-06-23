package com.danstutzman.bank

interface Card {
  val cardId: Int
  fun getChildrenCards(): List<Card>
  fun getKey(): String
  fun getGlossRows(): List<GlossRow>
}
