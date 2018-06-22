package com.danstutzman.es

import com.danstutzman.bank.Assertions
import com.danstutzman.bank.IdSequence

private data class D(
  val es: String,
  val en: String,
  val infKey: String,
  val number: Int,
  val person: Int,
  val tense: Tense,
  val enDisambiguation: String?
) {}

val PRES = Tense.PRES
val PRET = Tense.PRET

private val uniqVsWithoutIds = listOf(
  D("soy",       "am",   "ser",     1, 1, PRES, "what"),
  D("eres",      "are",  "ser",     1, 2, PRES, "what"),
  D("es",        "is",   "ser",     1, 3, PRES, "what"),
  D("somos",     "are",  "ser",     2, 1, PRES, "what"),
  D("son",       "are",  "ser",     2, 3, PRES, "what"),
  D("fui",       "was",  "ser",     1, 1, PRET, "what"),
  D("fuiste",    "were", "ser",     1, 2, PRET, "what"),
  D("fue",       "was",  "ser",     1, 3, PRET, "what"),
  D("fuimos",    "were", "ser",     2, 1, PRET, "what"),
  D("fueron",    "were", "ser",     2, 3, PRET, "what"),
  D("estoy",     "am",   "estar",   1, 1, PRES, "how"),
  D("estás",     "are",  "estar",   1, 2, PRES, "how"),
  D("está",      "is",   "estar",   1, 3, PRES, "how"),
  D("están",     "are",  "estar",   2, 3, PRES, "how"),
  D("tengo",     "have", "tener",   1, 1, PRES, null),
  D("hago",      "do",   "hacer",   1, 1, PRES, null),
  D("digo",      "say",  "decir",   1, 1, PRES, null),
  D("dijeron",   "said", "decir",   2, 3, PRET, null),
  D("voy",       "go",   "ir",      1, 1, PRES, null),
  D("vas",       "go",   "ir",      1, 2, PRES, null),
  D("va",        "goes", "ir",      1, 3, PRES, null),
  D("vamos",     "go",   "ir",      2, 1, PRES, null),
  D("van",       "go",   "ir",      2, 3, PRES, null),
  D("fui",       "went", "ir",      1, 1, PRET, null),
  D("fuiste",    "went", "ir",      1, 2, PRET, null),
  D("fue",       "went", "ir",      1, 3, PRET, null),
  D("fuimos",    "went", "ir",      2, 1, PRET, null),
  D("fueron",    "went", "ir",      2, 3, PRET, null),
  D("veo",       "see",  "ver",     1, 1, PRES, null),
  D("vi",        "saw",  "ver",     1, 1, PRET, null),
  D("vio",       "saw",  "ver",     1, 3, PRET, null),
  D("vimos",     "saw",  "ver",     2, 1, PRET, null),
  D("doy",       "give", "dar",     1, 1, PRES, null),
  D("di",        "gave", "dar",     1, 1, PRET, null),
  D("diste",     "gave", "dar",     1, 2, PRET, null),
  D("dio",       "gave", "dar",     1, 3, PRET, null),
  D("dimos",     "gave", "dar",     2, 1, PRET, null),
  D("dieron",    "gave", "dar",     2, 3, PRET, null),
  D("sé",        "know", "saber",   1, 1, PRES, "thing"),
  D("pongo",     "put",  "poner",   1, 1, PRES, null),
  D("vengo",     "come", "venir",   1, 1, PRES, null),
  D("salgo",   "go out",    "salir",   1, 1, PRES, null),
  D("parezco", "look like", "parecer", 1, 1, PRES, null),
  D("conozco", "know",      "conocer", 1, 1, PRES, "person"),
  D("empecé",  "started",   "empezar", 1, 1, PRET, null),
  D("envío",   "sent",      "enviar",  1, 1, PRES, null),
  D("envías",  "sent",      "enviar",  1, 2, PRES, null),
  D("envía",   "sent",      "enviar",  1, 3, PRES, null),
  D("envían",  "sent",      "enviar",  2, 1, PRES, null)
)

class UniqVList {
  val uniqVs: List<UniqV>
  val uniqVByKey: Map<String, UniqV>

  constructor(cardIdSequence: IdSequence, infList: InfList) {
    uniqVs = uniqVsWithoutIds.map {
      UniqV(
        cardId = cardIdSequence.nextId(),
        es = it.es,
        en = it.en,
        inf = infList.byKey(it.infKey),
        number = it.number,
        person = it.person,
        tense = it.tense,
        enDisambiguation = it.enDisambiguation
      )
    }
    val uniqVByQuestion = Assertions.assertUniqKeys(
      uniqVs.map { Pair(it.getQuizQuestion(), it) })
    uniqVByKey = uniqVs.map { Pair(it.getKey(), it) }.toMap()
  }
  fun byKey(key: String): UniqV = uniqVByKey[key]!!
}
