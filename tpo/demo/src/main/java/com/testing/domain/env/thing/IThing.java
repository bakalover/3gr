package com.testing.domain.env.thing;

import java.util.Set;

import com.testing.domain.action.Action;
import com.testing.domain.env.Possibility;

public interface IThing {
    public Set<Possibility> apply(Action a);
}
