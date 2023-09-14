CREATE TABLE galaxy_disk(
    codename bytea PRIMARY KEY,
    diam double precision CHECK (diam > 0),
    arm_number bigint CHECK (arm_number >= 1) -- human_name varchar(100),
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
    temperature numeric(2, 2) NOT NULL,
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

DROP TYPE rgb;