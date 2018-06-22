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

fun assertUniqKeys(pairs: List<Pair<String, Inf>>) {
  val map = mutableMapOf<String, Inf>()
  for (pair in pairs) {
    val oldValue = map.get(pair.first)
    if (oldValue != null) {
      throw RuntimeException(
        "Key ${pair.first} has two values: ${oldValue} and ${pair.second}")
    }
    map.put(pair.first, pair.second)
  }
}

var nextCardId = 1

val infs = listOf(
  Inf(0, "comer",     "eat",    "ate",      null),
  Inf(0, "conocer",   "know",   "knew",     "(person)"),
  Inf(0, "dar",       "give",   "gave",     null),
  Inf(0, "decir",     "say",    "said",     null),
  Inf(0, "empezar",   "start",  "started",  null),
  Inf(0, "enviar",    "send",   "sent",     null),
  Inf(0, "estar",     "be",     "was",      "(how)"),
  Inf(0, "hacer",     "do",     "did",      null),
  Inf(0, "ir",        "go",     "went",     null),
  Inf(0, "parecer",   "seem",   "seemed",   null),
  Inf(0, "poner",     "put",    "put",      null),
  Inf(0, "preguntar", "ask",    "asked",    null),
  Inf(0, "saber",     "know",   "knew",     "(thing)"),
  Inf(0, "salir",     "go out", "went out", null),
  Inf(0, "ser",       "be",     "was",      "(what)"),
  Inf(0, "tener",     "have",   "had",      null),
  Inf(0, "ver",       "see",    "saw",      null),
  Inf(0, "venir",     "come",   "came",     null)
).map { it.copy(cardId = nextCardId++) }
val infByEs = infs.map { Pair(it.es, it) }.toMap()
val infByEn = assertUniqKeys(infs.map { Pair(it.getQuizQuestion(), it) })

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

