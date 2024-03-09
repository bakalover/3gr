package com.testing.domain.human;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import com.testing.domain.action.Action;
import com.testing.domain.env.Possibility;
import com.testing.domain.env.thing.IThing;

/**
 * Arthur
 */
public class Arthur implements IHuman, IThing {

    Boolean isStand = false;
    Boolean isTouched = false;

    public void setIsStand(Boolean isStand) {
        this.isStand = isStand;
    }

    public void setIsTouched(Boolean isTouched) {
        this.isTouched = isTouched;
    }

    public Boolean getIsStand() {
        return isStand;
    }

    public Boolean getIsTouched() {
        return isTouched;
    }

    @Override
    public Set<Action> doActions() {
        return new HashSet<>() {
            {
                add(Action.STAND_UP);
                add(Action.TOUCH_SELF);
            }
        };
    }

    public ArrayList<Action> getActions() {
        return new ArrayList<>() {
            {
                add(Action.STAND_UP);
                add(Action.TOUCH_SELF);
            }
        };
    }

    private Set<Possibility> getArthurPos() {
        return new HashSet<>() {
            {
                add(Possibility.AUTH_SMELLS);
                add(Possibility.SEE_ILLUSION);
            }
        };
    }

    @Override
    public Set<Possibility> apply(Action a) {
        switch (a) {
            case STAND_UP:
                if (getIsTouched()) {
                    return getArthurPos();
                } else {
                    setIsStand(true);
                    return new HashSet<>() {
                    };
                }
            case TOUCH_SELF:
                if (getIsStand()) {
                    return getArthurPos();
                } else

                {
                    setIsTouched(true);
                    return new HashSet<>() {
                    };
                }

            default:
                return new HashSet<>();
        }
    }

}