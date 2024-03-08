package com.testing.domain.env;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

import com.testing.domain.action.Action;
import com.testing.domain.env.thing.IThing;
import com.testing.domain.smell.Keys;

public class World implements IWorld {

    private ArrayList<IThing> things;
    private Integer shadowCount;
    private AtomicInteger shadowMovements;
    private ArrayList<Thread> shadows;
    private Integer smellCount = 0;

    private HashSet<Possibility> posb;

    public HashSet<Possibility> getPosb() {
        return posb;
    }

    public AtomicInteger getShadowMovements() {
        return shadowMovements;
    }

    public World(Integer shadowCount, IThing... things) {
        this.shadowCount = shadowCount;
        this.posb = new HashSet<>();
        this.shadows = new ArrayList<>();
        this.shadowMovements = new AtomicInteger(0);
        this.things = new ArrayList<>();
        for (IThing thing : things) {
            this.things.add(thing);
        }
    }

    @Override
    public Set<Keys> apply(Action a) {
        for (IThing thing : things) {
            posb.addAll(thing.apply(a));
        }
        if (posb.contains(Possibility.CAN_FIND_SWITCH)) {
            launchShadows();
        }
        if (posb.contains(Possibility.AUTH_SMELLS)) {
            this.smellCount++;
            if (smellCount % 2 == 0) {
                return new HashSet<>() {
                    {
                        add(Keys.SOUR);
                        add(Keys.SWEET);
                        add(Keys.STINK);
                    }
                };
            } else {
                return new HashSet<>() {
                    {
                        add(Keys.SWEET);
                        add(Keys.STINK);
                    }
                };
            }
        }
        return null;
    }

    @Override
    public Boolean isPermit(Possibility p) {
        return this.posb.contains(p);
    }

    private void launchShadows() {
        for (int i = 0; i < this.shadowCount; i++) {
            Thread thread = new Thread(() -> {
                this.shadowMovements.incrementAndGet();
            });
            thread.start();
            this.shadows.add(thread);
        }
    }

    @Override
    public Integer AwaitShadows() {
        for (Thread t : this.shadows) {
            try {
                t.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return this.shadowMovements.get();
    }

}
