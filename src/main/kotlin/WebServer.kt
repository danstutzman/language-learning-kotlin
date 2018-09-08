package com.danstutzman

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db
import com.danstutzman.routes.GetApi
import com.danstutzman.routes.GetArNonverbs
import com.danstutzman.routes.GetArNouns
import com.danstutzman.routes.GetArStemChanges
import com.danstutzman.routes.GetArUniqueConjugations
import com.danstutzman.routes.GetArVerbRoots
import com.danstutzman.routes.GetEsInfinitives
import com.danstutzman.routes.GetEsNonverbs
import com.danstutzman.routes.GetEsStemChanges
import com.danstutzman.routes.GetEsUniqueConjugations
import com.danstutzman.routes.GetFrInfinitives
import com.danstutzman.routes.GetFrNonverbs
import com.danstutzman.routes.GetFrStemChanges
import com.danstutzman.routes.GetFrUniqueConjugations
import com.danstutzman.routes.GetParagraph
import com.danstutzman.routes.GetParagraphs
import com.danstutzman.routes.GetRoot
import com.danstutzman.routes.PostApi
import com.danstutzman.routes.PostArNonverbs
import com.danstutzman.routes.PostArNouns
import com.danstutzman.routes.PostArStemChanges
import com.danstutzman.routes.PostArUniqueConjugations
import com.danstutzman.routes.PostArVerbRoots
import com.danstutzman.routes.PostEsInfinitives
import com.danstutzman.routes.PostEsNonverbs
import com.danstutzman.routes.PostEsStemChanges
import com.danstutzman.routes.PostEsUniqueConjugations
import com.danstutzman.routes.PostFrInfinitives
import com.danstutzman.routes.PostFrNonverbs
import com.danstutzman.routes.PostFrStemChanges
import com.danstutzman.routes.PostFrUniqueConjugations
import com.danstutzman.routes.PostParagraph
import com.danstutzman.routes.PostParagraphAddGoal
import com.danstutzman.routes.PostParagraphDisambiguateGoal
import com.danstutzman.routes.PostParagraphs
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
    wordDisambiguations.add(WordDisambiguation(
      req.queryParams("word.${wordNum}.${interpretationNum}.type")!!,
      req.queryParams("word.${wordNum}.${interpretationNum}.exists")!! =="true",
      req.queryParams("word.${wordNum}.${interpretationNum}.leafIds"),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.en")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.enDisambiguation")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.enPlural")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.es")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.frMixed")),
      normalize(req.queryParams("word.${wordNum}.${interpretationNum}.arBuckwalter"))
    ))
  }
  return wordDisambiguations
}

