package com.danstutzman.bank

interface CardCreator {
  fun explainDerivation(): String
  fun getChildCardCreators(): List<CardCreator>
  fun getGlossRows(): List<GlossRow>
  fun getPrompt(): String
  fun serializeLeafIds(): String
}
