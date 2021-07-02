-- REMOVE HEADERS FROM ROWS

DELETE FROM midterm.akas where title_id = 'titleId';
DELETE FROM midterm.crew where title_id = 'tconst';
DELETE FROM midterm.episode where title_id = 'tconst';
DELETE FROM midterm.principals where title_id = 'tconst';
DELETE FROM midterm.ratings where title_id = 'tconst';
DELETE FROM midterm.title_basics where title_id = 'tconst';
DELETE FROM midterm.name_basics where name_id = 'nconst';