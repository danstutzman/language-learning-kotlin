import bank.Bank
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
          <th>es</th>
          <th>en</th>
        </tr>
    """)

    for (noun in bank.nouns) {
      html.append("<tr>")
      html.append("<td>${nullToBlank(noun.es)}</td>")
      html.append("<td>${nullToBlank(noun.en)}</td>")
      html.append("</tr>")
    }

    html.append("""
        <tr>
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
        req.queryParams("es").blankToNull(),
        req.queryParams("en").blankToNull())

    val bank = Bank.loadFrom(bankFile)
    if (newNoun.isSavable()) {
      bank.nouns.add(newNoun)
    }
    bank.saveTo(bankFile)

    res.redirect("/")
  }
}

private fun String.blankToNull(): String? =
    if (this == "") null else this

private fun nullToBlank(s: String?) = if (s == null) "" else s
