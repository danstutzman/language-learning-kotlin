package db

import org.jooq.SQLDialect
import org.jooq.generated.tables.Actions.ACTIONS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Action(
    val actionId: Int,
    val type: String
)

data class ActionUnsafe(
    val actionId: Int?,
    val type: String?
) {
  fun toSafe(): Action {
    return Action(
        actionId!!,
        type!!)
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

  fun createAction(actionId: Int, type: String) {
    create
        .insertInto(ACTIONS,
            ACTIONS.ACTION_ID,
            ACTIONS.TYPE)
        .values(actionId, type)
        .returning(
            ACTIONS.ACTION_ID,
            ACTIONS.TYPE)
        .fetchOne()
  }

  fun findUnsyncedActions(clientIdToMaxSyncedActionId: Map<Int, Int>): List<Action> {
    val where = StringBuilder("0=1")
    for ((clientId, maxSyncedActionId) in clientIdToMaxSyncedActionId) {
      where.append(" OR (actions.action_id % 10 = $clientId AND actions.action_id > $maxSyncedActionId)")
    }
    val maxClientId: Int = clientIdToMaxSyncedActionId.keys.max() ?: -1
    where.append(" OR (actions.action_id % 10 > $maxClientId)")

    val actions = mutableListOf<Action>()
    val rows = create
        .select(ACTIONS.ACTION_ID, ACTIONS.TYPE)
        .from(ACTIONS)
        .where(where.toString())
        .fetch()
    for (row in rows) {
      actions.add(ActionUnsafe(
          row.getValue(ACTIONS.ACTION_ID),
          row.getValue(ACTIONS.TYPE)
      ).toSafe())
    }
    return actions
  }
}
