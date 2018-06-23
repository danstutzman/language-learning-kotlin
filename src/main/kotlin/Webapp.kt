package com.danstutzman

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.Bank
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.IdSequence
import com.danstutzman.bank.SkillsUpload
import com.danstutzman.bank.es.DetList
import com.danstutzman.bank.es.IClause
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.NList
import com.danstutzman.bank.es.NPList
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.UniqVList
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.File
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response

class Webapp(val bank: Bank) {
  val logger: Logger = LoggerFactory.getLogger("Webapp.kt")

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
    val response = bank.getCardsAndSkills()
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    GsonBuilder().create().toJson(response)
  }

  val postApi = { req: Request, res: Response ->
    val skillsUpload = Gson().fromJson(req.body(), SkillsUpload::class.java)
    bank.saveSkillsExport(skillsUpload)
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Content-Type", "application/json")
    "{}"
  }
}
