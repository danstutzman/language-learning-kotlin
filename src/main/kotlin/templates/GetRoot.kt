package com.danstutzman.templates

fun GetRoot(): String {
  val html = StringBuilder()
  html.append(OPEN_BODY_TAG)
  html.append("<li><a href='/cards'>Cards</a></li>\n")
  html.append("<li><a href='/infinitives'>Infinitives</a></li>\n")
  html.append("<li><a href='/nonverbs'>Nonverbs</a></li>\n")
  html.append("<li><a href='/paragraphs'>Paragraphs</a></li>\n")
  html.append("<li><a href='/stem-changes'>Stem Changes</a></li>\n")
  html.append("<li><a href='/unique-conjugations'>Unique Conjugations</a></li>\n")
  html.append(CLOSE_BODY_TAG)
  return html.toString()
}