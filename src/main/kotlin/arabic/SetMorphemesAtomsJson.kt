package com.danstutzman.arabic

import com.danstutzman.db.Db
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.sql.DriverManager

fun computeAtomsJson(morpheme: String): String {
  val match1 = "^-".toRegex().find(morpheme)
  val beginsWithHyphen = (match1 != null)
  val match2 = "-$".toRegex().find(morpheme)
  val endsWithHyphen = (match2 != null)
  val stripped = morpheme
    .replace("^-".toRegex(), "")
    .replace("-$".toRegex(), "")

  val atomAlignments =
    ConvertMorphemeToBuckwalter.convertMorphemeToBuckwalter(
      stripped, beginsWithHyphen, endsWithHyphen)
  return GsonBuilder().serializeNulls().create().toJson(atomAlignments)
}

fun main(args: Array<String>) { 
  System.setProperty("org.jooq.no-logo", "true")

  val jdbcUrl = "jdbc:postgresql://localhost:5432/language_learning_kotlin"
  val conn = DriverManager.getConnection(jdbcUrl, "postgres", "")
  val db = Db(conn)

  val morphemes = db.morphemesTable.selectByLang("ar")
  for (morpheme in morphemes) {
    println(morpheme.l2)
    val atomsJson = computeAtomsJson(morpheme.l2)
    db.morphemesTable.updateAtomsJson(morpheme.morphemeId, atomsJson)
  }
}