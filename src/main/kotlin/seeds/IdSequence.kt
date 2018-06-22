package seeds

class IdSequence {
  var nextId = 1
  fun nextId(): Int = nextId++
}
