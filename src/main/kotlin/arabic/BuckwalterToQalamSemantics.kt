package com.danstutzman.arabic

@Suppress("UNCHECKED_CAST")
class BuckwalterToQalamSemantics: mouse.runtime.SemanticsBase() {
  var qalam: String? = null

  fun StartOnly() { qalam = rhs(0).get() as String }
  fun StartFirstCVV() {
    qalam = (0..rhsSize() - 1).map { i -> rhs(i).get() }.joinToString("")
  }

  fun Onlyatotoat() { lhs().put("at") }
  fun Onlyaiu() { lhs().put(rhs(0).text()) }
  fun OnlyPunctuation() { lhs().put(rhs(0).text()) }
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

  fun CVVDollartosh() { lhs().put("sh" + rhs(1).get()!!) }
  fun CVVAsterisktodh() { lhs().put("dh" + rhs(1).get()!!) }
  fun CVVgtogh() { lhs().put("gh" + rhs(1).get()!!) }
  fun CVVvtoth() { lhs().put("th" + rhs(1).get()!!) }
  fun CVVLessThantoQuote() { lhs().put("'" + rhs(1).get()!!) }
  fun CVVGreaterThanotoQuote() { lhs().put("'") }
  fun CVVGreaterThan1toQuote() { lhs().put("'") }
  fun CVVGreaterThan2toQuoteu() {
    lhs().put("'" + if (rhs(1).get()!! != "") rhs(1).get() else "u")
  }
  fun CVVPipetoQuoteaa() { lhs().put("'aa") }
  fun CVVCloseCurlytoQuote() { lhs().put("'" + rhs(1).get()!!) }
  fun CVVQuotetoQuote() { lhs().put("'" + rhs(1).get()!!) }
  fun CVVAmpersandtoQuote() { lhs().put("'" + rhs(1).get()!!) }
  fun CVVEtoc() { lhs().put("c" + rhs(1).get()!!) }
  fun CVVptoh() { lhs().put("h" + rhs(1).get()!! + rhs(2).get()!!) }
  fun CVVwAtowaa() { lhs().put("waa" + rhs(2).get()!!) }
  fun CVVwYtowae() { lhs().put("wae" + rhs(2).get()!!) }
  fun CVVwotow() { lhs().put("w") }
  fun CVVwytowii() { lhs().put("wii") }
  fun CVVwtow() { lhs().put("w" + if (rhsSize() == 2) rhs(1).text()!! else "") }
  fun CVVhtoh() { lhs().put("h" + rhs(1).get()!!) }
  fun CVVyytoyy() { lhs().put("yy" + rhs(1).get()!!) }
  fun CVVCVV() { lhs().put(rhs(0).get() as String + rhs(1).get()!!) }

  fun C() { lhs().put(rhs(0).text()) }

  fun VVOtoEmpty() { lhs().put("") }
  fun VVwAtouuaa() { lhs().put("uuaa") }
  fun VVwtouu() { lhs().put("uu") }
  fun VVAFtoaaN() { lhs().put("aaN") }
  fun VVAtoaa() { lhs().put("aa") }
  fun VVKtoiN() { lhs().put("iN") }
  fun VVytoii() { lhs().put("ii") }
  fun VVYtoae() { lhs().put("ae" + rhs(1).get()) }
  fun VVBacktickAmpersandtoAQuoteu() { lhs().put("A'u") }
  fun VVBacktickToA() { lhs().put("A") }
  fun VViytoii() { lhs().put("ii") }
  fun VVaiu() { lhs().put(rhs(0).text()) }
  fun VVEMPTY() { lhs().put("") }

  fun TanweenFtoN() { lhs().put("N") }
  fun TanweenNtoN() { lhs().put("N") }
  fun TanweenEMPTY() { lhs().put("") }
}
