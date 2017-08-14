import bank.Bank
import bank.Exposure
import bank.ExposureType
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import db.Action
import db.ActionUnsafe
import db.Db
import es.EsGender
import es.EsN
import spark.Request
import spark.Response
import java.io.File
import kotlin.concurrent.thread

data class Webapp(
    val bankFile: File,
    val db: Db
) {
  val OPEN_BODY_TAG = """
    <html>
      <head>
        <link rel='stylesheet' type='text/css' href='/style.css'>
        <script src='/script.js'></script>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
      </head>
      <body>"""
  val CLOSE_BODY_TAG = "</body></html>"

  val START_MOBILE = """<div class='mobile'>
      <div class='mobile-body'>
      """
  val END_MOBILE = """
    </div>
    <div class='mobile-links'>
      <div class='mobile-link'><a href='/mobile1'>Add</a></div>
      <div class='mobile-link'><a href='/mobile2'>List</a></div>
      <div class='mobile-link'><a href='/mobile3'>Fast Q</a></div>
      <div class='mobile-link'><a href='/mobile4'>Repair</a></div>
      <div class='mobile-link'><a href='/mobile5'>Slow Q</a></div>
    </div>
  </div>"""

  val getRoot = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val html = StringBuilder()

    html.append(OPEN_BODY_TAG)
    html.append("""
      <a href='/read-es-recall-uni'>Read Spanish, recall meaning</a><br>
      <a href='/hear-es-recall-uni'>Hear Spanish, recall meaning</a><br>
      """)

    html.append("""
      <form method='post' action='/add-noun'>
      <h2>Nouns</h2>
      <table border='1'>
        <tr>
          <th class='id'>id</th>
          <th class='article'>article</th>
          <th>es</th>
          <th>en</th>
          <th>score</th>
        </tr>
      """)

    for (noun in bank.listNouns()) {
      html.append("<tr>")
      html.append("<td class='id'>${noun.id}</td>")
      html.append("<td class='article'>${genderToArticle(noun.gender)}</td>")
      html.append("<td>${nullToBlank(noun.es)}</td>")
      html.append("<td>${nullToBlank(noun.en)}</td>")
      html.append("<td>${noun.numRepeatedSuccesses}</td>")
      html.append("</tr>")
    }

    html.append("""
        <tr>
          <td class='id'><button>Add</button></td>
          <td class='article'><input type='text' name='article'></td>
          <td><input type='text' name='es'></td>
          <td><input type='text' name='en'></td>
        </tr>
    """)
    html.append("""
      </table>
      </form>
    """)
    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val postAddNoun = { req: Request, res: Response ->
    val newNoun = EsN(null,
        blankToNull(req.queryParams("es")),
        blankToNull(req.queryParams("en")),
        articleToGender(req.queryParams("article")),
        0)

    val bank = Bank.loadFrom(bankFile)
    if (newNoun.isSavable()) {
      bank.addNoun(newNoun)
    }
    bank.saveTo(bankFile)

    res.redirect("/")
  }

  val getReadEsRecallUni = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val noun = bank.chooseRandomNoun()
    val script = "${genderToArticle(noun.gender)} ${noun.es}"

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append("<form method='post' action='/read-es-recall-uni'>")
    html.append("<input type='hidden' name='card_id' value='${noun.id}'>")
    html.append("<input type='hidden' name='presented_at' value='${System.currentTimeMillis()}'>")
    html.append("<input type='hidden' name='first_responded_at' value=''>")
    html.append("<input type='hidden' name='action' value=''>")
    html.append("<h2>Read Spanish, recall meaning</h2>")
    html.append("<i>${script}</i><br>")
    html.append("<span class='timer-3s-left'>3</span>")
    html.append("<span class='timer-2s-left'>2</span>")
    html.append("<span class='timer-1s-left'>1</span><br>")
    html.append("<button class='i-remember'>I <u>R</u>emember</button>")
    html.append("<button class='i-forget'>I <u>F</u>orget</button>")
    html.append("</form>")
    html.append(CLOSE_BODY_TAG)
  }

  val postReadEsRecallUni = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val card = bank.findCardById(req.queryParams("card_id").toInt())
    val presentedAt = req.queryParams("presented_at").toLong()
    val firstRespondedAt = req.queryParams("first_responded_at").toLong()
    val wasRecalled = when (req.queryParams("action")) {
      "i_remember" -> true
      "i_forget" -> false
      "okay" -> false
      else -> throw RuntimeException("Invalid action value '${req.queryParams("action")}'")
    }

    bank.addExposure(Exposure(
        card.id!!,
        ExposureType.READ_ES_RECALL_UNI,
        presentedAt,
        firstRespondedAt,
        wasRecalled
    ))
    bank.updateNumSuccesses(card.id!!, wasRecalled)
    bank.saveTo(bankFile)

    res.redirect("/read-es-recall-uni")
  }

  val getHearEsRecallUni = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val noun = bank.chooseRandomNoun()
    val script = "${genderToArticle(noun.gender)} ${noun.es}"

    Runtime.getRuntime().exec("/usr/bin/say -v Juan \"${script}\"")

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append("<form method='post' action='/hear-es-recall-uni'>")
    html.append("<input type='hidden' name='card_id' value='${noun.id}'>")
    html.append("<input type='hidden' name='presented_at' value='${System.currentTimeMillis()}'>")
    html.append("<input type='hidden' name='first_responded_at' value=''>")
    html.append("<input type='hidden' name='action' value=''>")
    html.append("<h2>Hear Spanish, recall meaning</h2>")
    html.append("(now playing through speakers)<br>")
    html.append("<span class='timer-3s-left'>3</span>")
    html.append("<span class='timer-2s-left'>2</span>")
    html.append("<span class='timer-1s-left'>1</span><br>")
    html.append("<button class='i-remember'>I <u>R</u>emember</button>")
    html.append("<button class='i-forget'>I <u>F</u>orget</button>")
    html.append("</form>")
    html.append(CLOSE_BODY_TAG)
  }

  val postHearEsRecallUni = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val card = bank.findCardById(req.queryParams("card_id").toInt())
    val presentedAt = req.queryParams("presented_at").toLong()
    val firstRespondedAt = req.queryParams("first_responded_at").toLong()
    val wasRecalled = when (req.queryParams("action")) {
      "i_remember" -> true
      "i_forget" -> false
      "okay" -> false
      else -> throw RuntimeException("Invalid action value '${req.queryParams("action")}'")
    }

    bank.addExposure(Exposure(
        card.id!!,
        ExposureType.HEAR_ES_RECALL_UNI,
        presentedAt,
        firstRespondedAt,
        wasRecalled
    ))
    bank.saveTo(bankFile)

    if (wasRecalled) {
      res.redirect("/hear-es-recall-uni")
    } else {
      res.redirect("/hear-en-es/${card.id}")
    }
  }

  val getHearEnEs = { req: Request, res: Response ->
    println(req.params())
    val bank = Bank.loadFrom(bankFile)
    val noun = bank.findCardById(req.params("card_id").toInt()) as EsN
    val scriptEn = "the ${noun.en}"
    val scriptEs = "${genderToArticle(noun.gender)} ${noun.es}"
    thread {
      val process = Runtime.getRuntime().exec("/usr/bin/say \"${scriptEn}\"")
      process.waitFor()
      Runtime.getRuntime().exec("/usr/bin/say -r 100 -v Juan \"${scriptEs}\"")
    }

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append("<form method='post' action='/hear-en-es'>")
    html.append("<input type='hidden' name='card_id' value='${noun.id}'>")
    html.append("<input type='hidden' name='presented_at' value='${System.currentTimeMillis()}'>")
    html.append("<input type='hidden' name='first_responded_at' value=''>")
    html.append("<input type='hidden' name='action' value=''>")
    html.append("<h2>Hear English and Spanish</h2>")
    html.append("${scriptEn} = <i>${scriptEs}</i><br>")
    html.append("<button class='okay'><u>O</u>kay</button>")
    html.append("</form>")
    html.append(CLOSE_BODY_TAG)
  }

  val postHearEnEs = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val card = bank.findCardById(req.queryParams("card_id").toInt())
    val presentedAt = req.queryParams("presented_at").toLong()
    val firstRespondedAt = req.queryParams("first_responded_at").toLong()

    bank.addExposure(Exposure(
        card.id!!,
        ExposureType.HEAR_EN_ES,
        presentedAt,
        firstRespondedAt,
        null
    ))
    bank.saveTo(bankFile)

    res.redirect("/hear-es-recall-uni")
  }

  val getMobile1 = { req: Request, res: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append(START_MOBILE)
    html.append("<h1>Add new words</h1>")
    html.append("<h2>(either Spanish or English)</h2>")
    html.append("<input class='add-input' type='text'>")
    html.append("<script>document.getElementsByClassName('add-input')[0].focus()</script>")
    html.append(END_MOBILE)
    html.append(CLOSE_BODY_TAG)
  }

  val getMobile2 = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val numNouns = bank.listNouns().size

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append(START_MOBILE)
    html.append("<h1>List of cards</h1>")
    html.append("<a href='/mobile2/nouns'><span class='num-in-part-of-speech'>${numNouns}</span>Nouns</a>")
    html.append(END_MOBILE)
    html.append(CLOSE_BODY_TAG)
  }

  val getMobile3 = { req: Request, res: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append(START_MOBILE)
    html.append("<h1>Fast quiz</h1>")
    html.append("<h2>Tap if you remember</h2>")
    html.append("<h2>Otherwise wait for next card</h2>")
    html.append("<button class='start-quiz'>Start quiz</button>")
    html.append(END_MOBILE)
    html.append(CLOSE_BODY_TAG)
  }

  val getMobile4 = { req: Request, res: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append(START_MOBILE)
    html.append("<h1>Repair forgotten cards</h1>")
    html.append(END_MOBILE)
    html.append(CLOSE_BODY_TAG)
  }

  val getMobile5 = { req: Request, res: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append(START_MOBILE)
    html.append("<h1>Slow quiz</h1>")
    html.append(END_MOBILE)
    html.append(CLOSE_BODY_TAG)
  }

  val postApiSync = { req: Request, res: Response ->
    val request = Gson()
        .fromJson(req.body(), BankApiRequestUnsafe::class.java)
        .toSafe()

    for (action in request.actionsFromClient) {
      db.createAction(action)
    }

    val actionsToClient =
        db.findUnsyncedActions(request.clientIdToMaxSyncedActionId)
    val response = BankApiResponse(actionsToClient)

    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    GsonBuilder().setPrettyPrinting().create().toJson(response)
  }
}

data class BankApiRequestUnsafe(
    val clientId: Int?,
    val clientIdToMaxSyncedActionId: Map<String?, Int?>?,
    val actionsFromClient: List<ActionUnsafe>?

) {
  fun toSafe(): BankApiRequest {
    return BankApiRequest(
        clientId!!,
        clientIdToMaxSyncedActionId!!.map({ (k, v) ->
          k!!.toInt() to v!!
        }).toMap(),
        actionsFromClient!!.map { action ->
          action!!.toSafe()
        })
  }
}

data class BankApiRequest(
    val clientId: Int,
    val clientIdToMaxSyncedActionId: Map<Int, Int>,
    val actionsFromClient: List<Action>
) {}

data class BankApiResponse(
    val actionsToClient: List<Action>
)

private fun blankToNull(s: String): String? =
    if (s == "") null else s

private fun nullToBlank(s: String?) = if (s == null) "" else s

private fun genderToArticle(gender: EsGender?) = when (gender) {
  EsGender.M -> "el"
  EsGender.F -> "la"
  else -> ""
}

private fun articleToGender(article: String?) = when (article) {
  null -> null
  "" -> null
  "la" -> EsGender.F
  "el" -> EsGender.M
  else -> throw RuntimeException("Unknown article $article")
}
