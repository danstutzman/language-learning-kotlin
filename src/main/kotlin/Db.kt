package db

import org.jooq.SQLDialect
import org.jooq.generated.tables.Actions.ACTIONS
import org.jooq.impl.DSL
import java.sql.Connection
import java.sql.Timestamp

data class Action(
    val actionId: Int,
    val createdAt: Timestamp
)

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

  fun createAction(actionId: Int) {
    create
        .insertInto(ACTIONS, ACTIONS.ACTION_ID, ACTIONS.CREATED_AT)
        .values(actionId, now())
        .returning(ACTIONS.ACTION_ID, ACTIONS.CREATED_AT)
        .fetchOne()
        .into(Action::class.java)
  }

  fun findUnsyncedActions(clientIdToMaxSyncedActionId: Map<String, Int>): List<Action> {
    val where = StringBuilder("1=1")
    for ((clientId, maxSyncedActionId) in clientIdToMaxSyncedActionId) {
      where.append("OR (actions.action_id % 10 = $clientId AND actions.action_id > $maxSyncedActionId)")
    }
    val maxClientId = clientIdToMaxSyncedActionId.keys.max()
    where.append("OR (actions.action_id % 10 > $maxClientId)")

    val actions = mutableListOf<Action>()
    val rows = create
        .select(ACTIONS.ACTION_ID, ACTIONS.CREATED_AT)
        .from(ACTIONS)
        .where(where.toString())
        .fetch()
    for (row in rows) {
      actions.add(Action(
          row.getValue(ACTIONS.ACTION_ID),
          row.getValue(ACTIONS.CREATED_AT)))
    }
    return actions
  }
}
