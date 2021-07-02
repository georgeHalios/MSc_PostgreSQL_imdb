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
