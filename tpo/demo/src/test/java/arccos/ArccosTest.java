package arccos;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvFileSource;

import com.testing.arccos.Arccos;

public class ArccosTest {

    private static Arccos eval;

    @BeforeAll
    public static void init() {
        eval = new Arccos();
    }

    @ParameterizedTest(name = "JustWork")
    @CsvFileSource(resources = "/arccos/arccosData.csv")
    public void justWorkTest(Double input, Double expected) {
        assertEquals(expected, eval.calculate(input), eval.error());
    }

    @ParameterizedTest(name = "OutOfRange")
    @CsvFileSource(resources = "/arccos/arccosFaultyData.csv")
    public void outOfRangeTest(Double input) {
        assertThrows(IllegalArgumentException.class, () -> eval.calculate(input));
    }

    @Test
    public void nullCheckTest() {
        assertThrows(NullPointerException.class, () -> eval.calculate(null));
    }

}