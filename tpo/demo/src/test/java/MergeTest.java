import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import com.testing.arccos.Arccos;
import com.testing.merge.MergeSort;

public class MergeTest {
    private static MergeSort<Integer> sorter;

    @BeforeAll
    public static void init() {
        sorter = new MergeSort<>();
    }

    private static Stream<Arguments> justWorkProvider() {
        Integer[] input1 = { 1, 2345, -1234, 0, 8888 };
        Integer[] expected1 = { -1234, 0, 1, 2345, 8888 };

        Integer[] input2 = { 0, 0, 0, 0, 0 };
        Integer[] expected2 = { 0, 0, 0, 0, 0 };

        Integer[] input3 = {};
        Integer[] expected3 = {};
        return Stream.of(
                Arguments.of(input1, expected1),
                Arguments.of(input2, expected2),
                Arguments.of(input3, expected3));
    }

    @ParameterizedTest(name = "JustWork")
    @MethodSource("justWorkProvider")
    public void justWorkTest(Integer[] input, Integer[] expected) {
        sorter.sort(input);
        assertTrue(Arrays.equals(input, expected));
    }

}
