package com.testing.domain.human;

import java.util.Set;

import com.testing.domain.action.Action;

/**
 * IHuman
 */
public interface IHuman {
    public Set<Action> doActions();
}