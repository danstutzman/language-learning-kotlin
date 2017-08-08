import bank.Bank
import es.EsGender
import es.EsN
import spark.Request
import spark.Response
import java.io.File

data class Webapp(
    val bankFile: File
) {
  val rootGet = { _: Request, _: Response ->
    val bank = Bank.loadFrom(bankFile)
    val html = StringBuilder()
    html.append("""
      <style>
        body { font-family:sans-serif; }
      </style>""")

    html.append("""
      <form method='post' action='/add-noun'>
      <h2>Nouns</h2>
      <table border='1'>
        <tr>
          <th>article</th>
          <th>es</th>
          <th>en</th>
        </tr>
    """)

    for (noun in bank.nouns) {
      html.append("<tr>")
      html.append("<td>${genderToArticle(noun.gender)}</td>")
      html.append("<td>${nullToBlank(noun.es)}</td>")
      html.append("<td>${nullToBlank(noun.en)}</td>")
      html.append("</tr>")
    }

    html.append("""
        <tr>
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

  val addNounPost = { req: Request, res: Response ->
    val newNoun = EsN(
        blankToNull(req.queryParams("es")),
        blankToNull(req.queryParams("en")),
        articleToGender(req.queryParams("article")))

    val bank = Bank.loadFrom(bankFile)
    if (newNoun.isSavable()) {
      bank.nouns.add(newNoun)
    }
    bank.saveTo(bankFile)

    res.redirect("/")
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
