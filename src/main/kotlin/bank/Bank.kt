package bank

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import es.EsN
import java.io.File
import java.util.Random

class Bank {
  companion object {
    fun loadFrom(file: File): Bank {
      val bank = Gson().fromJson(file.readText(), Bank::class.java)
      bank.errorIfInvalid()
      return bank
    }
  }

  private fun errorIfInvalid() {
    for (card in nouns) {
      if (card.id == null) {
        throw RuntimeException("Card $card is missing id")
      }
    }

    for (exposure in exposures) {
      if (exposure.cardId == null) {
        throw RuntimeException("Exposure $exposure is missing cardId")
      }
      if (exposure.type == null) {
        throw RuntimeException("Exposure $exposure is missing type")
      }
      if (exposure.time == 0) {
        throw RuntimeException("Exposure $exposure is missing time")
      }
    }
  }

  fun saveTo(file: File) {
    val json = GsonBuilder().setPrettyPrinting().create().toJson(this)
    file.writeText(json)
  }

  private var nextId = 1
  private var nouns = listOf<EsN>()
  private var exposures = listOf<Exposure>()

  fun addNoun(newNoun: EsN) {
    nouns = nouns.plus(newNoun.copy(id = nextId))
    nextId += 1
  }

  fun findCardById(id: Int): EsN {
    for (noun in nouns) {
      if (noun.id == id) {
        return noun
      }
    }
    throw RuntimeException("Couldn't find card with ID ${id}")
  }

  fun chooseRandomNoun(): EsN = nouns.get(Random().nextInt(nouns.size))

  fun listNouns() = nouns

  private fun secondsPastEpochUtc() =
      (System.currentTimeMillis() / 1000).toInt()

  fun addExposure(cardId: Int, type: ExposureType) {
    exposures = exposures.plus(Exposure(cardId, type, secondsPastEpochUtc()))
  }
}