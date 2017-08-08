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
  val STYLE_HTML = """
    <style>
      body { font-family:sans-serif; }
    </style>"""

  val getRoot = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val html = StringBuilder()

    html.append(STYLE_HTML)
    html.append("""
      <a href='/read-es-ack-uni'>Read Spanish, acknowledge meaning</a>
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

  val getReadEsAckUni = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val random = Random()
    val randomNoun = bank.chooseRandomNoun()


    val html = StringBuilder()
    html.append(STYLE_HTML)
    html.append("<form method='post' action='/read-es-ack-uni'>")
    html.append("<input type='hidden' name='card_id' value='${randomNoun.id}'>")
    html.append("<h2>Read Spanish, acknowledge meaning</h2>")
    html.append("<i>${genderToArticle(randomNoun.gender)} ${randomNoun.es}</i><br>")
    html.append("<button name='action' value='i_remember'>I remember</button>")
    html.append("<button name='action' value='i_forget'>I forget</button>")
    html.append("</form>")
  }

  val postReadEsAckUni = { req: Request, res: Response ->
    val bank = Bank.loadFrom(bankFile)
    val card = bank.findCardById(req.queryParams("card_id").toInt())
    bank.addExposure(card.id!!, ExposureType.READ_ES_ACK_UNI)
    bank.saveTo(bankFile)

    res.redirect("/read-es-ack-uni")
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
