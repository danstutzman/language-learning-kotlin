package com.danstutzman.bank

interface CardCreator {
  fun getGlossRows(): List<GlossRow>
  fun getPrompt(): String
}
