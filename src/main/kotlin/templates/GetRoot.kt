package com.danstutzman.templates

fun GetRoot(): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<li><a href='/cards'>Cards</a></li>\n")
  html.append("<li><a href='/es/infinitives'>Spanish Infinitives</a></li>\n")
  html.append("<li><a href='/es/nonverbs'>Spanish Nonverbs</a></li>\n")
  html.append("<li><a href='/paragraphs'>Paragraphs</a></li>\n")
  html.append("<li><a href='/es/stem-changes'>Spanish Stem Changes</a></li>\n")
  html.append("<li><a href='/es/unique-conjugations'>Spanish Unique Conjugations</a></li>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}