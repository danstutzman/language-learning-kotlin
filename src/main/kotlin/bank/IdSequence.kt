package com.danstutzman.bank

class IdSequence {
  var nextId = 1
  fun nextId(): Int = nextId++
}
