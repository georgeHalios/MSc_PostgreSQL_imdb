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
		