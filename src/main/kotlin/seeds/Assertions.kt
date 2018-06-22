package seeds

class Assertions {
  companion object {
		fun <T> assertUniqKeys(pairs: List<Pair<String, T>>) {
			val map = mutableMapOf<String, T>()
			for (pair in pairs) {
				val oldValue = map.get(pair.first)
				if (oldValue != null) {
					throw RuntimeException(
						"Key ${pair.first} has two values: ${oldValue} and ${pair.second}")
				}
				map.put(pair.first, pair.second)
			}
		}
  }
}
