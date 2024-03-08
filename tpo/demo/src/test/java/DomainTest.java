import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.HashSet;
import java.util.Set;

import org.junit.jupiter.api.Test;

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
        world = new World(shadows, new Match());

        for (Action a : ford.doActions()) {
            assertNull(world.apply(a));
        }

        assertTrue(world.isPermit(Possibility.CAN_FIND_SWITCH));
        assertFalse(world.isPermit(Possibility.AUTH_SMELLS));
        assertFalse(world.isPermit(Possibility.SEE_ILLUSION));

        world.AwaitShadows();

        assertEquals(world.getShadowMovements().get(), shadows);
    }

    @Test
    public void arthurBadSmellWorld() {
        var arthur = new Arthur();
        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur);

        for (Action a : arthur.doActions()) {
            keys = world.apply(a);
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
    public void arthurGoodSmellWorld() {
        var arthur = new Arthur();
        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur);

        var acts = arthur.doActions();
        for (Action a : acts) {
            world.apply(a);
        }

        var sour = new Sour();

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

        // for (Action a : acts) {
        //     if (a == Action.TOUCH_SELF) {
        //         world.apply(a);
        //     }
        // }

        Boolean check = false;
        for (Keys key : keys) {
            check = check & sour.auth(new Key(key));
        }

        assertTrue(check);

    }

    @Test
    public void noShadowMovements() {
        world = new World(shadows);
        world.AwaitShadows();
        world.AwaitShadows();
    }

    @Test
    public void concurrentWorld() {
        var arthur = new Arthur();
        var ford = new Ford();

        Set<Keys> keys = new HashSet<>();

        world = new World(shadows, arthur, new Match());

        for (Action a : arthur.doActions()) {
            keys = world.apply(a);
        }

        assertFalse(keys.isEmpty());
        var sour = new Sour();

        for (Keys key : keys) {
            assertFalse(sour.auth(new Key(key)));
        }

        for (Action a : ford.doActions()) {
            assertNotNull(world.apply(a));
        }

        assertTrue(world.isPermit(Possibility.AUTH_SMELLS));
        assertTrue(world.isPermit(Possibility.SEE_ILLUSION));
        assertTrue(world.isPermit(Possibility.CAN_FIND_SWITCH));

        world.AwaitShadows();
        assertEquals(world.getShadowMovements().get(), shadows);

    }
}
