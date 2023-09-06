CREATE TABLE fruits(weight int, name text PRIMARY KEY);

INSERT INTO fruits (name, weight)
VALUES ('ban', 987);

INSERT INTO fruits (name, weight)
VALUES ('banasd', 987);

SELECT *
FROM fruits;

DROP TABLE fruits;