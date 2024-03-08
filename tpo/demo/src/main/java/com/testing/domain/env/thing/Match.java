package com.testing.domain.env.thing;

import java.util.HashSet;
import java.util.Set;

import com.testing.domain.action.Action;
import com.testing.domain.env.Possibility;

public class Match implements IThing {

    private Boolean isFired = false;

    public Boolean getIsFired() {
        return isFired;
    }

    @Override
    public Set<Possibility> apply(Action a) {
        if (a == Action.FIRE_MATCH) {
            isFired = true;
            return new HashSet<>() {
                {
                    add(Possibility.CAN_FIND_SWITCH);
                }
            };
        } else {
            return new HashSet<>();
        }
    }

}
