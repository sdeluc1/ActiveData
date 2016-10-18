CREATE TABLE guitars (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  musician_id INTEGER,

  FOREIGN KEY(musician_id) REFERENCES musician(id)
);

CREATE TABLE musicians (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  band_id INTEGER,

  FOREIGN KEY(band_id) REFERENCES band(id)
);

CREATE TABLE bands (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  bands (id, name)
VALUES
  (1, "Snowhorse"),
  (2, "The Programmers");

INSERT INTO
  musicians (id, name, band_id)
VALUES
  (1, "Aaron Okrasinski", 1),
  (2, "Sean Bierbower", 1),
  (3, "Steve DeLuca", 1),
  (4, "Bob Davis", 2),
  (5, "James McGee", 2),
  (6, "Sharon Stevenson", 2);

INSERT INTO
  guitars (id, name, musician_id)
VALUES
  (1, "Firebird", 1),
  (2, "Lucille", 1),
  (3, "Porkchop", 2),
  (4, "Lorenzo", 2),
  (5, "Sweetness", 2),
  (6, "Rosebud", 3),
  (7, "Cyclops", 3),
  (8, "Roadhound", 4),
  (9, "Paradise", 5),
  (10, "Warrior's Tongue", 6),
  (11, "Lemon", 6);
