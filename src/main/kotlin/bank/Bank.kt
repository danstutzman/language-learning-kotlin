package bank

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import es.EsN
import java.io.File

class Bank {
  companion object {
    fun loadFrom(file: File): Bank {
      val bank = Gson().fromJson(file.readText(), Bank::class.java)
      for (card in bank.nouns) {
        if (card.id == null) {
          throw RuntimeException("Card $card is missing id")
        }
      }
      return bank
    }
  }

  fun saveTo(file: File) {
    val json = GsonBuilder().setPrettyPrinting().create().toJson(this)
    file.writeText(json)
  }

  var nextId = 1
  var nouns = listOf<EsN>()

  fun addNoun(newNoun: EsN) {
    nouns = nouns.plus(newNoun.copy(id = nextId))
    nextId += 1
  }
}