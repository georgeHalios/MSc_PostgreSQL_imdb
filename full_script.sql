-- REMOVE HEADERS FROM ROWS

DELETE FROM midterm.akas where title_id = 'titleId';
DELETE FROM midterm.crew where title_id = 'tconst';
DELETE FROM midterm.episode where title_id = 'tconst';
DELETE FROM midterm.principals where title_id = 'tconst';
DELETE FROM midterm.ratings where title_id = 'tconst';
DELETE FROM midterm.title_basics where title_id = 'tconst';
DELETE FROM midterm.name_basics where name_id = 'nconst';

-- DATA TYPES

ALTER TABLE midterm.akas
	ALTER COLUMN title_id TYPE varchar(255),
	ALTER COLUMN title_id SET NOT NULL,
	ALTER COLUMN ordering TYPE integer USING(ordering::integer),
	ALTER COLUMN ordering SET NOT NULL,
	ALTER COLUMN region TYPE char(4),
	ALTER COLUMN language TYPE char(4),
	ALTER COLUMN types TYPE varchar(255),
	ALTER COLUMN attributes TYPE varchar(255),
	ALTER COLUMN is_original_title TYPE bool USING
	CASE WHEN is_original_title='0' THEN FALSE 
    ELSE TRUE 
    END;
	
ALTER TABLE midterm.crew
	ALTER COLUMN title_id TYPE varchar(255),
	ALTER COLUMN title_id SET NOT NULL,
	ALTER COLUMN directors TYPE character varying,
	ALTER COLUMN writers TYPE character varying;
	
ALTER TABLE midterm.episode
	ALTER COLUMN title_id TYPE VARCHAR(255),
	ALTER COLUMN title_id SET NOT NULL,
	ALTER COLUMN parent_title_id TYPE VARCHAR(255),
	ALTER COLUMN parent_title_id SET NOT NULL,
	ALTER COLUMN season_number TYPE integer USING (season_number::integer),
	ALTER COLUMN episode_number TYPE integer USING (episode_number::integer);
	
ALTER TABLE midterm.name_basics
	ALTER COLUMN name_id TYPE VARCHAR(255),
	ALTER COLUMN name_id SET NOT NULL, 
	ALTER COLUMN primary_name TYPE VARCHAR(255),
	ALTER COLUMN birth_year TYPE SMALLINT USING(birth_year::smallint),
	ALTER COLUMN death_year TYPE SMALLINT USING(death_year::smallint),
	ALTER COLUMN primary_profession TYPE VARCHAR(255);
	
ALTER TABLE midterm.principals
	ALTER COLUMN title_id TYPE VARCHAR(255),
	ALTER COLUMN title_id SET NOT NULL,
	ALTER COLUMN ordering TYPE integer USING(ordering::integer),
	ALTER COLUMN ordering SET NOT NULL,
	ALTER COLUMN name_id TYPE VARCHAR(255),
	ALTER COLUMN name_id SET NOT NULL, 
	ALTER COLUMN category TYPE VARCHAR(255);

ALTER TABLE midterm.ratings
	ALTER COLUMN title_id TYPE VARCHAR(255),
	ALTER COLUMN title_id SET NOT NULL, 
	ALTER COLUMN average_rating TYPE FLOAT USING (average_rating::float),
	ALTER COLUMN number_of_votes  TYPE INTEGER USING (number_of_votes::integer);
	
ALTER TABLE midterm.title_basics
	ALTER COLUMN title_id TYPE VARCHAR(255),
	ALTER COLUMN title_id SET NOT NULL, 
	ALTER COLUMN title_type TYPE VARCHAR(50),
	ALTER COLUMN is_adult TYPE bool USING 
    CASE WHEN is_adult='0' THEN FALSE 
    ELSE TRUE 
    END,
	ALTER COLUMN start_year TYPE integer USING (start_year::integer),
    ALTER COLUMN end_year TYPE INTEGER USING (end_year::integer),
	ALTER COLUMN duration TYPE INTEGER USING (duration::integer);
	
	
-- Missing title_id

DELETE FROM midterm.principals principals
	WHERE NOT EXISTS (
	SELECT FROM midterm.title_basics title_basics
	WHERE title_basics.title_id = principals.title_id
	);
	
