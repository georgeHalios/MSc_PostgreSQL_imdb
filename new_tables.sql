-- NEW TABLES

CREATE TABLE midterm.professions
	AS(SELECT name_id, primary_profession FROM midterm.name_basics);
	
CREATE TABLE midterm.title_types
	AS(SELECT title_id, ordering, types FROM midterm.akas);
	
CREATE TABLE midterm.title_attributes
	AS(SELECT title_id, ordering, attributes FROM midterm.akas);

CREATE TABLE midterm.roles
	AS(SELECT name_id, title_id, characters FROM midterm.principals);
	
-- CREATE NEW TABLES - SPLITTING DATA

CREATE TABLE midterm.title_genres
	AS(SELECT title_id, 
    regexp_split_to_table(genre, E',') 
	FROM midterm.title_basics
	ORDER BY title_id asc);
	
ALTER TABLE midterm.title_genres
	RENAME COLUMN regexp_split_to_table TO genre;

CREATE TABLE midterm.directors
	AS(SELECT title_id, 
    regexp_split_to_table(directors, E',') 
	FROM midterm.crew
	ORDER BY title_id asc);

ALTER TABLE midterm.directors
	RENAME COLUMN regexp_split_to_table TO name_id;

CREATE TABLE midterm.writers
	AS(SELECT title_id, 
    regexp_split_to_table(writers, E',') 
	FROM midterm.crew
	ORDER BY title_id asc);

ALTER TABLE midterm.writers
	RENAME COLUMN regexp_split_to_table TO name_id;
	
CREATE TABLE midterm.known_for
	AS(SELECT name_id, 
    regexp_split_to_table(known_for_titles, E',') 
	FROM midterm.name_basics
	ORDER BY name_id asc);

ALTER TABLE midterm.known_for
	RENAME COLUMN regexp_split_to_table TO title_id;
	
-- Missing title_id

DELETE FROM midterm.directors directors
	WHERE NOT EXISTS (
	SELECT FROM midterm.name_basics name_basics
	WHERE directors.name_id = name_basics.name_id
	);

DELETE FROM midterm.writers writers
	WHERE NOT EXISTS (
	SELECT FROM midterm.name_basics name_basics
	WHERE writers.name_id = name_basics.name_id
	);

DELETE FROM midterm.known_for known_for
	WHERE NOT EXISTS (
	SELECT FROM midterm.title_basics title_basics
	WHERE known_for.title_id = title_basics.title_id
	);
	
DELETE FROM midterm.roles roles
	WHERE NOT EXISTS (
	SELECT FROM midterm.name_basics name_basics
	WHERE roles.name_id = name_basics.name_id
	);
	
-- NEW TABLES - PRIMARY KEYS

ALTER TABLE midterm.directors
	ADD CONSTRAINT directors_pkey
		PRIMARY KEY(title_id, name_id);
		
ALTER TABLE midterm.writers
	ADD CONSTRAINT writers_pkey
		PRIMARY KEY(title_id, name_id);
		
ALTER TABLE midterm.known_for
	ADD CONSTRAINT known_for_pkey
		PRIMARY KEY(name_id, title_id);

ALTER TABLE midterm.title_genres
	ADD CONSTRAINT title_genres_pkey
		PRIMARY KEY(title_id, genre);

ALTER TABLE midterm.title_types
	ADD CONSTRAINT title_types_pkey
		PRIMARY KEY(title_id, ordering);
		
ALTER TABLE midterm.title_attributes
	ADD CONSTRAINT title_attributes_pkey
		PRIMARY KEY(title_id, ordering);
		
ALTER TABLE midterm.professions
	ADD CONSTRAINT professions_pkey
		PRIMARY KEY(name_id, primary_profession);