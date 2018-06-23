package com.danstutzman.bank.es

import com.danstutzman.bank.GlossRow

interface V {
  // Repeat of Card interface
  val cardId: Int
  fun getChildrenCardIds(): List<Int>
  fun getEsWords(): List<String>
  fun getKey(): String
  fun getGlossRows(): List<GlossRow>
  fun getQuizQuestion(): String

  // Unique to V
  fun getEnVerb(): String
}
