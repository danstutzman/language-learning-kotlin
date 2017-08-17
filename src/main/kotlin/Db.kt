package db

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.jooq.SQLDialect
import org.jooq.generated.tables.Actions.ACTIONS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp


data class Action(
    val actionId: Int,
    val type: String,
    val createdAtMillis: Long,
    val cardJson: String?,
    val exposureJson: String?
)

data class ActionUnsafe(
    val actionId: Int?,
    val type: String?,
    val createdAtMillis: Long?,
    val card: JsonObject?,
    val exposure: JsonObject?
) {
  fun toSafe(): Action {
    return Action(
        actionId!!,
        type!!,
        createdAtMillis!!,
        if (card != null) Gson().toJson(card) else null,
        if (exposure != null) Gson().toJson(exposure) else null
    )
  }
}

class Db(
    private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  fun now() = Timestamp(System.currentTimeMillis().toLong())

  private fun mustAffectOneRow(numRowsAffected: Int) =
      if (numRowsAffected == 1) { // Do nothing
      } else {
        throw RuntimeException("numRowsAffected ${numRowsAffected} != 1")
      }

  fun createAction(action: Action) {
    create
        .insertInto(ACTIONS,
            ACTIONS.ACTION_ID,
            ACTIONS.TYPE,
            ACTIONS.CREATED_AT_MILLIS,
            ACTIONS.CARD_JSON,
            ACTIONS.EXPOSURE_JSON)
        .values(action.actionId,
            action.type,
            action.createdAtMillis,
            action.cardJson,
            action.exposureJson)
        .returning(
            ACTIONS.ACTION_ID,
            ACTIONS.TYPE,
            ACTIONS.CREATED_AT_MILLIS,
            ACTIONS.CARD_JSON,
            ACTIONS.EXPOSURE_JSON)
        .fetchOne()
  }

  fun findUnsyncedActions(clientIdToMaxSyncedActionId: Map<Int, Int>): List<ActionUnsafe> {
    val where = StringBuilder("0=1")
    for ((clientId, maxSyncedActionId) in clientIdToMaxSyncedActionId) {
      where.append(" OR (actions.action_id % 10 = $clientId AND actions.action_id > $maxSyncedActionId)")
    }
    val maxClientId: Int = clientIdToMaxSyncedActionId.keys.max() ?: -1
    where.append(" OR (actions.action_id % 10 > $maxClientId)")

    val actions = mutableListOf<ActionUnsafe>()
    val rows = create
        .select(
            ACTIONS.ACTION_ID,
            ACTIONS.TYPE,
            ACTIONS.CREATED_AT_MILLIS,
            ACTIONS.CARD_JSON,
            ACTIONS.EXPOSURE_JSON)
        .from(ACTIONS)
        .where(where.toString())
        .fetch()
    for (row in rows) {
      val cardJson: String? = row.getValue(ACTIONS.CARD_JSON)
      val exposureJson: String? = row.getValue(ACTIONS.EXPOSURE_JSON)
      val card: JsonObject? =
          if (cardJson != null) {
            JsonParser().parse(cardJson).asJsonObject
          } else {
            null
          }
      val exposure: JsonObject? =
          if (exposureJson != null) {
            JsonParser().parse(exposureJson).asJsonObject
          } else {
            null
          }
      actions.add(ActionUnsafe(
          row.getValue(ACTIONS.ACTION_ID),
          row.getValue(ACTIONS.TYPE),
          row.getValue(ACTIONS.CREATED_AT_MILLIS),
          card,
          exposure
      ))
    }
    return actions
  }
}
