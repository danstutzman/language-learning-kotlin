package com.danstutzman.seeds

interface Card {
  val cardId: Int
  fun getChildrenCardIds(): List<Int>
  fun getEsWords(): List<String>
  fun getKey(): String
  fun getGlossRows(): List<GlossRow>
  fun getQuizQuestion(): String
}
