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
      if (exposure.cardId == 0) {
        throw RuntimeException("Exposure $exposure is missing cardId")
      }
      if (exposure.type == null) {
        throw RuntimeException("Exposure $exposure is missing type")
      }
      if (exposure.presentedAt == 0L) {
        throw RuntimeException("Exposure $exposure is missing presentedAt")
      }
      if (exposure.firstRespondedAt == 0L) {
        throw RuntimeException("Exposure $exposure is missing firstResponsedAt")
      }
      if ((exposure.type == ExposureType.HEAR_ES_RECALL_UNI ||
          exposure.type == ExposureType.READ_ES_RECALL_UNI) &&
          exposure.wasRecalled == null) {
        throw RuntimeException("Exposure $exposure is missing wasRecalled")
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

  private fun nowSeconds() =
      (System.currentTimeMillis() / 1000).toInt()

  private fun nowMillis() =
      System.currentTimeMillis().toLong()

  fun addExposure(exposure: Exposure) {
    exposures = exposures.plus(exposure)
  }

  fun updateNumSuccesses(cardId: Int, wasRecalled: Boolean) {
    nouns = nouns.map { noun ->
      if (noun.id == cardId) {
        if (wasRecalled) {
          noun.copy(numRepeatedSuccesses = noun.numRepeatedSuccesses + 1)
        } else {
          noun.copy(numRepeatedSuccesses = 0)
        }
      } else {
        noun
      }
    }
  }
}