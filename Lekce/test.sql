SELECT count(distinct show_id)
FROM NETFLIX_IMDB_TEST
;

-- 🔎 Úkol č. 1 (3b)*

SELECT RELEASE_YEAR, count(*) AS Count_Title
FROM NETFLIX_IMDB_TEST
GROUP BY RELEASE_YEAR
ORDER BY Count_Title DESC
LIMIT 1
; -- 2006


-- 🔎 Úkol č. 2 (4b)*

SELECT 
    TYPE, 
    AVG(AVERAGERATING) AS Average_Rating,
    AVG(AVG(AVERAGERATING)) OVER () AS Total_Average
FROM NETFLIX_IMDB_TEST
WHERE NUMVOTES >= 1000
GROUP BY TYPE;

-- 🔎 Úkol č. 3 (6b)*

SELECT count(*)
From (
    SELECT RELEASE_YEAR, AVG(AVERAGERATING)
    FROM NETFLIX_IMDB_TEST
    WHERE 1=1
         AND TYPE = 'Movie'
         AND COUNTRY LIKE '%United States%'
    GROUP BY RELEASE_YEAR
    HAVING AVG(AVERAGERATING) > 7.7
    ) AS Sub
; -- 3

-- 🔎 Úkol č. 4 (4b)*

SELECT count(*)
FROM NETFLIX_IMDB_TEST
WHERE LISTED_IN LIKE '%Comedies%' AND RELEASE_YEAR > 2010
; -- 2

-- 🔎 Úkol č. 5 (8b)*

    SELECT count(*)
    FROM MY_MOVIE_LIST AS ml
    LEFT JOIN NETFLIX_IMDB_TEST AS imdb ON ml.TITLE = imdb.TITLE AND ml.YEAR = imdb.RELEASE_YEAR
    WHERE ml.YEAR > 2000
          AND imdb.const IS NULL      
; -- 8


select avg(RUNTIMEMINUTES)
from NETFLIX_IMDB_TEST
