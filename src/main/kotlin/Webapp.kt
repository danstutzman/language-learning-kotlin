import bank.Bank
import es.EsN
import spark.Request
import spark.Response

data class Webapp(
    val bank: Bank
) {
  val rootGet = { req: Request, res: Response ->
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
          <th>English</th>
        </tr>
    """)

    for (noun in bank.nouns) {
      html.append("""
      <tr>
        <td>${noun.en}</td>
      </tr>
    """)
    }

    html.append("""
      <tr>
        <td><input type='text' name='new_english'></td>
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
    val newEnglish = req.queryParams("new_english")
    bank.nouns.add(EsN(newEnglish))
    res.redirect("/")
  }
}