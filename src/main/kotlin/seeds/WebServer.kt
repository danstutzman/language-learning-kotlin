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
var nextCardId      = cardIdSequence.nextId()

val regVs = listOf(
  RegV(0, infList.byEs("preguntar"), regVPatternList.byKey("AR11PRES")),
  RegV(0, infList.byEs("preguntar"), regVPatternList.byKey("AR13PRES")),
  RegV(0, infList.byEs("comer"),     regVPatternList.byKey("ER11PRES")),
  RegV(0, infList.byEs("comer"),     regVPatternList.byKey("ER13PRES")),
  RegV(0, infList.byEs("preguntar"), regVPatternList.byKey("AR11PRET")),
  RegV(0, infList.byEs("preguntar"), regVPatternList.byKey("AR13PRET"))
).map { it.copy(cardId = nextCardId++) }
val regVByKey = regVs.map { Pair(it.getKey(), it) }.toMap()
val regVByQuestion =
  Assertions.assertUniqKeys(regVs.map { Pair(it.getQuizQuestion(), it) })

val uniqVs = listOf(
  UniqV(0, "soy",       "am",   infList.byEs("ser"),     1, 1, Tense.PRES,
    "what"),
  UniqV(0, "eres",      "are",  infList.byEs("ser"),     1, 2, Tense.PRES,
    "what"),
  UniqV(0, "es",        "is",   infList.byEs("ser"),     1, 3, Tense.PRES,
    "what"),
  UniqV(0, "somos",     "are",  infList.byEs("ser"),     2, 1, Tense.PRES,
    "what"),
  UniqV(0, "son",       "are",  infList.byEs("ser"),     2, 3, Tense.PRES,
    "what"),
  UniqV(0, "fui",       "was",  infList.byEs("ser"),     1, 1, Tense.PRET,
    "what"),
  UniqV(0, "fuiste",    "were", infList.byEs("ser"),     1, 2, Tense.PRET,
    "what"),
  UniqV(0, "fue",       "was",  infList.byEs("ser"),     1, 3, Tense.PRET,
    "what"),
  UniqV(0, "fuimos",    "were", infList.byEs("ser"),     2, 1, Tense.PRET,
    "what"),
  UniqV(0, "fueron",    "were", infList.byEs("ser"),     2, 3, Tense.PRET,
    "what"),
  UniqV(0, "estoy",     "am",   infList.byEs("estar"),   1, 1, Tense.PRES,
    "how"),
  UniqV(0, "estás",     "are",  infList.byEs("estar"),   1, 2, Tense.PRES,
    "how"),
  UniqV(0, "está",      "is",   infList.byEs("estar"),   1, 3, Tense.PRES,
    "how"),
  UniqV(0, "están",     "are",  infList.byEs("estar"),   2, 3, Tense.PRES,
    "how"),
  UniqV(0, "tengo",     "have", infList.byEs("tener"),   1, 1, Tense.PRES,
    null),
  UniqV(0, "hago",      "do",   infList.byEs("hacer"),   1, 1, Tense.PRES,
    null),
  UniqV(0, "digo",      "say",  infList.byEs("decir"),   1, 1, Tense.PRES,
    null),
  UniqV(0, "dijeron",   "said", infList.byEs("decir"),   2, 3, Tense.PRET,
    null),
  UniqV(0, "voy",       "go",   infList.byEs("ir"),      1, 1, Tense.PRES,
    null),
  UniqV(0, "vas",       "go",   infList.byEs("ir"),      1, 2, Tense.PRES,
    null),
  UniqV(0, "va",        "goes", infList.byEs("ir"),      1, 3, Tense.PRES,
    null),
  UniqV(0, "vamos",     "go",   infList.byEs("ir"),      2, 1, Tense.PRES,
    null),
  UniqV(0, "van",       "go",   infList.byEs("ir"),      2, 3, Tense.PRES,
    null),
  UniqV(0, "fui",       "went", infList.byEs("ir"),      1, 1, Tense.PRET,
    null),
  UniqV(0, "fuiste",    "went", infList.byEs("ir"),      1, 2, Tense.PRET,
    null),
  UniqV(0, "fue",       "went", infList.byEs("ir"),      1, 3, Tense.PRET,
    null),
  UniqV(0, "fuimos",    "went", infList.byEs("ir"),      2, 1, Tense.PRET,
    null),
  UniqV(0, "fueron",    "went", infList.byEs("ir"),      2, 3, Tense.PRET,
    null),
  UniqV(0, "veo",       "see",  infList.byEs("ver"),     1, 1, Tense.PRES,
    null),
  UniqV(0, "vi",        "saw",  infList.byEs("ver"),     1, 1, Tense.PRET,
    null),
  UniqV(0, "vio",       "saw",  infList.byEs("ver"),     1, 3, Tense.PRET,
    null),
  UniqV(0, "vimos",     "saw",  infList.byEs("ver"),     2, 1, Tense.PRET,
    null),
  UniqV(0, "doy",       "give", infList.byEs("dar"),     1, 1, Tense.PRES,
    null),
  UniqV(0, "di",        "gave", infList.byEs("dar"),     1, 1, Tense.PRET,
    null),
  UniqV(0, "diste",     "gave", infList.byEs("dar"),     1, 2, Tense.PRET,
    null),
  UniqV(0, "dio",       "gave", infList.byEs("dar"),     1, 3, Tense.PRET,
    null),
  UniqV(0, "dimos",     "gave", infList.byEs("dar"),     2, 1, Tense.PRET,
    null),
  UniqV(0, "dieron",    "gave", infList.byEs("dar"),     2, 3, Tense.PRET,
    null),
  UniqV(0, "sé",        "know", infList.byEs("saber"),   1, 1, Tense.PRES,
    "thing"),
  UniqV(0, "pongo",     "put",  infList.byEs("poner"),   1, 1, Tense.PRES,
    null),
  UniqV(0, "vengo",     "come", infList.byEs("venir"),   1, 1, Tense.PRES,
    null),
  UniqV(0, "salgo",     "go out",  infList.byEs("salir"),   1, 1, Tense.PRES,
    null),
  UniqV(0, "parezco", "look like", infList.byEs("parecer"), 1, 1, Tense.PRES,
    null),
  UniqV(0, "conozco", "know",      infList.byEs("conocer"), 1, 1, Tense.PRES,
    "person"),
  UniqV(0, "empecé",  "started",   infList.byEs("empezar"), 1, 1, Tense.PRET,
    null),
  UniqV(0, "envío",   "sent", infList.byEs("enviar"),  1, 1, Tense.PRES,
    null),
  UniqV(0, "envías",  "sent", infList.byEs("enviar"),  1, 2, Tense.PRES,
    null),
  UniqV(0, "envía",   "sent", infList.byEs("enviar"),  1, 3, Tense.PRES,
    null),
  UniqV(0, "envían",    "sent", infList.byEs("enviar"),  2, 1, Tense.PRES,
    null)
).map { it.copy(cardId = nextCardId++) }
val uniqVByKey = uniqVs.map { Pair(it.getKey(), it) }.toMap()
val uniqVByQuestion =
  Assertions.assertUniqKeys(uniqVs.map { Pair(it.getQuizQuestion(), it) })

val nps = listOf(
  NP(0, "yo", "I")
).map { it.copy(cardId = nextCardId++) }
val npByEs = nps.map { Pair(it.es, it) }.toMap()

val iClauses = listOf(
  IClause(0, nps[0], regVByKey["comerER11PRES"]!!)
).map { it.copy(cardId = nextCardId++) }
val iClauseByKey = iClauses.map { Pair(it.getKey(), it) }.toMap()
val iClauseByQuestion =
  Assertions.assertUniqKeys(iClauses.map { Pair(it.getQuizQuestion(), it) })

val cards = infList.infs +
  regVPatternList.regVPatterns +
  nList.ns +
  detList.dets +
  regVs + uniqVs + nps + iClauses
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
      "Inf"         -> infList.byEs(it.cardKey)
      "N"           -> nList.byEs(it.cardKey)
      "NP"          -> npByEs[it.cardKey]!!
      "RegV"        -> regVByKey[it.cardKey]!!
      "RegVPattern" -> regVPatternList.byKey(it.cardKey)
      "UniqV"       -> uniqVByKey[it.cardKey]!!
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
