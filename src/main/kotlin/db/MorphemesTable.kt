package com.danstutzman.db

import java.sql.Connection
import java.sql.Timestamp
import org.jooq.SQLDialect
import org.jooq.generated.tables.Morphemes.MORPHEMES
import org.jooq.impl.DSL

data class Morpheme(
  val morphemeId: Int,
  val lang: String,
  val type: String,
  val l2: String,
  val gloss: String
)

class MorphemesTable (
  private val conn: Connection
) {
  private val create = DSL.using(conn, SQLDialect.POSTGRES_9_5)

  fun findExisting(morpheme: Morpheme): Morpheme? =
    create
      .select(MORPHEMES.ID,
        MORPHEMES.LANG,
        MORPHEMES.TYPE,
        MORPHEMES.L2,
        MORPHEMES.GLOSS)
      .from(MORPHEMES)
      .where(MORPHEMES.LANG.eq(morpheme.lang))
      .and(MORPHEMES.TYPE.eq(morpheme.type))
      .and(MORPHEMES.L2.eq(morpheme.l2))
      .and(MORPHEMES.GLOSS.eq(morpheme.gloss))
      .fetchOne()
      ?.map {
        Morpheme(
          it.getValue(MORPHEMES.ID),
          it.getValue(MORPHEMES.LANG),
          it.getValue(MORPHEMES.TYPE),
          it.getValue(MORPHEMES.L2),
          it.getValue(MORPHEMES.GLOSS))
      }

  fun selectByLang(lang: String) : List<Morpheme> =
    create
      .select(
        MORPHEMES.ID,
        MORPHEMES.LANG,
        MORPHEMES.TYPE,
        MORPHEMES.L2,
        MORPHEMES.GLOSS)
      .from(MORPHEMES)
      .where(MORPHEMES.LANG.eq(lang))
      .orderBy(MORPHEMES.ID)
      .fetch()
      .map {
        Morpheme(
          it.getValue(MORPHEMES.ID),
          it.getValue(MORPHEMES.LANG),
          it.getValue(MORPHEMES.TYPE),
          it.getValue(MORPHEMES.L2),
          it.getValue(MORPHEMES.GLOSS))
      }

  fun selectWithMorphemeIdIn(morphemeIds: List<Int>): List<Morpheme> =
    create.select(
      MORPHEMES.ID,
      MORPHEMES.LANG,
      MORPHEMES.TYPE,
      MORPHEMES.L2,
      MORPHEMES.GLOSS)
    .from(MORPHEMES)
    .where(MORPHEMES.ID.`in`(morphemeIds))
    .fetch()
    .map { 
      Morpheme(
        it.getValue(MORPHEMES.ID),
        it.getValue(MORPHEMES.LANG),
        it.getValue(MORPHEMES.TYPE),
        it.getValue(MORPHEMES.L2),
        it.getValue(MORPHEMES.GLOSS))
    }

  fun insert(morpheme: Morpheme): Morpheme =
    create.insertInto(MORPHEMES,
      MORPHEMES.LANG,
      MORPHEMES.TYPE,
      MORPHEMES.L2,
      MORPHEMES.GLOSS)
    .values(morpheme.lang,
      morpheme.type,
      morpheme.l2,
      morpheme.gloss)
    .returning(
      MORPHEMES.ID,
      MORPHEMES.LANG,
      MORPHEMES.TYPE,
      MORPHEMES.L2,
      MORPHEMES.GLOSS)
    .fetchOne()
    .let {
      Morpheme(
        it.getValue(MORPHEMES.ID),
        it.getValue(MORPHEMES.LANG),
        it.getValue(MORPHEMES.TYPE),
        it.getValue(MORPHEMES.L2),
        it.getValue(MORPHEMES.GLOSS)
      )
    }

  fun updateL2(morphemeId: Int, l2: String) =
    create.update(MORPHEMES)
      .set(MORPHEMES.L2, l2)
      .where(MORPHEMES.ID.eq(morphemeId))
      .execute()

  fun delete(morphemeId: Int) =
    create.delete(MORPHEMES)
      .where(MORPHEMES.ID.eq(morphemeId))
      .execute()
}
