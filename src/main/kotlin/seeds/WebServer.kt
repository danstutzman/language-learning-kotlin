package seeds

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import db.Db
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Service

val logger: Logger = LoggerFactory.getLogger("seeds/WebServer.kt")

val DELAY_THRESHOLD = 10000

data class GlossRow (
  val cardId: Int,
  val en: String,
  val es: String
) {}

interface Card {
  val cardId: Int
  fun getChildrenCardIds(): List<Int>
  fun getEsWords(): List<String>
  fun getGlossRows(): List<GlossRow>
  fun getQuizQuestion(): String
}

data class Inf (
  override val cardId: Int,
  val es: String,
  val enPresent: String,
  val enPast: String
): Card {
  override fun getChildrenCardIds(): List<Int> = listOf()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, enPresent, es))
  override fun getQuizQuestion(): String = "to ${enPresent}"
}

enum class InfCategory {
  AR,
  ER,
  IR
}

enum class Tense {
  PRES,
  PRET
}

val NUMBER_AND_PERSON_TO_EN_PRONOUN = linkedMapOf(
  Pair(1, 1) to "I",
  Pair(1, 2) to "you",
  Pair(1, 3) to "he/she",
  Pair(2, 1) to "we",
  Pair(2, 3) to "they"
)

data class RegVPattern (
  override val cardId: Int,
  val infCategory: InfCategory,
  val number: Int,
  val person: Int,
  val tense: Tense,
  val es: String
): Card {
  fun getEnPronoun(): String =
    NUMBER_AND_PERSON_TO_EN_PRONOUN[Pair(number, person)]!!
  fun getKey(): String = "${infCategory}${number}${person}${tense}"
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> =
    listOf(GlossRow(cardId, "(${getEnPronoun()})", es))
  override fun getQuizQuestion(): String =
    "${infCategory} verb suffix for ${getEnPronoun()} in ${tense}"
}

data class NP (
  override val cardId: Int,
  val es: String,
  val en: String
): Card {
  override fun getChildrenCardIds(): List<Int> = listOf<Int>()
  override fun getEsWords(): List<String> = listOf(es)
  override fun getGlossRows(): List<GlossRow> = listOf(GlossRow(cardId, en, es))
  override fun getQuizQuestion(): String = en
}

val NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX = linkedMapOf(
  Pair(1, 1) to "",
  Pair(1, 2) to "",
  Pair(1, 3) to "s",
  Pair(2, 1) to "",
  Pair(2, 3) to ""
)

data class RegV (
  override val cardId: Int,
  val inf: Inf,
  val pattern: RegVPattern
): Card {
  fun getKey(): String = "${inf.es}${pattern.getKey()}"
  fun getEnVerb(): String = when(pattern.tense) {
    Tense.PRES -> inf.enPresent + NUMBER_AND_PERSON_TO_EN_VERB_SUFFIX[
      Pair(pattern.number, pattern.person)]!!
    Tense.PRET -> inf.enPast
    else -> throw RuntimeException("Unexpected tense ${pattern.tense}")
  }
  fun getEsVerbPrefix(): String = inf.es.substring(0, inf.es.length - 2) + "-"
  override fun getChildrenCardIds(): List<Int> =
    listOf<Int>(inf.cardId, pattern.cardId)
  override fun getEsWords(): List<String> = listOf(
    inf.es.substring(0, inf.es.length - 2) + pattern.es.substring(1))
  override fun getGlossRows(): List<GlossRow> = listOf(
    GlossRow(inf.cardId, getEnVerb(), getEsVerbPrefix())) +
    pattern.getGlossRows()
  override fun getQuizQuestion(): String =
    "(${pattern.getEnPronoun()}) ${getEnVerb()}"
}

fun capitalizeFirstLetter(s: String) =
  s.substring(0, 1).toUpperCase() + s.substring(1)

data class IClause(
  override val cardId: Int,
  val agent: NP,
  val v: RegV
): Card {
  override fun getChildrenCardIds(): List<Int> =
    listOf<Int>(agent.cardId, v.cardId)
  override fun getEsWords(): List<String> =
    listOf(capitalizeFirstLetter(agent.getEsWords()[0])) +
    listOf(v.getEsWords()[0] + ".")
  override fun getGlossRows(): List<GlossRow> =
    agent.getGlossRows() + v.getGlossRows()
  override fun getQuizQuestion(): String =
    capitalizeFirstLetter(agent.getQuizQuestion()) + " " + v.getEnVerb() + "."
}

data class CardRow(
  val cardId: Int,
  val type: String,
  val childrenCardIds: List<Int>,
  val glossRows: List<GlossRow>,
  val esWords: List<String>,
  val quizQuestion: String
) {}

data class SkillRow(
  val cardId: Int,
  val delay: Int,
  val endurance: Int,
  val lastCorrectAt: Int,
  val mnemonic: String
) {}

fun handleGet(req: spark.Request, res: spark.Response): String {
  val infs = listOf(
    Inf(11, "preguntar", "ask", "asked"),
    Inf(12, "comer", "eat", "ate")
  )
  val infByEs = infs.map { Pair(it.es, it) }.toMap()

  val regVPatterns = listOf(
    RegVPattern(21, InfCategory.AR, 1, 1, Tense.PRES, "-o"),
    RegVPattern(22, InfCategory.AR, 1, 3, Tense.PRES, "-a"),
    RegVPattern(23, InfCategory.ER, 1, 1, Tense.PRES, "-o"),
    RegVPattern(24, InfCategory.ER, 1, 3, Tense.PRES, "-e"),
    RegVPattern(25, InfCategory.AR, 1, 1, Tense.PRET, "-é"),
    RegVPattern(26, InfCategory.AR, 1, 3, Tense.PRET, "-ó")
  )
  val regVPatternByKey = regVPatterns.map { Pair(it.getKey(), it) }.toMap()

  val regVs = listOf(
    RegV(31, infByEs["preguntar"]!!, regVPatternByKey["AR11PRES"]!!),
    RegV(32, infByEs["preguntar"]!!, regVPatternByKey["AR13PRES"]!!),
    RegV(33, infByEs["comer"]!!,     regVPatternByKey["ER11PRES"]!!),
    RegV(34, infByEs["comer"]!!,     regVPatternByKey["ER13PRES"]!!),
    RegV(35, infByEs["preguntar"]!!, regVPatternByKey["AR11PRET"]!!),
    RegV(36, infByEs["preguntar"]!!, regVPatternByKey["AR13PRET"]!!)
  )
  val regVByKey = regVs.map { Pair(it.getKey(), it) }.toMap()

  val nps = listOf(
    NP(41, "yo", "I")
  )

  val iClauses = listOf(
    IClause(51, nps[0], regVByKey["comerER11PRES"]!!)
  )

  val cards = infs + regVPatterns + regVs + nps + iClauses
  val cardRows = cards.map {
    val type = it.javaClass.name.split('.').last()
    CardRow(
      it.cardId,
      type,
      it.getChildrenCardIds(),
      it.getGlossRows(),
      it.getEsWords(),
      it.getQuizQuestion()
    )
  }
  val skillRows = cards.map {
    SkillRow(
      it.cardId,
      if (it.getChildrenCardIds().size == 0)
        DELAY_THRESHOLD else DELAY_THRESHOLD * 2,
      0,
      0,
      "")
  }
  val response = linkedMapOf(
    "cards" to cardRows,
    "skills" to skillRows
  )

  res.header("Access-Control-Allow-Origin", "*")
  res.header("Content-Type", "application/json")
  return GsonBuilder().setPrettyPrinting().create().toJson(response)
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

  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
