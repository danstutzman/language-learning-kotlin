import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Service
import java.io.File

val logger: Logger = LoggerFactory.getLogger("webapp/WebServer.kt")

fun main(args: Array<String>) {
  val port = 3000
  val webapp = Webapp(File("bank.json"))

  logger.info("Starting server port=${port}")
  val service = Service.ignite().port(port)

  service.initExceptionHandler { e ->
    e.printStackTrace()
  }

  if (true) { // if development mode
    service.staticFiles.location("/public")
    val projectDir = System.getProperty("user.dir")
    val staticDir = "/src/main/resources/public"
    service.staticFiles.externalLocation(projectDir + staticDir)
  }

  service.get("/", webapp.getRoot)
  service.post("/add-noun", webapp.postAddNoun)
  service.get("/read-es-recall-uni", webapp.getReadEsRecallUni)
  service.post("/read-es-recall-uni", webapp.postReadEsRecallUni)
  service.get("/hear-es-recall-uni", webapp.getHearEsRecallUni)
  service.post("/hear-es-recall-uni", webapp.postHearEsRecallUni)
}