DELETE FROM midterm.principals principals
	WHERE NOT EXISTS(
	SELECT FROM midterm.name_basics name_basics
	WHERE name_basics.name_id = principals.name_id);

DELETE FROM midterm.episode episode
	WHERE NOT EXISTS (
	SELECT FROM midterm.title_basics title_basics
	WHERE title_basics.title_id = episode.parent_title_id
	);

DELETE FROM midterm.akas akas
	WHERE NOT EXISTS (
	SELECT FROM midterm.title_basics title_basics
	WHERE title_basics.title_id = akas.title_id
	);

-- PRIMARY KEYS FOR NEW TABLES -- 

ALTER TABLE midterm.akas
	ADD CONSTRAINT akas_pkey
		PRIMARY KEY(title_id, ordering);
		
ALTER TABLE midterm.crew
	ADD CONSTRAINT crew_pkey
		PRIMARY KEY(title_id);
		
ALTER TABLE midterm.episode
	ADD CONSTRAINT episode_pkey
		PRIMARY KEY(title_id, parent_title_id);
		
ALTER TABLE midterm.name_basics
	ADD CONSTRAINT name_basics_pkey
		PRIMARY KEY(name_id); 
		
ALTER TABLE midterm.principals
	ADD CONSTRAINT principals_pkey
		PRIMARY KEY(title_id, name_id, ordering);

ALTER TABLE midterm.ratings
	ADD CONSTRAINT ratings_pkey
		PRIMARY KEY(title_id);
		
ALTER TABLE midterm.title_basics
	ADD CONSTRAINT title_basics_pkey
		PRIMARY KEY(title_id);
		

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

-- FOREIGN KEYS

ALTER TABLE midterm.directors
	ADD CONSTRAINT Directors_title_id_fkey 
		FOREIGN KEY (title_id) REFERENCES midterm.title_basics(title_id);

ALTER TABLE midterm.directors
	ADD CONSTRAINT directors_name_id_fkey
		FOREIGN KEY(name_id) REFERENCES midterm.name_basics(name_id);

ALTER TABLE midterm.writers
	ADD CONSTRAINT writers_title_id_fkey
		FOREIGN KEY (title_id) REFERENCES midterm.title_basics(title_id);

ALTER TABLE midterm.writers
	ADD CONSTRAINT writers_name_id_fkey
		FOREIGN KEY(name_id) REFERENCES midterm.name_basics(name_id);
		
ALTER TABLE midterm.known_for
	ADD CONSTRAINT known_for_name_id_fkey
		FOREIGN KEY (name_id) REFERENCES midterm.name_basics(name_id);
		
ALTER TABLE midterm.known_for
	ADD CONSTRAINT known_for_title_id_fkey
		FOREIGN KEY (title_id) REFERENCES midterm.title_basics(title_id);
		
ALTER TABLE midterm.episode
	ADD CONSTRAINT episode_title_id_fkey
		FOREIGN KEY(title_id) REFERENCES midterm.title_basics(title_id);

ALTER TABLE midterm.episode
	ADD CONSTRAINT episode_parent_fkey
		FOREIGN KEY(parent_title_id) REFERENCES midterm.title_basics(title_id);

ALTER TABLE midterm.title_genres
	ADD CONSTRAINT title_genres_title_id_fkey
		FOREIGN KEY(title_id) REFERENCES midterm.title_basics(title_id);

ALTER TABLE midterm.akas
	ADD CONSTRAINT akas_title_id_fkey
		FOREIGN KEY(title_id) REFERENCES midterm.title_basics(title_id);
		
ALTER TABLE midterm.title_types
	ADD CONSTRAINT types_title_id_fkey
		FOREIGN KEY(title_id, ordering) REFERENCES midterm.akas(title_id, ordering);
		
ALTER TABLE midterm.title_attributes
	ADD CONSTRAINT attributes_title_id_fkey
		FOREIGN KEY(title_id, ordering) REFERENCES midterm.akas(title_id, ordering);
		
ALTER TABLE midterm.roles
	ADD CONSTRAINT roles_title_fkey
		FOREIGN KEY(title_id) REFERENCES midterm.title_basics(title_id);
		
ALTER TABLE midterm.roles
	ADD CONSTRAINT roles_name_fkey
		FOREIGN KEY(name_id) REFERENCES midterm.name_basics(name_id);
		
