package com.testing.domain.smell;

public class Sweet implements ISmell {

    @Override
    public Boolean auth(Key k) {
        return k.getVal() == Keys.SWEET;
    }

}
