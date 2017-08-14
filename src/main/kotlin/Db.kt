package db

import com.google.gson.Gson
import org.jooq.SQLDialect
import org.jooq.generated.tables.Actions.ACTIONS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Action(
    val actionId: Int,
    val type: String,
    val createdAtMillis: Long,
    val cardJson: String?
)

data class CardUnsafe(
    val type: String?,
    val gender: String?,
    val es: String,
    val en: String
)

data class ActionUnsafe(
    val actionId: Int?,
    val type: String?,
    val createdAtMillis: Long?,
    val card: CardUnsafe?
) {
  fun toSafe(): Action {
    return Action(
        actionId!!,
        type!!,
        createdAtMillis!!,
        if (card != null) Gson().toJson(card) else null
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
            ACTIONS.CARD_JSON)
        .values(action.actionId,
            action.type,
            action.createdAtMillis,
            action.cardJson)
        .returning(
            ACTIONS.ACTION_ID,
            ACTIONS.TYPE,
            ACTIONS.CREATED_AT_MILLIS,
            ACTIONS.CARD_JSON)
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
            ACTIONS.CARD_JSON)
        .from(ACTIONS)
        .where(where.toString())
        .fetch()
    for (row in rows) {
      val cardJson: String? = row.getValue(ACTIONS.CARD_JSON)
      val card: CardUnsafe? =
          if (cardJson != null) {
            Gson().fromJson<CardUnsafe>(cardJson, CardUnsafe::class.java)
          } else {
            null
          }
      actions.add(ActionUnsafe(
          row.getValue(ACTIONS.ACTION_ID),
          row.getValue(ACTIONS.TYPE),
          row.getValue(ACTIONS.CREATED_AT_MILLIS),
          card
      ))
    }
    return actions
  }
}
