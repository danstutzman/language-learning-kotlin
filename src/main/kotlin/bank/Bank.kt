package bank

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import es.EsN
import java.io.File

class Bank {
  companion object {
    fun loadFrom(file: File): Bank {
      return Gson().fromJson(file.readText(), Bank::class.java)
    }
  }

  fun saveTo(file: File) {
    val json = GsonBuilder().setPrettyPrinting().create().toJson(this)
    file.writeText(json)
  }

  var nouns = mutableSetOf<EsN>()
}