ALTER TABLE midterm.professions
	ADD CONSTRAINT professions_fkey
		FOREIGN KEY(name_id) REFERENCES midterm.name_basics(name_id);

ALTER TABLE midterm.principals
	ADD CONSTRAINT principals_title_id_fkey
		FOREIGN KEY(title_id) REFERENCES midterm.title_basics(title_id);
		
ALTER TABLE midterm.ratings
	ADD CONSTRAINT ratings_title_id_fkey
		FOREIGN KEY(title_id) REFERENCES midterm.title_basics(title_id);

ALTER TABLE midterm.principals
	ADD CONSTRAINT principals_name_id_fkey
		FOREIGN KEY(name_id) REFERENCES midterm.name_basics(name_id);

-- DROP TABLES AND COLUMNS 

DROP TABLE midterm.crew;

ALTER TABLE midterm.title_basics
	DROP COLUMN genre;
	
ALTER TABLE midterm.akas
	DROP COLUMN types, 
	DROP COLUMN attributes;

ALTER TABLE midterm.principals
	DROP COLUMN characters;

ALTER TABLE midterm.name_basics
	DROP COLUMN primary_profession,
	DROP COLUMN known_for_titles;
	
-- VIEWS AND AGGREGATIONS
-- TOP 10 EPISODES -- FIRST TOP EPISODE IS FROM BREAKING BAD

CREATE VIEW midterm.top_rated_episodes(title_id, primary_title, average_rating, number_of_votes)
AS SELECT title_basics.title_id, title_basics.primary_title, ratings.average_rating, ratings.number_of_votes
FROM midterm.title_basics, midterm.ratings
WHERE title_basics.title_id = ratings.title_id
AND title_basics.title_type = 'tvEpisode'
AND ratings.number_of_votes > 10000
ORDER BY ratings.average_rating DESC
LIMIT 10;

-- TOP 10 SERIES --

CREATE VIEW midterm.top_rated_tvseries(title_id, primary_title, average_rating)
AS SELECT title_basics.title_id, title_basics.primary_title, ratings.average_rating
FROM midterm.title_basics, midterm.ratings
WHERE title_basics.title_id = ratings.title_id
AND title_basics.title_type = 'tvSeries'
AND ratings.average_rating > 7
AND ratings.number_of_votes > 10000
ORDER BY ratings.average_rating DESC
LIMIT 50;

-- ALL BREAKING BAD EPISODES AND THEIR AVERAGE RATINGS

CREATE VIEW midterm.breakingbad_avgepisodes(season_number, episode_number, primary_title, average_rating)
AS SELECT episode.season_number, episode.episode_number, title_basics.primary_title, ratings.average_rating
FROM midterm.title_basics, midterm.episode, midterm.ratings
WHERE episode.parent_title_id= 'tt0903747'
AND title_basics.title_id = episode.parent_title_id
AND title_basics.title_id = episode.title_id
AND title_basics.title_id = ratings.title_id;


-- SERIES GENRES -- 

CREATE VIEW midterm.series_genres(genre,Count)
AS SELECT title_genres.genre, COUNT(title_genres.genre) AS Count
FROM midterm.title_genres, midterm.title_basics
WHERE title_basics.title_id = title_genres.title_id
AND title_basics.title_type = 'tvSeries'
GROUP BY genre
ORDER BY Count DESC;

-- BREAKING BAD DIRECTORS -- 

CREATE VIEW midterm.breakingbad_directors
AS SELECT directors.name_id, name_basics.primary_name
FROM midterm.directors
	INNER JOIN midterm.name_basics
	ON name_basics.name_id = directors.name_id
	WHERE directors.title_id = 'tt0903747';

-- BREAKING BAD WRITERS -- 

CREATE VIEW midterm.breakingbad_writers
AS SELECT writers.name_id, name_basics.primary_name
FROM midterm.writers
	INNER JOIN midterm.name_basics
	ON name_basics.name_id = writers.name_id
	WHERE writers.title_id = 'tt0903747';
	
-- BREAKING BAD ACTORS -- 

CREATE VIEW midterm.breakingbad_actors
AS SELECT roles.name_id, name_basics.primary_name
FROM midterm.roles
	INNER JOIN midterm.name_basics
	ON name_basics.name_id = roles.name_id
	WHERE roles.title_id = 'tt0903747';


