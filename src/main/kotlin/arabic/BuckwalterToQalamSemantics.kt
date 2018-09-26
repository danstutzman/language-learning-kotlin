package com.danstutzman.arabic

@Suppress("UNCHECKED_CAST")
class BuckwalterToQalamSemantics: mouse.runtime.SemanticsBase() {
  var qalam: String? = null

  fun Start() {
    qalam = (1..rhsSize() - 1).map { i -> rhs(i).get() }.joinToString()
  }

  fun Onlyatotoat() { lhs().put("at") }
  fun Onlyynatoiina() { lhs().put("iina") }
  fun Onlyytoii() { lhs().put("ii") }
  fun OnlyKtoiN() { lhs().put("iN") }
  fun OnlyNtouN() { lhs().put("uN") }
  fun OnlyAFtoaN() { lhs().put("aN") }
  fun OnlywAtouuaa() { lhs().put("uuaa") }
  fun Onlywnatouuna() { lhs().put("uuna") }
  fun Onlywtouu() { lhs().put("uu") }
  fun OnlyOpenCurlylConsonanttoelConsonant() { lhs().put("el" + rhs(1).text()) }

  fun FirstOpenCurlyltoel() { lhs().put("el") }
  fun FirstOpenCurlytoe() { lhs().put("e") }
  fun FirstGreaterThantoQuoteal() { lhs().put("'al") }

  fun CVVDollartosh() { lhs().put("sh" + rhs(1).text()) }
  fun CVVAsterisktodh() { lhs().put("dh" + rhs(1).text()) }
  fun CVVgtogh() { lhs().put("gh" + rhs(1).text()) }
  fun CVVvtoth() { lhs().put("th" + rhs(1).text()) }
  fun CVVLessThantoQuote() { lhs().put("'" + rhs(1).text()) }
  fun CVVGreaterThanotoQuote() { lhs().put("'") }
  fun CVVGreaterThan1toQuote() { lhs().put("'") }
  fun CVVGreaterThan2toQuoteu() {
    lhs().put("'" + if (rhs(1).text() != "") rhs(1).text() else "u")
  }
  fun CVVPipetoQuoteaa() { lhs().put("'aa") }
  fun CVVCloseCurlytoQuote() { lhs().put("'" + rhs(1).text()) }
  fun CVVQuotetoQuote() { lhs().put("'" + rhs(1).text()) }
  fun CVVAmpersandtoQuote() { lhs().put("'" + rhs(1).text()) }
  fun CVVEtoc() { lhs().put("c" + rhs(1).text()) }
  fun CVVptoh() { lhs().put("h" + rhs(1).text() + rhs(2).text()) }
  fun CVVwAtowaa() { lhs().put("waa" + rhs(1).text()) }
  fun CVVwYtowae() { lhs().put("waa" + rhs(1).text()) }
  fun CVVwotow() { lhs().put("w") }
  fun CVVwytowii() { lhs().put("wii") }
  fun CVVwtow() { lhs().put("w" + if (rhs(1) != null) rhs(1).text() else "") }
  fun CVVhtoh() { lhs().put("h" + rhs(1).text()) }
  fun CVVyytoyy() { lhs().put("yy" + rhs(1).text()) }
  fun CVVCVV() { lhs().put(rhs(0).text() + rhs(1).text()) }

  fun VVOtoEmpty() { lhs().put("") }
  fun VVwAtouuaa() { lhs().put("uuaa") }
  fun VVwtouu() { lhs().put("uu") }
  fun VVAFtoaaN() { lhs().put("aaN") }
  fun VVAtoaa() { lhs().put("aa") }
  fun VVKtoiN() { lhs().put("iN") }
  fun VVytoii() { lhs().put("i") }
  fun VVYtoae() { lhs().put("ae" + rhs(1).text()) }
  fun VVBacktickAmpersandtoAQuoteu() { lhs().put("A'u") }
  fun VVBacktickToA() { lhs().put("A") }
  fun VViytoii() { lhs().put("i") }
  fun VVEMPTY() { lhs().put("") }

  fun TanweenFtoN() { lhs().put("N") }
  fun TanweenNtoN() { lhs().put("N") }
  fun TanweenEMPTY() { lhs().put("N") }
}
