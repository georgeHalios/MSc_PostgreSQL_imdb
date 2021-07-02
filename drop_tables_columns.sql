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