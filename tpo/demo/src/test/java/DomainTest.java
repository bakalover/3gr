import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Timeout;

import com.testing.domain.action.Action;
import com.testing.domain.env.Possibility;
import com.testing.domain.env.World;
import com.testing.domain.env.thing.Match;
import com.testing.domain.human.Arthur;
import com.testing.domain.human.Ford;
import com.testing.domain.smell.Key;
import com.testing.domain.smell.Keys;
import com.testing.domain.smell.Sour;

public class DomainTest {
    private static World world;

    private final int shadows = 1000;

    @Test
    public void fordWorld() {
        var ford = new Ford();
        var match = new Match();
        world = new World(shadows, match);

        assertFalse(match.getIsFired());
        for (Action a : ford.doActions()) {
            assertNull(world.apply(a));
        }
        assertTrue(match.getIsFired());

        assertTrue(world.isPermit(Possibility.CAN_FIND_SWITCH));
        assertFalse(world.isPermit(Possibility.AUTH_SMELLS));
        assertFalse(world.isPermit(Possibility.SEE_ILLUSION));

        world.AwaitShadows();

        assertEquals(world.getShadowMovements().get(), shadows);
    }

    @Test
    public void arthurForwardWorld() {
        var arthur = new Arthur();
        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur);

        ArrayList<Action> acts = arthur.getActions();

        for (int i = 0; i < acts.size(); i++) {
            keys = world.apply(acts.get(i));
        }

        assertTrue(world.isPermit(Possibility.AUTH_SMELLS));
        assertTrue(world.isPermit(Possibility.SEE_ILLUSION));
        assertFalse(world.isPermit(Possibility.CAN_FIND_SWITCH));
        assertEquals(world.getShadowMovements().get(), 0);
        assertFalse(keys.isEmpty());

        var sour = new Sour();

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

    }

    @Test
    public void arthurBackwordWorld() {
        var arthur = new Arthur();
        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur);

        ArrayList<Action> acts = arthur.getActions();

        for (int i = acts.size() - 1; i >= 0; i--) {
            keys = world.apply(acts.get(i));
        }

        assertTrue(world.isPermit(Possibility.AUTH_SMELLS));
        assertTrue(world.isPermit(Possibility.SEE_ILLUSION));
        assertFalse(world.isPermit(Possibility.CAN_FIND_SWITCH));
        assertEquals(world.getShadowMovements().get(), 0);
        assertFalse(keys.isEmpty());

        var sour = new Sour();

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

    }

    @Test
    public void arthurDoubleSmellCheck() {
        var arthur = new Arthur();
        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur);

        var acts = arthur.doActions();

        assertEquals(acts.size(), 2);

        for (Action a : acts) {
            world.apply(a);
        }

        var sour = new Sour();

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

        for (Action a : acts) {
            world.apply(a);
        }

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

    }

    @Test
    @Timeout(value = 1, unit = TimeUnit.SECONDS)
    public void noShadowMovements() {
        world = new World(shadows);
        world.AwaitShadows();
        world.AwaitShadows();
    }

    @Test
    public void concurrentWorld() {
        var arthur = new Arthur();
        var ford = new Ford();
        var match = new Match();

        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur, match);

        for (Action a : arthur.doActions()) {
            keys = world.apply(a);
        }

        assertFalse(keys.isEmpty());
        var sour = new Sour();

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

        assertFalse(match.getIsFired());

        for (Action a : ford.doActions()) {
            assertNotNull(world.apply(a));
        }

        assertTrue(match.getIsFired());

        assertTrue(world.isPermit(Possibility.AUTH_SMELLS));
        assertTrue(world.isPermit(Possibility.SEE_ILLUSION));
        assertTrue(world.isPermit(Possibility.CAN_FIND_SWITCH));

        world.AwaitShadows();
        assertEquals(world.getShadowMovements().get(), shadows);

    }
}
