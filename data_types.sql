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
	