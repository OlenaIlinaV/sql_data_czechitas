--FIRST_TABLE------------------------------------------------------------------------------

CREATE OR REPLACE TEMPORARY TABLE TEMP_Titles_Ratings AS

SELECT t.*, -- všechny sloupce z IMDB_TITLES2
    r.AVERAGERATING, r.NUMVOTES -- pouze sloupce AVERAGERATING a NUMVOTES z tabulky IMDB_RATINGS2

FROM IMDB_TITLES2 as t
INNER JOIN IMDB_RATINGS2 as r
    ON t.TCONST = r.TCONST
;


-- CHECK

SELECT *
FROM TEMP_Titles_Ratings
LIMIT 10
;

SELECT TITLETYPE
FROM TEMP_Titles_Ratings
GROUP BY TITLETYPE
;

--SECOND_TABLE------------------------------------------------------------------------------


CREATE OR REPLACE TEMPORARY TABLE TEMP_Titles_IMDB_NEW AS

SELECT *,
    CASE 
        WHEN TITLETYPE IN ('movie', 'short', 'tvMovie', 'tvShort') THEN 'Movie'
        WHEN TITLETYPE IN ('tvSeries', 'tvMiniSeries') THEN 'TV Show'
        --ELSE TITLETYPE -- Залишаємо оригінальне значення TITLETYPE, якщо жодна з умов не виконується
        -- ELSE не вказано, тому залишить NULL, якщо не виконується жодна умова
    END AS TITLETYPE_NEW
FROM TEMP_Titles_Ratings
;

-- CHECK

SELECT TITLETYPE, count(*)
FROM TEMP_TITLES_RATINGS
group by TITLETYPE

SELECT *
FROM TEMP_Titles_IMDB_NEW
--WHERE TITLETYPE_NEW = 'unknown'
--LIMIT 10
;

SELECT TITLETYPE_NEW
FROM TEMP_TITLES_IMDB_NEW
GROUP BY TITLETYPE_NEW
;

--THIRD_TABLE------------------------------------------------------------------------------


NEW VARIANT


USE SCHEMA SCH_CZECHITA_ILINAO;


CREATE OR REPLACE TABLE NETFLIX_IMDB AS

SELECT *
    --i.*, -- pouze sloupce TEMP_TITLES_IMDB_NEW
    --n.* -- všechny sloupce z tabulky NETFLIX_TITLES2
   
FROM SCH_CZECHITA.NETFLIX_TITLES2 AS n
INNER JOIN SCH_CZECHITA.TEMP_TITLES_IMDB_NEW AS i
    ON n.TITLE = i.PRIMARYTITLE
    AND n.RELEASE_YEAR = i.STARTYEAR
    AND n.TYPE = i.TITLETYPE_NEW
;

SELECT *
FROM NETFLIX_IMDB
;

-- CHECK

SELECT PRIMARYTITLE, COUNT(SHOW_ID)
FROM NETFLIX_IMDB
GROUP BY PRIMARYTITLE
HAVING COUNT(SHOW_ID) > 1
;

SELECT SHOW_ID, COUNT(*)
FROM NETFLIX_IMDB
GROUP BY SHOW_ID
HAVING COUNT(*) > 1
;