val uniqVs = listOf(
  UniqV(0, "soy",       "am",   infByEs["ser"]!!,     1, 1, Tense.PRES),
  UniqV(0, "eres",      "are",  infByEs["ser"]!!,     1, 2, Tense.PRES),
  UniqV(0, "es",        "is",   infByEs["ser"]!!,     1, 3, Tense.PRES),
  UniqV(0, "somos",     "are",  infByEs["ser"]!!,     2, 1, Tense.PRES),
  UniqV(0, "son",       "are",  infByEs["ser"]!!,     2, 3, Tense.PRES),
  UniqV(0, "fui",       "was",  infByEs["ser"]!!,     1, 1, Tense.PRET),
  UniqV(0, "fuiste",    "were", infByEs["ser"]!!,     1, 2, Tense.PRET),
  UniqV(0, "fue",       "was",  infByEs["ser"]!!,     1, 3, Tense.PRET),
  UniqV(0, "fuimos",    "were", infByEs["ser"]!!,     2, 1, Tense.PRET),
  UniqV(0, "fueron",    "were", infByEs["ser"]!!,     2, 3, Tense.PRET),
  UniqV(0, "estoy",     "am",   infByEs["estar"]!!,   1, 1, Tense.PRES),
  UniqV(0, "estás",     "are",  infByEs["estar"]!!,   1, 2, Tense.PRES),
  UniqV(0, "está",      "is",   infByEs["estar"]!!,   1, 3, Tense.PRES),
  UniqV(0, "están",     "are",  infByEs["estar"]!!,   2, 3, Tense.PRES),
  UniqV(0, "tengo",     "have", infByEs["tener"]!!,   1, 1, Tense.PRES),
  UniqV(0, "hago",      "do",   infByEs["hacer"]!!,   1, 1, Tense.PRES),
  UniqV(0, "digo",      "say",  infByEs["decir"]!!,   1, 1, Tense.PRES),
  UniqV(0, "dijeron",   "said", infByEs["decir"]!!,   2, 3, Tense.PRET),
  UniqV(0, "voy",       "go",   infByEs["ir"]!!,      1, 1, Tense.PRES),
  UniqV(0, "vas",       "go",   infByEs["ir"]!!,      1, 2, Tense.PRES),
  UniqV(0, "va",        "goes", infByEs["ir"]!!,      1, 3, Tense.PRES),
  UniqV(0, "vamos",     "go",   infByEs["ir"]!!,      2, 1, Tense.PRES),
  UniqV(0, "van",       "go",   infByEs["ir"]!!,      2, 3, Tense.PRES),
  UniqV(0, "fui",       "went", infByEs["ir"]!!,      1, 1, Tense.PRET),
  UniqV(0, "fuiste",    "went", infByEs["ir"]!!,      1, 2, Tense.PRET),
  UniqV(0, "fue",       "went", infByEs["ir"]!!,      1, 3, Tense.PRET),
  UniqV(0, "fuimos",    "went", infByEs["ir"]!!,      2, 1, Tense.PRET),
  UniqV(0, "fueron",    "went", infByEs["ir"]!!,      2, 3, Tense.PRET),
  UniqV(0, "veo",       "see",  infByEs["ver"]!!,     1, 1, Tense.PRES),
  UniqV(0, "vi",        "saw",  infByEs["ver"]!!,     1, 1, Tense.PRET),
  UniqV(0, "vio",       "saw",  infByEs["ver"]!!,     1, 3, Tense.PRET),
  UniqV(0, "vimos",     "saw",  infByEs["ver"]!!,     2, 1, Tense.PRET),
  UniqV(0, "doy",       "give", infByEs["dar"]!!,     1, 1, Tense.PRES),
  UniqV(0, "di",        "gave", infByEs["dar"]!!,     1, 1, Tense.PRET),
  UniqV(0, "diste",     "gave", infByEs["dar"]!!,     1, 2, Tense.PRET),
  UniqV(0, "dio",       "gave", infByEs["dar"]!!,     1, 3, Tense.PRET),
  UniqV(0, "dimos",     "gave", infByEs["dar"]!!,     2, 1, Tense.PRET),
  UniqV(0, "dieron",    "gave", infByEs["dar"]!!,     2, 3, Tense.PRET),
  UniqV(0, "sé",        "know", infByEs["saber"]!!,   1, 1, Tense.PRES),
  UniqV(0, "pongo",     "put",  infByEs["poner"]!!,   1, 1, Tense.PRES),
  UniqV(0, "vengo",     "come", infByEs["venir"]!!,   1, 1, Tense.PRES),
  UniqV(0, "salgo",     "go out",    infByEs["salir"]!!,   1, 1, Tense.PRES),
  UniqV(0, "parezco",   "look like", infByEs["parecer"]!!, 1, 1, Tense.PRES),
  UniqV(0, "conozco",   "know",      infByEs["conocer"]!!, 1, 1, Tense.PRES),
  UniqV(0, "empecé",    "started",   infByEs["empezar"]!!, 1, 1, Tense.PRET),
  UniqV(0, "envío",     "started",   infByEs["enviar"]!!,  1, 1, Tense.PRES),
  UniqV(0, "envías",    "started",   infByEs["enviar"]!!,  1, 2, Tense.PRES),
  UniqV(0, "envía",     "started",   infByEs["enviar"]!!,  1, 3, Tense.PRES),
  UniqV(0, "envían",    "started",   infByEs["enviar"]!!,  2, 1, Tense.PRES)
).map { it.copy(cardId = nextCardId++) }
val uniqVByKey = uniqVs.map { Pair(it.getKey(), it) }.toMap()

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

val cards = infs + regVPatterns + regVs + uniqVs + ns + dets + nps + iClauses
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
      "Det"         -> detByEs[it.cardKey]!!
      "IClause"     -> iClauseByKey[it.cardKey]!!
      "Inf"         -> infByEs[it.cardKey]!!
      "N"           -> nByEs[it.cardKey]!!
      "NP"          -> npByEs[it.cardKey]!!
      "RegV"        -> regVByKey[it.cardKey]!!
      "RegVPattern" -> regVPatternByKey[it.cardKey]!!
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
