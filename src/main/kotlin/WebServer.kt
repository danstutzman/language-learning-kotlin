import db.Db
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Service
import java.io.File
import java.sql.DriverManager

val logger: Logger = LoggerFactory.getLogger("webapp/WebServer.kt")

fun main(args: Array<String>) {
  val port = 3000
  System.setProperty("org.jooq.no-logo", "true")
  val jdbcUrl = "jdbc:postgresql://localhost:5432/language_learning_kotlin"
  val conn = DriverManager.getConnection(jdbcUrl, "postgres", "")
  val webapp = Webapp(File("bank.json"), Db(conn))

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
  service.post("/add-noun", webapp.postAddNoun)
  service.get("/read-es-recall-uni", webapp.getReadEsRecallUni)
  service.post("/read-es-recall-uni", webapp.postReadEsRecallUni)
  service.get("/hear-es-recall-uni", webapp.getHearEsRecallUni)
  service.post("/hear-es-recall-uni", webapp.postHearEsRecallUni)
  service.get("/hear-en-es/:card_id", webapp.getHearEnEs)
  service.post("/hear-en-es", webapp.postHearEnEs)
  service.get("/mobile1", webapp.getMobile1)
  service.get("/mobile2", webapp.getMobile2)
  service.get("/mobile3", webapp.getMobile3)
  service.get("/mobile4", webapp.getMobile4)
  service.get("/mobile5", webapp.getMobile5)
  service.post("/api/sync", webapp.postApiSync)

  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
