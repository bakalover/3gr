import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Arrays;
import java.util.Random;
import java.util.stream.Stream;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import com.testing.merge.MergeSort;

public class MergeTest {
    private static MergeSort<Integer> sorter;

    @BeforeAll
    public static void init() {
        sorter = new MergeSort<>();
    }

    private static Stream<Arguments> pseudoStressProvider() {

        final int testCount = 1500;

        return Stream.generate(() -> {
            Integer[] input = Stream.generate(() -> new Random().nextInt()).limit(testCount).toArray(Integer[]::new);
            Integer[] expected = Arrays.copyOf(input, input.length);
            Arrays.sort(expected);
            return Arguments.of(input, expected);
        }).limit(testCount);
    }

    private static Stream<Arguments> mergeProvider() {

        Integer[] input1 = { 1, 2, 3, 4, 5, 6 };
        Integer[] expected1 = { 1, 2, 3, 4, 5, 6 };
        int l1 = 0, mid1 = 2, r1 = 5;

        Integer[] input2 = { 4, 5, 6, 1, 2, 3 };
        Integer[] expected2 = { 1, 2, 3, 4, 5, 6 };
        int l2 = 0, mid2 = 2, r2 = 5;

        Integer[] input3 = { 0, 0, 0, 0, 0, 0 };
        Integer[] expected3 = { 0, 0, 0, 0, 0, 0 };
        int l3 = 0, mid3 = 2, r3 = 5;

        Integer[] input4 = { 2, 4, 5, 6, 1, 3 };
        Integer[] expected4 = { 1, 2, 3, 4, 5, 6 };
        int l4 = 0, mid4 = 3, r4 = 5;

        Integer[] input5 = { 2, 4, 6, 1, 3, 5 };
        Integer[] expected5 = { 1, 2, 3, 4, 5, 6 };
        int l5 = 0, mid5 = 2, r5 = 5;

        Integer[] input6 = { 1, 0 };
        Integer[] expected6 = { 0, 1 };
        int l6 = 0, mid6 = 0, r6 = 1;

        return Stream.of(
                Arguments.of(input1, expected1, l1, mid1, r1),
                Arguments.of(input2, expected2, l2, mid2, r2),
                Arguments.of(input3, expected3, l3, mid3, r3),
                Arguments.of(input4, expected4, l4, mid4, r4),
                Arguments.of(input5, expected5, l5, mid5, r5),
                Arguments.of(input6, expected6, l6, mid6, r6));
    }

    private static Stream<Arguments> justWorkProvider() {

        Integer[] input1 = { 1, 2345, -1234, 0, 8888 };
        Integer[] expected1 = { -1234, 0, 1, 2345, 8888 };

        Integer[] input2 = { 0, 0, 0, 0, 0 };
        Integer[] expected2 = { 0, 0, 0, 0, 0 };

        Integer[] input3 = { 0 };
        Integer[] expected3 = { 0 };

        Integer[] input4 = {};
        Integer[] expected4 = {};

        Integer[] input5 = null;
        Integer[] expected5 = null;

        return Stream.of(
                Arguments.of(input1, expected1),
                Arguments.of(input2, expected2),
                Arguments.of(input3, expected3),
                Arguments.of(input4, expected4),
                Arguments.of(input5, expected5));
    }

    @ParameterizedTest(name = "JustWork")
    @MethodSource("justWorkProvider")
    public void justWorkTest(Integer[] input, Integer[] expected) {
        sorter.sort(input);
        assertTrue(Arrays.equals(input, expected));
    }

    @ParameterizedTest(name = "DoubleApply")
    @MethodSource("justWorkProvider")
    public void doubleApplyTest(Integer[] input, Integer[] expected) {
        sorter.sort(input);
        sorter.sort(input);
        assertTrue(Arrays.equals(input, expected));
    }

    @ParameterizedTest(name = "Merge")
    @MethodSource("mergeProvider")
    public void mergeTest(Integer[] input, Integer[] expected, int l, int mid, int r) {
        sorter.merge(input, l, mid, r);
        assertTrue(Arrays.equals(input, expected));
    }

    @ParameterizedTest(name = "Stress")
    @MethodSource("pseudoStressProvider")
    public void stressTest(Integer[] input, Integer[] expected) {
        sorter.sort(input);
        assertTrue(Arrays.equals(input, expected));
    }

}
