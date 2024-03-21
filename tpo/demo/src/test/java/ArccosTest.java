
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Arrays;
import java.util.Random;
import java.util.stream.Stream;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.CsvFileSource;

import com.testing.arccos.Arccos;

public class ArccosTest {

    private static Arccos eval;

    @BeforeAll
    public static void init() {
        eval = new Arccos();
    }

    @ParameterizedTest(name = "JustWork")
    @CsvFileSource(resources = "arccosData.csv")
    public void justWorkTest(Double input, Double expected) {
        assertEquals(expected, eval.calculate(input), eval.error());
    }

    @ParameterizedTest(name = "OutOfRange")
    @CsvFileSource(resources = "arccosFaultyData.csv")
    public void outOfRangeTest(Double input) {
        assertThrows(IllegalArgumentException.class, () -> eval.calculate(input));
    }

    @ParameterizedTest(name = "MonoWork")
    @CsvFileSource(resources = "arccosData.csv")
    public void monoTest() {
        Double l = -0.5, m = 0.0, r = 0.5;
        assertTrue(eval.calculate(r) < eval.calculate(m) && eval.calculate(m)< eval.calculate(l));
    }

    @Test
    public void nullCheckTest() {
        assertThrows(NullPointerException.class, () -> eval.calculate(null));
    }

}