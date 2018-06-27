package com.danstutzman.bank

import com.google.gson.Gson

class GlossRows {
  companion object {
    fun expandGlossRows(glossRowsJson: String): List<GlossRow> {
      val list = try {
        Gson().fromJson(glossRowsJson, List::class.java)
      } catch (e: com.google.gson.JsonSyntaxException) {
        throw CantMakeCard("Bad glossRowsJson: ${glossRowsJson}, ${e}")
      }
      return list.map {
        val map = it as Map<*, *>
        GlossRow(
          (map.get("leafId") as Double).toInt(),
          map.get("en") as String,
          map.get("es") as String
        )
      }
    }
  }
}