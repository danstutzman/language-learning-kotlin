package com.danstutzman

import com.danstutzman.bank.Bank
import com.danstutzman.db.Db
import com.esotericsoftware.yamlbeans.YamlReader
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Service
import java.io.File
import java.io.FileReader
import java.sql.DriverManager

data class IClausesYaml (
  val iClauses: List<IClauseYaml>? = null
) {}

data class IClauseYaml (
  var agent: String? = null,
  var v: String? = null
) {}

fun main(args: Array<String>) {
  System.setProperty("org.jooq.no-logo", "true")

  val logger: Logger = LoggerFactory.getLogger("WebServer.kt")
  val port = 3000
  val jdbcUrl = "jdbc:postgresql://localhost:5432/language_learning_kotlin"

  val conn = DriverManager.getConnection(jdbcUrl, "postgres", "")
  val bank = Bank(File("skillsExport.json"), File("iClauses.yaml"))
  val webapp = Webapp(bank)

  logger.info("Starting server port=${port}")
  val service = Service.ignite().port(port)

  service.initExceptionHandler { e ->
    e.printStackTrace()
  }

  if (true) { // if development mode
    val projectDir = System.getProperty("user.dir")
    val staticDir = "/src/main/resources/public"
    service.staticFiles.externalLocation(projectDir + staticDir)
  } else {
    service.staticFiles.location("/public")
  }

  service.get("/", webapp.getRoot)
  service.get("/api", webapp.getApi)
  service.post("/api", webapp.postApi)

  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
