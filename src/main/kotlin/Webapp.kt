package com.danstutzman

import com.danstutzman.bank.Bank
import com.danstutzman.bank.CantMakeCard
import com.danstutzman.bank.GlossRow
import com.danstutzman.bank.IdSequence
import com.danstutzman.bank.SkillsUpload
import com.danstutzman.bank.es.DetList
import com.danstutzman.bank.es.InfList
import com.danstutzman.bank.es.NList
import com.danstutzman.bank.es.NPList
import com.danstutzman.bank.es.RegV
import com.danstutzman.bank.es.RegVPatternList
import com.danstutzman.bank.es.UniqVList
import com.danstutzman.db.Db
import com.danstutzman.db.Goal
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.File
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response

fun escapeHTML(s: String): String {
  val out = StringBuilder(Math.max(16, s.length))
  for (c in s) {
    if (c.toInt() > 127 ||
      c == '"' ||
      c == '<' ||
      c == '>' ||
      c == '&' ||
      c == '\'') {
      out.append("&#")
      out.append(c.toInt())
      out.append(';')
    } else {
      out.append(c)
    }
  }
  return out.toString()
}

class Webapp(
  val bank: Bank,
  val db: Db
) {
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
    html.append("<a href='/goals'>Goals</a>\n")
    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val getGoals = { _: Request, _: Response ->
    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<h1>Goals</h1>\n")
    html.append("<table border='1'>\n")
    html.append("  <tr>\n")
    html.append("    <th>ID</td>\n")
    html.append("    <th>Tags</td>\n")
    html.append("    <th>English</td>\n")
    html.append("    <th>Spanish</td>\n")
    html.append("  </tr>\n")
    for (goal in db.selectAllGoals()) {
      val cardHtml: String =
        if (goal.es == "") "" else try {
          val maybeCard = bank.parseEs(goal.es, goal.enFreeText)
          maybeCard.getGlossRows().map { it.es
            }.joinToString(" ").replace("- -", "")
        } catch (e: CantMakeCard) {
          "<div class='CantMakeCard'>${e.message}</div>"
        }

      html.append("  <tr>\n")
      html.append("    <td>${goal.goalId}</td>\n")
      html.append("    <td>${goal.tags}</td>\n")
      html.append("    <td>${goal.enFreeText}</td>\n")
      html.append("    <td>${cardHtml}</td>\n")
      html.append("    <td><a href='/goals/${goal.goalId}'>Edit</a></td>\n")
      html.append("  </tr>\n")
    }
    html.append("</table><br>\n")

    html.append("<form method='POST' action='/goals'>\n")
    html.append("  <label for='tags'>Tags</label><br>\n")
    html.append("  <input type='text' name='tags'><br>\n")
    html.append("  <label for='tags'>English</label><br>\n")
    html.append("  <input type='text' name='en_free_text'><br>\n")
    html.append("  <label for='tags'>Spanish</label><br>\n")
    html.append("  <textarea name='es' rows='10' cols='80'></textarea><br>\n")
    html.append("  <input type='submit' name='submit' value='Add Goal'>\n")
    html.append("</form>\n")

    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val getGoal = { req: Request, _: Response ->
    val goal = db.selectGoalById(req.params("goalId")!!.toInt())!!

    val html = StringBuilder()
    html.append(OPEN_BODY_TAG)

    html.append("<h1>Edit Goal ${goal.goalId}</h1>\n")
    html.append("<form method='POST' action='/goals/${goal.goalId}'>\n")
    html.append("  <label for='tags'>Tags</label><br>\n")
    html.append("  <input type='text' name='tags' value='${escapeHTML(goal.tags)}'><br>\n")
    html.append("  <label for='tags'>English</label><br>\n")
    html.append("  <input type='text' name='en_free_text' value='${escapeHTML(goal.enFreeText)}'><br>\n")
    html.append("  <label for='tags'>Spanish</label><br>\n")
    html.append("  <input type='text' name='es' value='${escapeHTML(goal.es)}'><br>\n")
    html.append("  <input type='submit' name='submit' value='Edit Goal'>\n")
    html.append("  <input type='submit' name='submit' value='Delete Goal' onClick='return confirm(\"Delete goal?\")'>\n")
    html.append("</form>\n")

    html.append(CLOSE_BODY_TAG)
    html.toString()
  }

  val postGoal = { req: Request, res: Response ->
    val submit = req.queryParams("submit")
    if (submit == "Edit Goal") {
      val goal = Goal(
        req.params("goalId").toInt(),
        req.queryParams("tags"),
        req.queryParams("en_free_text"),
        req.queryParams("es")
      )
      db.updateGoal(goal)
    } else if (submit == "Delete Goal") {
      db.deleteGoal(Goal(req.params("goalId").toInt(), "", "", ""))
    } else {
      throw RuntimeException("Unexpected submit value: ${submit}")
    }

    res.redirect("/goals")
  }

  val postGoals = { req: Request, res: Response ->
    db.insertGoal(Goal(
      0,
      req.queryParams("tags"),
      req.queryParams("en_free_text"),
      req.queryParams("es")
    ))
    res.redirect("/goals")
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
