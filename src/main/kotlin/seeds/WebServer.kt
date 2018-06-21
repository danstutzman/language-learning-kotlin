package seeds

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import db.Db
import java.io.File
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Service

val logger: Logger = LoggerFactory.getLogger("seeds/WebServer.kt")

val DELAY_THRESHOLD = 10000

val skillsExportFile = File("./skillsExport.json")

data class GlossRow (
  val cardId: Int,
  val en: String,
  val es: String
) {}

interface Card {
  val cardId: Int
  fun getChildrenCardIds(): List<Int>
  fun getEsWords(): List<String>
  fun getKey(): String
  fun getGlossRows(): List<GlossRow>
  fun getQuizQuestion(): String
}

data class CardRow(
  val cardId: Int,
  val type: String,
  val key: String,
  val childrenCardIds: List<Int>,
  val glossRows: List<GlossRow>,
  val esWords: List<String>,
  val quizQuestion: String
) {}

data class SkillRow(
  val cardId: Int,
  val delay: Int,
  val endurance: Int,
  val lastSeenAt: Int,
  val mnemonic: String
) {}

fun handleGet(req: spark.Request, res: spark.Response): String {
  var nextCardId = 1

  val infs = listOf(
    Inf(0, "preguntar", "ask", "asked"),
    Inf(0, "comer", "eat", "ate")
  ).map { it.copy(cardId = nextCardId++) }
  val infByEs = infs.map { Pair(it.es, it) }.toMap()

  val regVPatterns = listOf(
    RegVPattern(0, InfCategory.AR, 1, 1, Tense.PRES, "-o"),
    RegVPattern(0, InfCategory.AR, 1, 3, Tense.PRES, "-a"),
    RegVPattern(0, InfCategory.ER, 1, 1, Tense.PRES, "-o"),
    RegVPattern(0, InfCategory.ER, 1, 3, Tense.PRES, "-e"),
    RegVPattern(0, InfCategory.AR, 1, 1, Tense.PRET, "-é"),
    RegVPattern(0, InfCategory.AR, 1, 3, Tense.PRET, "-ó")
  ).map { it.copy(cardId = nextCardId++) }
  val regVPatternByKey = regVPatterns.map { Pair(it.getKey(), it) }.toMap()

  val regVs = listOf(
    RegV(0, infByEs["preguntar"]!!, regVPatternByKey["AR11PRES"]!!),
    RegV(0, infByEs["preguntar"]!!, regVPatternByKey["AR13PRES"]!!),
    RegV(0, infByEs["comer"]!!,     regVPatternByKey["ER11PRES"]!!),
    RegV(0, infByEs["comer"]!!,     regVPatternByKey["ER13PRES"]!!),
    RegV(0, infByEs["preguntar"]!!, regVPatternByKey["AR11PRET"]!!),
    RegV(0, infByEs["preguntar"]!!, regVPatternByKey["AR13PRET"]!!)
  ).map { it.copy(cardId = nextCardId++) }
  val regVByKey = regVs.map { Pair(it.getKey(), it) }.toMap()

  val dets = listOf(
    Det(0, "el",   "the",   Gender.M),
    Det(0, "la",   "the",   Gender.F),
    Det(0, "un",   "a",     Gender.M),
    Det(0, "una",  "a",     Gender.F),
    Det(0, "mi",   "my",    null),
    Det(0, "este", "this",  Gender.M),
    Det(0, "esta", "this",  Gender.F),
    Det(0, "cada", "every", null)
  ).map { it.copy(cardId = nextCardId++) }
  val detByEs = dets.map { Pair(it.es, it) }.toMap()

  val ns = listOf(
    N(0, "brazo", "arm", Gender.M),
    N(0, "pierna", "leg", Gender.F),
    N(0, "corazón", "heart", Gender.M),
    N(0, "estómago", "stomach", Gender.M),
    N(0, "ojo", "eye", Gender.M),
    N(0, "nariz", "nose", Gender.F),
    N(0, "boca", "mouth", Gender.F),
    N(0, "oreja", "ear", Gender.F),
    N(0, "cara", "face", Gender.F),
    N(0, "cuello", "neck", Gender.M),
    N(0, "dedo", "finger", Gender.M),
    N(0, "pie", "foot", Gender.M),
    N(0, "muslo", "thigh", Gender.M),
    N(0, "tobillo", "ankle", Gender.M),
    N(0, "codo", "elbow", Gender.M),
    N(0, "muñeca", "wrist", Gender.F),
    N(0, "cuerpo", "body", Gender.M),
    N(0, "diente", "tooth", Gender.M),
    N(0, "mano", "hand", Gender.F),
    N(0, "espalda", "back", Gender.F),
    N(0, "cadera", "hip", Gender.F),
    N(0, "mandíbula", "jaw", Gender.F),
    N(0, "hombro", "shoulder", Gender.M),
    N(0, "pulgar", "thumb", Gender.M),
    N(0, "lengua", "tongue", Gender.F),
    N(0, "garganta", "throat", Gender.F)
  ).map { it.copy(cardId = nextCardId++) }
  val nByEs = ns.map { Pair(it.es, it) }.toMap()

  val nps = listOf(
    NP(0, "yo", "I")
  ).map { it.copy(cardId = nextCardId++) }
  val npByEs = nps.map { Pair(it.es, it) }.toMap()

  val iClauses = listOf(
    IClause(0, nps[0], regVByKey["comerER11PRES"]!!)
  ).map { it.copy(cardId = nextCardId++) }
  val iClauseByKey = iClauses.map { Pair(it.getKey(), it) }.toMap()

  val cards = infs + regVPatterns + regVs + ns + dets + nps + iClauses
  val cardRows = cards.map {
    val type = it.javaClass.name.split('.').last()
    CardRow(
      it.cardId,
      type,
      it.getKey(),
      it.getChildrenCardIds(),
      it.getGlossRows(),
      it.getEsWords(),
      it.getQuizQuestion()
    )
  }

  val skillsExport: SkillsExport = Gson()
    .fromJson(skillsExportFile.readText(), SkillsExport::class.java)
  val skillRowByCardId = skillsExport.skillExports.map {
    val card = when (it.cardType) {
      "IClause"     -> iClauseByKey[it.cardKey]!!
      "Inf"         -> infByEs[it.cardKey]!!
      "NP"          -> npByEs[it.cardKey]!!
      "RegV"        -> regVByKey[it.cardKey]!!
      "RegVPattern" -> regVPatternByKey[it.cardKey]!!
      else -> throw RuntimeException("Unexpected cardType ${it.cardType}")
    }
    Pair(card.cardId, SkillRow(
      card.cardId,
      it.delay,
      it.endurance,
      it.lastSeenAt,
      it.mnemonic
    ))
  }.toMap()

  val skillRows = cards.map {
    skillRowByCardId[it.cardId] ?: SkillRow(
      it.cardId,
      if (it.getChildrenCardIds().size == 0)
        DELAY_THRESHOLD else DELAY_THRESHOLD * 2,
      0,
      0,
      ""
    )
  }

  val response = linkedMapOf(
    "cards" to cardRows,
    "skills" to skillRows
  )

  res.header("Access-Control-Allow-Origin", "*")
  res.header("Content-Type", "application/json")
  return GsonBuilder().setPrettyPrinting().create().toJson(response)
}

data class SkillsUpload(
  val skillExports: List<SkillExport>?
) {}

data class SkillExport(
  val cardType: String,
  val cardKey: String,
  val delay: Int,
  val endurance: Int,
  val lastSeenAt: Int,
  val mnemonic: String
) {}

data class SkillsExport(
  val skillExports: List<SkillExport>
) {}

fun handlePost(req: spark.Request, res: spark.Response): String {
  val skillsUpload = Gson().fromJson(req.body(), SkillsUpload::class.java)
  if (skillsUpload.skillExports == null) {
    res.status(400)
    return "{\"errors\":[\"Missing skillExports\"]}"
  }

  skillsExportFile.writeText(GsonBuilder().setPrettyPrinting().create().toJson(
    SkillsExport(skillsUpload.skillExports)))

  return "{}"
}

fun main(args: Array<String>) {
  System.setProperty("org.jooq.no-logo", "true")

  val port = 3000
  logger.info("Starting server port=${port}")
  val service = Service.ignite().port(port)

  service.initExceptionHandler { e ->
    e.printStackTrace()
  }

  service.get("/", ::handleGet)
  service.post("/", ::handlePost)

  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
