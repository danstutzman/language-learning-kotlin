package com.danstutzman.templates

val OPEN_BODY_TAG = """
  <html>
    <head>
      <link rel='stylesheet' type='text/css' href='/style.css'>
      <script src='/script.js'></script>
      <meta name='viewport' content='width=device-width, initial-scale=1'>
    </head>
    <body>"""

val CLOSE_BODY_TAG = "</body></html>"

fun escapeHTML(s: String): String {
  val out = StringBuilder(Math.max(16, s.length))
  for (c in s) {
    if (c.toInt() > 127 ||
      c == '"' ||
      c == '<' ||
      c == '>' ||
      c == '&' ||
      c == '\'') {
      out.append("&#")
      out.append(c.toInt())
      out.append(';')
    } else {
      out.append(c)
    }
  }
  return out.toString()
}