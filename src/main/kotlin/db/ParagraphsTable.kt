package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Paragraphs.PARAGRAPHS
import org.jooq.impl.DSL

data class Paragraph(
  val paragraphId: Int,
  val lang: String,
  val topic: String,
  val enabled: Boolean
)

class ParagraphsTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  private fun now() = Timestamp(System.currentTimeMillis().toLong())

  fun selectForLang(lang: String) : List<Paragraph> =
    create
      .select(
        PARAGRAPHS.PARAGRAPH_ID,
        PARAGRAPHS.LANG,
        PARAGRAPHS.TOPIC,
        PARAGRAPHS.ENABLED)
      .from(PARAGRAPHS)
      .where(PARAGRAPHS.LANG.eq(lang))
      .fetch()
      .map {
        Paragraph(
          it.getValue(PARAGRAPHS.PARAGRAPH_ID),
          it.getValue(PARAGRAPHS.LANG),
          it.getValue(PARAGRAPHS.TOPIC),
          it.getValue(PARAGRAPHS.ENABLED))
      }

  fun selectById(paragraphId: Int) : Paragraph? =
    create
      .select(
        PARAGRAPHS.PARAGRAPH_ID,
        PARAGRAPHS.LANG,
        PARAGRAPHS.TOPIC,
        PARAGRAPHS.ENABLED)
      .from(PARAGRAPHS)
      .where(PARAGRAPHS.PARAGRAPH_ID.eq(paragraphId))
      .fetchOne()
      ?.let {
        Paragraph(
          it.getValue(PARAGRAPHS.PARAGRAPH_ID),
          it.getValue(PARAGRAPHS.LANG),
          it.getValue(PARAGRAPHS.TOPIC),
          it.getValue(PARAGRAPHS.ENABLED))
      }

  fun insert(paragraph: Paragraph): Paragraph =
    create.insertInto(
      PARAGRAPHS,
      PARAGRAPHS.LANG,
      PARAGRAPHS.TOPIC,
      PARAGRAPHS.UPDATED_AT)
      .values(
        paragraph.lang,
        paragraph.topic,
        now())
      .returning(
        PARAGRAPHS.PARAGRAPH_ID,
        PARAGRAPHS.LANG,
        PARAGRAPHS.TOPIC,
        PARAGRAPHS.ENABLED)
      .fetchOne().let {
        Paragraph(
          it.getValue(PARAGRAPHS.PARAGRAPH_ID),
          it.getValue(PARAGRAPHS.LANG),
          it.getValue(PARAGRAPHS.TOPIC),
          it.getValue(PARAGRAPHS.ENABLED)
        )
      }

  fun update(paragraph: Paragraph) =
    create.update(PARAGRAPHS)
      .set(PARAGRAPHS.LANG, paragraph.lang)
      .set(PARAGRAPHS.TOPIC, paragraph.topic)
      .set(PARAGRAPHS.ENABLED, paragraph.enabled)
      .set(PARAGRAPHS.UPDATED_AT, now())
      .where(PARAGRAPHS.PARAGRAPH_ID.eq(paragraph.paragraphId))
      .execute()

  fun delete(paragraphId: Int) =
    create.delete(PARAGRAPHS)
      .where(PARAGRAPHS.PARAGRAPH_ID.eq(paragraphId))
      .execute()
}