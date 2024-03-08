
package com.testing.domain.env;

import com.testing.domain.action.Action;

interface IWorld {
    public Object apply(Action a);

    public Integer AwaitShadows();

    public Boolean isPermit(Possibility p);
}