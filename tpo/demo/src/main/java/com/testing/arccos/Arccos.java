package com.testing.arccos;

import java.util.AbstractMap.SimpleEntry;
import java.util.ArrayList;
import java.util.List;

public class Arccos {
    private static final List<SimpleEntry<Integer, Integer>> coefs = new ArrayList<>() {
        {
            add(new SimpleEntry<>(1, 1));
            add(new SimpleEntry<>(1, 6));
            add(new SimpleEntry<>(3, 40));
            add(new SimpleEntry<>(5, 112));
            add(new SimpleEntry<>(35, 1152));
            add(new SimpleEntry<>(63, 2816));

        }
    };

    public Double error() {
        return 1.0;
    }

    public Double calculate(Double x) throws IllegalArgumentException {
        if (x > 1 || x < -1) {
            throw new IllegalArgumentException("Illegal argument!");
        }

        Integer powCoef = 1;
        Double ans = Math.PI / 2.0;

        for (SimpleEntry<Integer, Integer> coef : coefs) {
            ans -= coef.getKey() * Math.pow(x, powCoef) / coef.getValue();
            powCoef += 2;
        }

        return ans;
    }
}
