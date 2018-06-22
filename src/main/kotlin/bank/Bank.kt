package com.danstutzman.bank

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.IdSequence
import com.danstutzman.bank.es.DetList
import com.danstutzman.bank.es.IClause
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.NList
import com.danstutzman.bank.es.NPList
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.UniqVList
import com.danstutzman.bank.es.VCloud
import com.esotericsoftware.yamlbeans.YamlReader
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.FileReader
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response
import java.io.File

const val DELAY_THRESHOLD = 100000

data class IClausesYaml (
  val iClauses: List<IClauseYaml>? = null
) {}

data class IClauseYaml (
  var agent: String? = null,
  var v: String? = null
) {}

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

class Bank(
  val skillsExportFile: File,
  val iClausesYamlFile: File
) {
  val logger: Logger = LoggerFactory.getLogger("Webapp.kt")

  val cardIdSequence  = IdSequence()
  val infList         = InfList(cardIdSequence)
  val regVPatternList = RegVPatternList(cardIdSequence)
  val nList           = NList(cardIdSequence)
  val detList         = DetList(cardIdSequence)
  val uniqVList       = UniqVList(cardIdSequence, infList)
  val npList          = NPList(cardIdSequence)
  val vCloud          = VCloud(cardIdSequence, infList, uniqVList,
                          regVPatternList)

  val regVs = listOf(
    RegV(0, infList.byEs("preguntar")!!, regVPatternList.byKey("AR11PRES")),
    RegV(0, infList.byEs("preguntar")!!, regVPatternList.byKey("AR13PRES")),
    RegV(0, infList.byEs("comer")!!,     regVPatternList.byKey("ERIR11PRES")),
    RegV(0, infList.byEs("comer")!!,     regVPatternList.byKey("ERIR13PRES")),
    RegV(0, infList.byEs("preguntar")!!, regVPatternList.byKey("AR11PRET")),
    RegV(0, infList.byEs("preguntar")!!, regVPatternList.byKey("AR13PRET"))
  ).map { it.copy(cardId = cardIdSequence.nextId()) }
  val regVByKey = regVs.map { Pair(it.getKey(), it) }.toMap()
  val regVByQuestion =
    Assertions.assertUniqKeys(regVs.map { Pair(it.getQuizQuestion(), it) })

  val reader = YamlReader(FileReader(iClausesYamlFile))
  val ignored =
    reader.getConfig().setClassTag("IClause", IClauseYaml::class.java)
  val iClausesYaml = reader.read(List::class.java) as List<IClauseYaml>
  val iClauses = iClausesYaml.map { yaml ->
    IClause(
      cardIdSequence.nextId(),
      npList.byEs(yaml.agent!!),
      vCloud.byEs(yaml.v!!) as RegV
    )
  }
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

  val skillsExport: SkillsExport = Gson()
    .fromJson(skillsExportFile.readText(), SkillsExport::class.java)

  fun getCardsAndSkills(): Map<String, Any> {
    val skillRowByCardId = skillsExport.skillExports.map {
      val card = when (it.cardType) {
        "Det"         -> detList.byEs(it.cardKey)
        "IClause"     -> iClauseByKey[it.cardKey]!!
        "Inf"         -> infList.byEs(it.cardKey)!!
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

    return linkedMapOf(
      "cards" to cardRows,
      "skills" to skillRows
    )
  }

  fun saveSkillsExport(skillsUpload: SkillsUpload) {
    skillsExportFile.writeText(
      GsonBuilder().setPrettyPrinting().create().toJson(
        SkillsExport(skillsUpload.skillExports!!)))
  }
}
