package com.testing.domain.human;

import java.util.HashSet;
import java.util.Set;

import com.testing.domain.action.Action;

public class Ford implements IHuman {

    @Override
    public Set<Action> doActions() {
        return new HashSet<>() {
            {
                add(Action.FIRE_MATCH);
            }
        };
    }

}
