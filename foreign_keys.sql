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