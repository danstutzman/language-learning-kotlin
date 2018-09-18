package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.NewCards.NEW_CARDS
import org.jooq.impl.DSL

data class NewCardRow(
  val newCardId: Int,
  val lang: String,
  val type: String,
  val enTask: String,
  val enContent: String,
  val morphemeIdsCsv: String
)

class NewCardsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  fun selectByLang(lang: String) : List<NewCardRow> =
    create
      .select(
        NEW_CARDS.ID,
        NEW_CARDS.LANG,
        NEW_CARDS.TYPE,
        NEW_CARDS.EN_TASK,
        NEW_CARDS.EN_CONTENT,
        NEW_CARDS.MORPHEME_IDS_CSV)
      .from(NEW_CARDS)
      .where(NEW_CARDS.LANG.eq(lang))
      .fetch()
      .map {
        NewCardRow(
          it.getValue(NEW_CARDS.ID),
          it.getValue(NEW_CARDS.LANG),
          it.getValue(NEW_CARDS.TYPE),
          it.getValue(NEW_CARDS.EN_TASK),
          it.getValue(NEW_CARDS.EN_CONTENT),
          it.getValue(NEW_CARDS.MORPHEME_IDS_CSV))
      }

  fun insert(newCard: NewCardRow) =
    create.insertInto(NEW_CARDS,
      NEW_CARDS.LANG,
      NEW_CARDS.TYPE,
      NEW_CARDS.EN_TASK,
      NEW_CARDS.EN_CONTENT,
      NEW_CARDS.MORPHEME_IDS_CSV)
    .values(newCard.lang,
      newCard.type,
      newCard.enTask,
      newCard.enContent,
      newCard.morphemeIdsCsv)
    .returning(
      NEW_CARDS.LANG,
      NEW_CARDS.TYPE,
      NEW_CARDS.EN_TASK,
      NEW_CARDS.EN_CONTENT,
      NEW_CARDS.MORPHEME_IDS_CSV)
    .fetchOne()

  fun delete(newCardId: Int) =
    create.delete(NEW_CARDS)
      .where(NEW_CARDS.ID.eq(newCardId))
      .execute()
}