import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance
import com.danstutzman.arabic.splitQalamIntoAtoms

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class SplitQalamIntoAtomsTest {
  @Test
  fun testSplitsQalamIntoAtoms() {
    assertEquals(listOf<String>(), splitQalamIntoAtoms(""))
    assertEquals(listOf("a"), splitQalamIntoAtoms("a"))
    assertEquals(listOf("s", "a"), splitQalamIntoAtoms("sa"))
    assertEquals(listOf("a", "sh"), splitQalamIntoAtoms("ash"))
    assertEquals(listOf("sh", "a"), splitQalamIntoAtoms("sha"))
    assertEquals(listOf("sh", "sh"), splitQalamIntoAtoms("shsh"))
    assertEquals(listOf("s", "a", "h"), splitQalamIntoAtoms("sah"))
    assertEquals(listOf("h", "a", "s"), splitQalamIntoAtoms("has"))
  }
}
