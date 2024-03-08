package com.testing.domain.smell;

public class Stink implements ISmell {

    @Override
    public Boolean auth(Key k) {
        return k.getVal() == Keys.STINK;
    }

}
