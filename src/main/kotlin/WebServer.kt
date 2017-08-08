import org.slf4j.LoggerFactory
import spark.Service
import java.io.File

val logger = LoggerFactory.getLogger("webapp/WebServer.kt")

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

  service.get("/", webapp.rootGet)
  service.post("/add-noun", webapp.addNounPost)
}


