import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class TranslateEsToEnTest {
  @Test
  fun testFirst() {
    assertEquals(2, 1 + 1)
  }
}
