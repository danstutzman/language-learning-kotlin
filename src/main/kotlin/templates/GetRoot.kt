package com.danstutzman.templates

fun GetRoot(): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)

  html.append("<h2>Arabic</h2>\n")
  html.append("<li><a href='/ar/nonverbs'>Nonverbs</a></li>\n")
  html.append("<li><a href='/ar/paragraphs'>Paragraphs</a></li>\n")
  html.append("<li><a href='/ar/verb-roots'>Verb Roots</a></li>\n")

  html.append("<h2>French</h2>\n")
  html.append("<li><a href='/fr/infinitives'>Infinitives</a></li>\n")
  html.append("<li><a href='/fr/nonverbs'>Nonverbs</a></li>\n")
  html.append("<li><a href='/fr/paragraphs'>Paragraphs</a></li>\n")
  html.append("<li><a href='/fr/stem-changes'>Stem Changes</a></li>\n")
  html.append("<li><a href='/fr/unique-conjugations'>Unique Conjugations</a></li>\n")

  html.append("<h2>Spanish</h2>\n")
  html.append("<li><a href='/es/infinitives'>Infinitives</a></li>\n")
  html.append("<li><a href='/es/nonverbs'>Nonverbs</a></li>\n")
  html.append("<li><a href='/es/paragraphs'>Paragraphs</a></li>\n")
  html.append("<li><a href='/es/stem-changes'>Stem Changes</a></li>\n")
  html.append("<li><a href='/es/unique-conjugations'>Unique Conjugations</a></li>\n")

  html.append(CLOSE_BODY_TAG)
  return html.toString()
}