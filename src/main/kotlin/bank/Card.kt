package com.danstutzman.bank

interface Card {
  val cardId: Int
  fun getChildrenCards(): List<Card>
  fun getEsWords(): List<String>
  fun getKey(): String
  fun getGlossRows(): List<GlossRow>
  fun getQuizQuestion(): String
}
