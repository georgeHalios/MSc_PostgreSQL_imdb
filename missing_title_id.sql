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