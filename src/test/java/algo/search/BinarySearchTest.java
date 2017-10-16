package algo.search;

import org.junit.Test;

import static java.lang.String.format;

/**
 * Created by liyanan on 10/13/17 7:57 PM @iCarbonX.
 */
public class BinarySearchTest {
    @Test
    public void shouldEqual() {
        int a = 1;
        int b = 1;
        if (a == b) {
            throw new AssertionError(format(
                    "%d , %d", a, b
            ));
        }
    }

    @Test
    public void shouldEqual1() {
        int a = 1;
        int b = 2;
        if (a == b) {
            throw new AssertionError(format(
                    "%d , %d", a, b
            ));
        }
    }
}