fun normalize(s: String?): String? =
  if (s == null) null else Normalizer.normalize(s, Normalizer.Form.NFC)

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

  service.get("/es/infinitives") { _: Request, _: Response ->
    GetEsInfinitives(db) }
  service.post("/es/infinitives") { req: Request, res: Response ->
    PostEsInfinitives(db, extractLeafIdsToDelete(req),
      req.queryParams("newInfinitive") != null,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("en_disambiguation"))!!,
      normalize(req.queryParams("en_past"))!!,
      normalize(req.queryParams("es_mixed"))!!)
    res.redirect("/es/infinitives")
  }
  service.get("/fr/infinitives") { _: Request, _: Response ->
    GetFrInfinitives(db) }
  service.post("/fr/infinitives") { req: Request, res: Response ->
    PostFrInfinitives(db, extractLeafIdsToDelete(req),
      req.queryParams("newInfinitive") != null,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("en_past"))!!,
      normalize(req.queryParams("fr_mixed"))!!)
    res.redirect("/fr/infinitives")
  }

  service.get("/ar/nonverbs") { _: Request, _: Response -> GetArNonverbs(db) }
  service.post("/ar/nonverbs") { req: Request, res: Response ->
    PostArNonverbs(db, extractLeafIdsToDelete(req),
      req.queryParams("newNonverb") != null,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("ar_buckwalter"))!!)
    res.redirect("/ar/nonverbs")
  }
  service.get("/es/nonverbs") { _: Request, _: Response -> GetEsNonverbs(db) }
  service.post("/es/nonverbs") { req: Request, res: Response ->
    PostEsNonverbs(db, extractLeafIdsToDelete(req),
      req.queryParams("newNonverb") != null, 
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("en_disambiguation"))!!,
      normalize(req.queryParams("en_plural"))!!,
      normalize(req.queryParams("es_mixed"))!!)
    res.redirect("/es/nonverbs")
  }
  service.get("/fr/nonverbs") { _: Request, _: Response -> GetFrNonverbs(db) }
  service.post("/fr/nonverbs") { req: Request, res: Response ->
    PostFrNonverbs(db, extractLeafIdsToDelete(req),
      req.queryParams("newNonverb") != null, 
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("fr_mixed"))!!)
    res.redirect("/fr/nonverbs")
  }

  service.get("/ar/nouns") { _: Request, _: Response -> GetArNouns(db) }
  service.post("/ar/nouns") { req: Request, res: Response ->
    PostArNouns(db, extractLeafIdsToDelete(req),
      req.queryParams("newNoun") != null,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("ar_buckwalter"))!!,
      req.queryParams("gender")!!)
    res.redirect("/ar/nouns")
  }

  service.get("/:lang/paragraphs") { req: Request, _: Response ->
    val lang = req.params("lang")!!
    GetParagraphs(db, lang)
  }
  service.post("/:lang/paragraphs") { req: Request, res: Response ->
    val lang = req.params("lang")!!
    val topic = normalize(req.queryParams("topic"))!!
    val enabled = req.queryParams("enabled") != null
    PostParagraphs(db, lang, topic, enabled)
    res.redirect("/${lang}/paragraphs")
  }

  service.get("/:lang/paragraphs/:paragraphId") { req: Request, _: Response ->
    val lang = req.params("lang")!!
    val paragraphId = req.params("paragraphId")!!.toInt()
    GetParagraph(db, lang, paragraphId)
  }
  service.post("/:lang/paragraphs/:paragraphId") { req: Request, res: Response ->
    val lang = req.params("lang")!!
    val paragraphId = req.params("paragraphId").toInt()
    PostParagraph(db, paragraphId, req.queryParams("submit"), lang,
      req.queryParams("topic"), req.queryParams("enabled") != null)
    res.redirect("/${lang}/paragraphs/${paragraphId}")
  }
  service.post("/:lang/paragraphs/:paragraphId/disambiguate-goal") {
    req: Request, _: Response ->
    val lang = req.params("lang")!!
    PostParagraphDisambiguateGoal(db, lang, req.params("paragraphId")!!.toInt(),
      normalize(req.queryParams("en"))!!, normalize(req.queryParams("l2"))!!)
  }
  service.post("/:lang/paragraphs/:paragraphId/add-goal") {
    req: Request, res: Response ->
    val lang = req.params("lang")!!
    val paragraphId = req.params("paragraphId")!!.toInt()
    PostParagraphAddGoal(db, lang, paragraphId,
      normalize(req.queryParams("en"))!!, normalize(req.queryParams("l2"))!!,
      extractWordDisambiguations(req))
    res.redirect("/${lang}/paragraphs/${paragraphId}")
  }

  service.get("/ar/stem-changes") { _: Request, _: Response ->
    GetArStemChanges(db) }
  service.post("/ar/stem-changes") { req: Request, res: Response ->
    PostArStemChanges(db, extractLeafIdsToDelete(req),
      req.queryParams("newStemChange") != null,
      normalize(req.queryParams("root_ar_buckwalter"))!!,
      normalize(req.queryParams("ar_buckwalter"))!!,
      req.queryParams("tense")!!,
      normalize(req.queryParams("en"))!!,
      req.queryParams("persons_csv")!!)
    res.redirect("/ar/stem-changes")
  }
  service.get("/es/stem-changes") { _: Request, _: Response ->
    GetEsStemChanges(db) }
  service.post("/es/stem-changes") { req: Request, res: Response ->
    PostEsStemChanges(db, extractLeafIdsToDelete(req),
      req.queryParams("newStemChange") != null,
      normalize(req.queryParams("infinitive_es_mixed"))!!,
      normalize(req.queryParams("es_mixed"))!!,
      req.queryParams("tense")!!,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("en_past"))!!,
      normalize(req.queryParams("en_disambiguation"))!!)
    res.redirect("/es/stem-changes")
  }
  service.get("/fr/stem-changes") { _: Request, _: Response ->
    GetFrStemChanges(db) }
  service.post("/fr/stem-changes") { req: Request, res: Response ->
    PostFrStemChanges(db, extractLeafIdsToDelete(req),
      req.queryParams("newStemChange") != null,
      normalize(req.queryParams("infinitive_fr_mixed"))!!,
      normalize(req.queryParams("fr_mixed"))!!,
      req.queryParams("tense")!!,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("en_past"))!!)
    res.redirect("/fr/stem-changes")
  }

  service.get("/ar/unique-conjugations") { _: Request, _: Response ->
    GetArUniqueConjugations(db) }
  service.post("/ar/unique-conjugations") { req: Request, res: Response ->
    PostArUniqueConjugations(db, extractLeafIdsToDelete(req),
      req.queryParams("newUniqueConjugation") != null,
      normalize(req.queryParams("root_ar_buckwalter"))!!,
      normalize(req.queryParams("ar_buckwalter"))!!,
      normalize(req.queryParams("en"))!!,
      req.queryParams("gender")!!,
      req.queryParams("number")!!.toInt(),
      req.queryParams("person")!!.toInt(),
      req.queryParams("tense")!!)
    res.redirect("/ar/unique-conjugations")
  }
  service.get("/es/unique-conjugations") { _: Request, _: Response ->
    GetEsUniqueConjugations(db) }
  service.post("/es/unique-conjugations") { req: Request, res: Response ->
    PostEsUniqueConjugations(db, extractLeafIdsToDelete(req),
      req.queryParams("newUniqueConjugation") != null,
      normalize(req.queryParams("infinitive_es_mixed"))!!,
      normalize(req.queryParams("es_mixed"))!!,
      normalize(req.queryParams("en"))!!,
      req.queryParams("number")!!.toInt(),
      req.queryParams("person")!!.toInt(),
      req.queryParams("tense")!!,
      normalize(req.queryParams("en_disambiguation"))!!)
    res.redirect("/es/unique-conjugations")
  }
  service.get("/fr/unique-conjugations") { _: Request, _: Response ->
    GetFrUniqueConjugations(db) }
  service.post("/fr/unique-conjugations") { req: Request, res: Response ->
    PostFrUniqueConjugations(db, extractLeafIdsToDelete(req),
      req.queryParams("newUniqueConjugation") != null,
      normalize(req.queryParams("infinitive_fr_mixed"))!!,
      normalize(req.queryParams("fr_mixed"))!!,
      normalize(req.queryParams("en"))!!,
      req.queryParams("number")!!.toInt(),
      req.queryParams("person")!!.toInt(),
      req.queryParams("tense")!!)
    res.redirect("/fr/unique-conjugations")
  }

  service.get("/ar/verb-roots") { _: Request, _: Response ->
    GetArVerbRoots(db) }
  service.post("/ar/verb-roots") { req: Request, res: Response ->
    PostArVerbRoots(db, extractLeafIdsToDelete(req),
      req.queryParams("newVerbRoot") != null,
      normalize(req.queryParams("en"))!!,
      normalize(req.queryParams("en_past"))!!,
      normalize(req.queryParams("ar_buckwalter"))!!,
      normalize(req.queryParams("ar_pres_middle_vowel_buckwalter"))!!)
    res.redirect("/ar/verb-roots")
  }

  service.get("/es/api") { _: Request, res: Response ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    GetApi(db, "es")
  }
  service.post("/es/api") { req: Request, res: Response ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    PostApi(db, req.body())
  }
  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
