CREATE TABLE galaxy_disk(
    codename bytea PRIMARY KEY,
    diam double precision CHECK (diam > 0),
    arm_number bigint CHECK (arm_number >= 1)
);

CREATE TABLE arm(
    codename bytea PRIMARY KEY,
    galaxy_disk_codename bytea REFERENCES galaxy_disk(codename) ON DELETE CASCADE,
    star_number bigint NOT NULL CHECK(star_number >= 1)
);

CREATE TABLE dwarf(
    codename bytea PRIMARY KEY,
    arm_codename bytea REFERENCES arm(codename) ON DELETE CASCADE,
    satellite_number int NOT NULL,
    temperature real NOT NULL,
    CHECK (
        satellite_number >= 1
        AND temperature >= -273
    )
);

CREATE TEMPORARY SEQUENCE particle_id INCREMENT by 2 START WITH 1;

CREATE TABLE particle(
    id int PRIMARY KEY CHECK (id >= 0),
    dwarf_codename bytea REFERENCES dwarf(codename) ON DELETE CASCADE,
    density real NOT NULL,
    volume real NOT NULL,
    CHECK (
        density >= 0
        AND volume >= 0
    )
);

CREATE TABLE planet(
    codename bytea PRIMARY KEY,
    inhabitant bool NOT NULL
);

CREATE TYPE rgb AS (r int, g int, b int);

-- CREATE domain rgb_domain AS rgb CHECK (
--     red >= 0
--     AND red <= 255
-- ) CHECK (
--     g >= 0
--     AND g <= 255
-- ) CHECK (
--     b >= 0
--     AND b <= 255
-- );
CREATE TABLE horizon(
    color rgb,
    brightness int CHECK(
        brightness >= 0
        AND brightness <= 100
    ),
    PRIMARY KEY(color)
);

-- Additional
CREATE TABLE color_factor(
    dwarf_codename bytea REFERENCES dwarf(codename) ON DELETE
    SET NULL,
        horizon_color rgb REFERENCES horizon(color) ON DELETE
    SET NULL,
        PRIMARY KEY (dwarf_codename, horizon_color)
);

CREATE TABLE transition(
    horizon_color_prev rgb,
    horizon_color_next rgb REFERENCES horizon(color) ON DELETE
    SET NULL,
        dwarf_codename bytea,
        FOREIGN KEY (dwarf_codename, horizon_color_next) REFERENCES color_factor(dwarf_codename, horizon_color)
);

CREATE TABLE conjunction(
    dwarf_codename bytea REFERENCES dwarf(codename) ON DELETE CASCADE,
    planet_codename bytea REFERENCES planet(codename) ON DELETE CASCADE
);

CREATE TABLE galaxy_coord(
    galaxy_disk_codename bytea REFERENCES galaxy_disk(codename) ON DELETE CASCADE,
    arm_codename bytea REFERENCES arm(codename) ON DELETE CASCADE,
    dwarf_codename bytea REFERENCES dwarf(codename) ON DELETE CASCADE,
    planet_codename bytea PRIMARY KEY REFERENCES planet(codename) ON DELETE CASCADE
);

-- ///////////////////////////// Tests
INSERT INTO galaxy_disk (codename, diam, arm_number)
VALUES (sha224('Milky way')::bytea, 10, 2);

INSERT INTO arm (codename, galaxy_disk_codename, star_number)
VALUES (
        sha256('Right arm')::bytea,
        sha224('Milky way')::bytea,
        2
    );

INSERT INTO arm (codename, galaxy_disk_codename, star_number)
VALUES (
        sha256('Left arm')::bytea,
        sha224('Milky way')::bytea,
        1
    );

INSERT INTO dwarf(
        codename,
        arm_codename,
        satellite_number,
        temperature
    )
VALUES (
        sha224('R-1')::bytea,
        sha256('Right arm')::bytea,
        3,
        -100.0
    );

INSERT INTO dwarf(
        codename,
        arm_codename,
        satellite_number,
        temperature
    )
VALUES (
        sha224('R-2')::bytea,
        sha256('Right arm')::bytea,
        4,
        -100.0
    );

INSERT INTO dwarf(
        codename,
        arm_codename,
        satellite_number,
        temperature
    )
VALUES (
        sha224('L-1')::bytea,
        sha256('Left arm')::bytea,
        5,
        -10.0
    );

INSERT INTO planet(codename, inhabitant)
VALUES (
        sha224('Calisto')::bytea,
        TRUE
    );

INSERT INTO galaxy_coord(
        galaxy_disk_codename,
        arm_codename,
        dwarf_codename,
        planet_codename
    )
VALUES(
        sha224('Milky way')::bytea,
        sha256('Left arm')::bytea,
        sha224('L-1')::bytea,
        sha224('Calisto')::bytea
    );

INSERT INTO conjunction(dwarf_codename, planet_codename)
VALUES (sha224('L-1')::bytea, sha224('Calisto')::bytea);

INSERT INTO conjunction(dwarf_codename, planet_codename)
VALUES (sha224('R-1')::bytea, sha224('Calisto')::bytea);

INSERT INTO particle (
        id,
        dwarf_codename,
        density,
        volume
    )
VALUES (
        nextval('particle_id'),
        sha224('L-1')::bytea,
        1000,
        4567
    );

INSERT INTO particle (
        id,
        dwarf_codename,
        density,
        volume
    )
VALUES (
        nextval('particle_id'),
        sha224('L-1')::bytea,
        500,
        123
    );

INSERT INTO horizon (color, brightness)
VALUES (ROW(100, 100, 100), 55);

INSERT INTO horizon (color, brightness)
VALUES (ROW(200, 100, 100), 60);

INSERT INTO color_factor(dwarf_codename, horizon_color)
VALUES(sha224('L-1')::bytea, ROW(200, 100, 100));

INSERT INTO transition(
        horizon_color_prev,
        horizon_color_next,
        dwarf_codename
    )
VALUES (
        (
            SELECT color
            FROM horizon
            WHERE brightness = 55::int
        ),
        (
            SELECT color
            FROM horizon
            WHERE brightness = 60::int
        ),
        sha224('L-1')::bytea
    );

-- ////////////////////////////// Check all
SELECT *
FROM galaxy_disk;

SELECT *
FROM arm;

SELECT *
FROM dwarf;

SELECT *
FROM planet;

SELECT *
FROM galaxy_coord;

SELECT *
FROM conjunction;

SELECT *
FROM particle;

SELECT *
FROM horizon;

SELECT *
FROM color_factor;

SELECT *
FROM transition;

-- ////////////////////////////// End Tests
DROP TABLE galaxy_disk CASCADE;

DROP TABLE arm CASCADE;

DROP TABLE dwarf CASCADE;

DROP SEQUENCE particle_id CASCADE;

DROP TABLE particle CASCADE;

DROP TABLE planet CASCADE;

DROP TABLE horizon CASCADE;

DROP TABLE color_factor CASCADE;

DROP TABLE transition CASCADE;

DROP TABLE conjunction CASCADE;

DROP TABLE galaxy_coord CASCADE;

-- DROP TYPE rgb_domain;
DROP TYPE rgb;