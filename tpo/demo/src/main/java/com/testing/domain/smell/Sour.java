package com.testing.domain.smell;

public class Sour implements ISmell {

    @Override
    public Boolean auth(Key k) {
        return k.getVal() == Keys.SOUR;
    }

}
