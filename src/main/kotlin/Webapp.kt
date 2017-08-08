import bank.Bank
import bank.Exposure
import bank.ExposureType
import es.EsGender
import es.EsN
import spark.Request
import spark.Response
import java.io.File


data class Webapp(
    val bankFile: File
) {
  val OPEN_BODY_TAG = """
    <html>
      <head>
        <link rel='stylesheet' type='text/css' href='style.css'>
        <script src='script.js'></script>
      </head>
      <body>"""
  val CLOSE_BODY_TAG = "</body></html>"

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
          <th>id</th>
          <th>article</th>
          <th>es</th>
          <th>en</th>
        </tr>
      """)

    for (noun in bank.listNouns()) {
      html.append("<tr>")
      html.append("<td>${noun.id}</td>")
      html.append("<td>${genderToArticle(noun.gender)}</td>")
      html.append("<td>${nullToBlank(noun.es)}</td>")
      html.append("<td>${nullToBlank(noun.en)}</td>")
      html.append("</tr>")
    }

    html.append("""
        <tr>
          <td></td>
          <td><input type='text' name='article'></td>
          <td><input type='text' name='es'></td>
          <td><input type='text' name='en'></td>
          <td><button>Add</button></td>
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
        articleToGender(req.queryParams("article")))

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
    html.append("<button class='i-remember'>I remember</button>")
    html.append("<button class='i-forget'>I forget</button>")
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
      "i_forget" -> true
      else -> throw RuntimeException("Invalid action value '${req.queryParams("action")}'")
    }

    bank.addExposure(Exposure(
        card.id!!,
        ExposureType.READ_ES_RECALL_UNI,
        presentedAt,
        firstRespondedAt,
        wasRecalled
    ))
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

    res.redirect("/hear-es-recall-uni")
  }
}

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
