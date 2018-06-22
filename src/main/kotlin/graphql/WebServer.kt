package graphql

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import graphql.GraphQL
import graphql.schema.GraphQLObjectType
import graphql.schema.GraphQLSchema
import graphql.Scalars.GraphQLString
import graphql.schema.GraphQLFieldDefinition.newFieldDefinition
import graphql.schema.GraphQLObjectType.newObject
import java.io.IOException
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response
import spark.Service

val logger: Logger = LoggerFactory.getLogger("WebServer.kt")

data class MyGraphqlRequest(
  val query: String?,
  val variables: Map<String, Any>?
) {}

fun graphqlEndpoint(req: Request, res: Response): String {
  val graphqlRequest =
    Gson().fromJson(req.body(), MyGraphqlRequest::class.java)
  if (graphqlRequest.query == null) {
    res.status(400)
    return "{\"errors\":[\"Missing query\"]}\n"
  }
  val variables = graphqlRequest.variables ?: emptyMap<String, Any>()

  val queryType = newObject()
    .name("helloWorldQuery")
    .field(newFieldDefinition()
      .type(GraphQLString)
      .name("hello")
      .staticValue("world"))
    .build()

  val graphQLSchema = GraphQLSchema.newSchema().query(queryType).build()

  val executionResult = GraphQL.newGraphQL(graphQLSchema)
    .build()
    .execute(graphqlRequest.query)
  val result: Map<String, Any> = when {
    executionResult.errors.isNotEmpty() ->
      hashMapOf("errors" to executionResult.errors)
    else ->
      hashMapOf("data" to executionResult.getData())
  }
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Content-Type", "application/json")
  return GsonBuilder().setPrettyPrinting().create().toJson(result)
}

fun main(args: Array<String>) {
  System.setProperty("org.jooq.no-logo", "true")

  val port = 3000
  // val webApp = graphql.WebApp()
  logger.info("Starting server port=${port}")
  val service = Service.ignite().port(port)

  service.initExceptionHandler { e ->
    e.printStackTrace()
  }

  // service.post("/", webApp.getRoot)

  service.post("/graphql", ::graphqlEndpoint)

  service.afterAfter { req, res ->
    logger.info("${req.requestMethod()} ${req.pathInfo()} ${res.status()}")
  }
}
