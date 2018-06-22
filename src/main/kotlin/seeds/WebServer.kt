package seeds

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import db.Db
import java.io.File
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Service

val logger: Logger = LoggerFactory.getLogger("seeds/WebServer.kt")

val DELAY_THRESHOLD = 100000

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

val cardIdSequence  = IdSequence()
val infList         = InfList(cardIdSequence)
val regVPatternList = RegVPatternList(cardIdSequence)
val nList           = NList(cardIdSequence)
val detList         = DetList(cardIdSequence)
val uniqVList       = UniqVList(cardIdSequence, infList)
val npList          = NPList(cardIdSequence)
var nextCardId      = cardIdSequence.nextId()

val regVs = listOf(
  RegV(0, infList.byKey("preguntar"), regVPatternList.byKey("AR11PRES")),
  RegV(0, infList.byKey("preguntar"), regVPatternList.byKey("AR13PRES")),
  RegV(0, infList.byKey("comer"),     regVPatternList.byKey("ER11PRES")),
  RegV(0, infList.byKey("comer"),     regVPatternList.byKey("ER13PRES")),
  RegV(0, infList.byKey("preguntar"), regVPatternList.byKey("AR11PRET")),
  RegV(0, infList.byKey("preguntar"), regVPatternList.byKey("AR13PRET"))
).map { it.copy(cardId = nextCardId++) }
val regVByKey = regVs.map { Pair(it.getKey(), it) }.toMap()
val regVByQuestion =
  Assertions.assertUniqKeys(regVs.map { Pair(it.getQuizQuestion(), it) })

val iClauses = listOf(
  IClause(0, npList.byEs("yo"), regVByKey["comerER11PRES"]!!)
).map { it.copy(cardId = nextCardId++) }
val iClauseByKey = iClauses.map { Pair(it.getKey(), it) }.toMap()
val iClauseByQuestion =
  Assertions.assertUniqKeys(iClauses.map { Pair(it.getQuizQuestion(), it) })

val cards = infList.infs +
  regVPatternList.regVPatterns +
  nList.ns +
  detList.dets +
  uniqVList.uniqVs +
  npList.nps +
  regVs +
  iClauses
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

fun handleGet(
  @Suppress("UNUSED_PARAMETER") req: spark.Request,
  res: spark.Response
): String {
  val skillsExport: SkillsExport = Gson()
    .fromJson(skillsExportFile.readText(), SkillsExport::class.java)
  val skillRowByCardId = skillsExport.skillExports.map {
    val card = when (it.cardType) {
      "Det"         -> detList.byEs(it.cardKey)
      "IClause"     -> iClauseByKey[it.cardKey]!!
      "Inf"         -> infList.byKey(it.cardKey)
      "N"           -> nList.byEs(it.cardKey)
      "NP"          -> npList.byEs(it.cardKey)
      "RegV"        -> regVByKey[it.cardKey]!!
      "RegVPattern" -> regVPatternList.byKey(it.cardKey)
      "UniqV"       -> uniqVList.byKey(it.cardKey)
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
