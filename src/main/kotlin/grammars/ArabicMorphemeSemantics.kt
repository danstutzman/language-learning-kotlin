package com.danstutzman.grammars

class ArabicMorphemeSemantics: mouse.runtime.SemanticsBase() {
  //  Sum = Number "+" Number ... "+" Number !_
  fun sum() {
    var s = 0
    for (i in 0..(rhsSize() - 1) step 2) {
      s += rhs(i).get() as Int
    }
    println(s)
  }

  // Number = [0-9] ... [0-9]
  //            0        n-1
  fun number() {
    lhs().put(lhs().text().toInt())
  }
}
