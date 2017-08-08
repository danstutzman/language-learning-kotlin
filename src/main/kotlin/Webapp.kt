import bank.Bank
import bank.ExposureType
import es.EsGender
import es.EsN
import spark.Request
import spark.Response
import java.io.File
import java.util.Random


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
    val random = Random()
    val randomNoun = bank.chooseRandomNoun()

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append("<form method='post' action='/read-es-recall-uni'>")
    html.append("<input type='hidden' name='card_id' value='${randomNoun.id}'>")
    html.append("<input type='hidden' name='action' value=''>")
    html.append("<h2>Read Spanish, recall meaning</h2>")
    html.append("<i>${genderToArticle(randomNoun.gender)} ${randomNoun.es}</i><br>")
    html.append("<button class='i-remember' name='action' value='i-remember'>I remember</button>")
    html.append("<button class='i-forget' name='action' value='i-forget'>I forget</button>")
    html.append("</form>")
    html.append(CLOSE_BODY_TAG)
  }

  val postReadEsRecallUni = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val card = bank.findCardById(req.queryParams("card_id").toInt())
    bank.addExposure(card.id!!, ExposureType.READ_ES_RECALL_UNI)
    bank.saveTo(bankFile)

    res.redirect("/read-es-recall-uni")
  }

  val getHearEsRecallUni = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val random = Random()
    val randomNoun = bank.chooseRandomNoun()

    Runtime.getRuntime().exec("/usr/bin/say -v Juan la casa")

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)
    html.append("<form method='post' action='/hear-es-recall-uni'>")
    html.append("<input type='hidden' name='card_id' value='${randomNoun.id}'>")
    html.append("<input type='hidden' name='action' value=''>")
    html.append("<h2>Hear Spanish, recall meaning</h2>")
    html.append("(now playing through speakers)<br>")
    html.append("<button class='i-remember' name='action' value='i-remember'>I <u>R</u>emember</button>")
    html.append("<button class='i-forget' name='action' value='i-forget'>I <u>F</u>orget</button>")
    html.append("</form>")
    html.append(CLOSE_BODY_TAG)
  }

  val postHearEsRecallUni = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val card = bank.findCardById(req.queryParams("card_id").toInt())
    bank.addExposure(card.id!!, ExposureType.HEAR_ES_RECALL_UNI)
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
