import com.google.gson.Gson
import com.google.gson.GsonBuilder
import es.DetList
import es.IClause
import es.InfList
import es.NList
import es.NPList
import es.RegV
import es.RegVPatternList
import es.UniqVList
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import seeds.Assertions
import seeds.GlossRow
import seeds.IdSequence
import spark.Request
import spark.Response
import java.io.File

val logger: Logger = LoggerFactory.getLogger("Webapp.kt")

val DELAY_THRESHOLD = 100000

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





class Webapp(val skillsExportFile: File) {
  val OPEN_BODY_TAG = """
    <html>
      <head>
        <link rel='stylesheet' type='text/css' href='/style.css'>
        <script src='/script.js'></script>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
      </head>
      <body>"""
  val CLOSE_BODY_TAG = "</body></html>"

  val getRoot = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<h1>Main</h1>\n")

    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val getApi = { req: Request, res: Response ->
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
    GsonBuilder().setPrettyPrinting().create().toJson(response)
  }

  val postApi = { req: Request, res: Response ->
    val skillsUpload = Gson().fromJson(req.body(), SkillsUpload::class.java)
    if (skillsUpload.skillExports == null) {
      res.status(400)
      res.header("Access-Control-Allow-Origin", "*")
      res.header("Content-Type", "application/json")
      "{\"errors\":[\"Missing skillExports\"]}"
    } else {
      skillsExportFile.writeText(
        GsonBuilder().setPrettyPrinting().create().toJson(
          SkillsExport(skillsUpload.skillExports)))
      res.header("Access-Control-Allow-Origin", "*")
      res.header("Content-Type", "application/json")
      "{}"
    }
  }
}
