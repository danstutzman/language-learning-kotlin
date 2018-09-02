package com.danstutzman

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db
import com.danstutzman.routes.GetApi
import com.danstutzman.routes.GetCards
import com.danstutzman.routes.GetInfinitives
import com.danstutzman.routes.GetNonverbs
import com.danstutzman.routes.GetParagraph
import com.danstutzman.routes.GetParagraphs
import com.danstutzman.routes.GetRoot
import com.danstutzman.routes.GetStemChanges
import com.danstutzman.routes.GetUniqueConjugations
import com.danstutzman.routes.PostApi
import com.danstutzman.routes.PostInfinitives
import com.danstutzman.routes.PostNonverbs
import com.danstutzman.routes.PostParagraph
import com.danstutzman.routes.PostParagraphAddGoal
import com.danstutzman.routes.PostParagraphDisambiguateGoal
import com.danstutzman.routes.PostParagraphs
import com.danstutzman.routes.PostStemChanges
import com.danstutzman.routes.PostUniqueConjugations
import com.danstutzman.routes.WordDisambiguation
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response
import spark.Service
import java.io.File
import java.io.FileReader
import java.sql.DriverManager
import java.text.Normalizer

fun extractLeafIdsToDelete(req: Request): List<Int> {
  val regex = "deleteLeaf([0-9]+)".toRegex()
  return req.queryParams().map { paramName ->
    val match = regex.find(paramName)
    if (match != null) match.groupValues[1].toInt() else null
  }.filterNotNull()
}

fun extractWordDisambiguations(req: Request): List<WordDisambiguation> {
  val wordDisambiguations = mutableListOf<WordDisambiguation>()
  for (wordNum in 0..1000) {
    val interpretationNum = req.queryParams("word.${wordNum}") ?: break
    WordDisambiguation(
      req.queryParams("word.${wordNum}.${interpretationNum}.type"),
      req.queryParams("word.${wordNum}.${interpretationNum}.exists") == "true",
      req.queryParams("word.${wordNum}.${interpretationNum}.leafIds"),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.en")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.enDisambiguation")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.enPlural")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.es")))
  }
  return wordDisambiguations
}

fun normalize(s: String): String = Normalizer.normalize(s, Normalizer.Form.NFC)

fun main(args: Array<String>) {
  System.setProperty("org.jooq.no-logo", "true")

  val logger: Logger = LoggerFactory.getLogger("WebServer.kt")
  val port = 3000
  val jdbcUrl = "jdbc:postgresql://localhost:5432/language_learning_kotlin"

  val conn = DriverManager.getConnection(jdbcUrl, "postgres", "")
  val db = Db(conn)

  logger.info("Starting server port=${port}")
  val service = Service.ignite().port(port)

  service.initExceptionHandler { e ->
    e.printStackTrace()
  }

  if (true) { // if development mode
    val projectDir = System.getProperty("user.dir")
    val staticDir = "/src/main/resources/public"
    service.staticFiles.externalLocation(projectDir + staticDir)
  } else {
    service.staticFiles.location("/public")
  }

  service.get("/") { _: Request, _: Response -> GetRoot() }
  service.get("/cards") { _: Request, _: Response -> GetCards(db) }
  service.get("/infinitives") { _: Request, _: Response -> GetInfinitives(db) }
  service.post("/infinitives") { req: Request, res: Response ->
    PostInfinitives(db, extractLeafIdsToDelete(req),
      req.queryParams("newInfinitive") != null,
      normalize(req.queryParams("en")),
      normalize(req.queryParams("en_disambiguation")),
      normalize(req.queryParams("en_past")),
      normalize(req.queryParams("es_mixed")))
    res.redirect("/infinitives")
  }
  service.get("/nonverbs") { _: Request, _: Response -> GetNonverbs(db) }
  service.post("/nonverbs") { req: Request, res: Response ->
    PostNonverbs(db, extractLeafIdsToDelete(req),
      req.queryParams("newNonverb") != null, 
      normalize(req.queryParams("en")),
      normalize(req.queryParams("en_disambiguation")),
      normalize(req.queryParams("en_plural")),
      normalize(req.queryParams("es_mixed")))
    res.redirect("/nonverbs")
  }
  service.get("/paragraphs") { _: Request, _: Response -> GetParagraphs(db) }
  service.post("/paragraphs") { req: Request, res: Response ->
    val topic = normalize(req.queryParams("topic"))
    val enabled = req.queryParams("enabled") != null
    PostParagraphs(db, topic, enabled)
    res.redirect("/paragraphs")
  }
  service.get("/paragraphs/:paragraphId") { req: Request, _: Response ->
    val paragraphId = req.params("paragraphId")!!.toInt()
    GetParagraph(db, paragraphId)
  }
  service.post("/paragraphs/:paragraphId") { req: Request, res: Response ->
    val paragraphId = req.params("paragraphId").toInt()
    PostParagraph(db, paragraphId, req.queryParams("submit"),
      req.queryParams("topic"), req.queryParams("enabled") != null)
    res.redirect("/paragraphs/${paragraphId}")
  }
  service.post("/paragraphs/:paragraphId/disambiguate-goal") {
    req: Request, _: Response ->
    PostParagraphDisambiguateGoal(db, req.params("paragraphId").toInt(),
      normalize(req.queryParams("en")!!), normalize(req.queryParams("es")!!))
  }
  service.post("/paragraphs/:paragraphId/add-goal") {
    req: Request, res: Response ->
    val paragraphId = req.params("paragraphId").toInt()
    PostParagraphAddGoal(db, paragraphId, normalize(req.queryParams("en")!!),
      normalize(req.queryParams("es")!!), extractWordDisambiguations(req))
    res.redirect("/paragraphs/${paragraphId}")
  }
  service.get("/stem-changes") { _: Request, _: Response -> GetStemChanges(db) }
  service.post("/stem-changes") { req: Request, res: Response ->
    PostStemChanges(db, extractLeafIdsToDelete(req),
      req.queryParams("newStemChange") != null,
      normalize(req.queryParams("infinitive_es_mixed"))!!,
      normalize(req.queryParams("es_mixed")),
      req.queryParams("tense"),
      normalize(req.queryParams("en")),
      normalize(req.queryParams("en_past")),
      normalize(req.queryParams("en_disambiguation")))
    res.redirect("/stem-changes")
  }
  service.get("/unique-conjugations") { _: Request, _: Response ->
    GetUniqueConjugations(db) }
  service.post("/unique-conjugations") { req: Request, res: Response ->
    PostUniqueConjugations(db, extractLeafIdsToDelete(req),
      req.queryParams("newUniqueConjugation") != null,
      normalize(req.queryParams("infinitive_es_mixed")),
      normalize(req.queryParams("es_mixed")),
      normalize(req.queryParams("en")),
      req.queryParams("number").toInt(),
      req.queryParams("person").toInt(),
      req.queryParams("tense"),
      normalize(req.queryParams("en_disambiguation")))
    res.redirect("/unique-conjugations")
  }
  service.get("/api") { _: Request, res: Response ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    GetApi(db)
  }
  service.post("/api") { req: Request, res: Response ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    PostApi(db, req.body())
  }
  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
