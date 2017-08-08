import spark.Request
import spark.Response

class Webapp {
  val root = { req: Request, res: Response ->
    "Hello world"
  }
}