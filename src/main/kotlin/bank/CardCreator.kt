package com.danstutzman.bank

interface CardCreator {
  fun getChildCardCreators(): List<CardCreator>
  fun getGlossRows(): List<GlossRow>
  fun getPrompt(): String
}
