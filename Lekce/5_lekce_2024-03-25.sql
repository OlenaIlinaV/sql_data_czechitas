------------------------------------------------------------------------------------------------------------------
-- LEKCE 5: INSERT, DELETE, CREATE, ALTER A IMPORT DAT
------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------                        
-- Context
---- UI
---- Prikazy v kodu
---------------------------------------------------------

-- jako uzivatel databaze mate ruzna opravneni, ta vam umoznuji delat ruzne akce
-- napr. v sch_czechita nemuzete vytvaret tabulky, muzete je ale vytvaret ve svem vlastnim schematu

-- UI - prvni si ukazeme, jak to delat v UI






-- jak nastavit context pomoci kodu - prikaz USE


-- 1. ROLE -- zadejte svou roli
--USE ROLE ROLE_CZECHITA_PRIJMENIK;

-- 2. WAREHOUSE
USE WAREHOUSE COMPUTE_WH;

-- 3. DATABASE
USE DATABASE COURSES;

-- 4. SCHEMA -- zadejte sve schema
--USE SCHEMA SCH_CZECHITA_PRIJMENIK;



-- UKOLY ----------------------------------------------------------

--> 1. Vyberte 10 řádků z tabulky TEROR.

select *
from COURSES.SCH_CZECHITA.TEROR
limit 10;

------------------------------------------------------------------

---------------------------------------------------------                        
-- CREATE TABLE
---------------------------------------------------------  

-- NOVA_TABULKA
CREATE TABLE NOVA_TABULKA (
   SLOUPEC1 INT
  ,SLOUPEC2 VARCHAR(255)
);

SELECT * FROM NOVA_TABULKA;
DESC TABLE NOVA_TABULKA;


-- UKOLY ----------------------------------------------------------

--> 2. Vytvořte novou prázdnou tabulku s názvem MOJE_PRVNI_TABULKA pomocí CREATE TABLE, tabulka bude mít tři sloupečky: 
        -- ID (celé číslo - INT)
        -- JMENO (textový řetězec, max 255 znaků - VARCHAR(255))
        -- DATUM_NAROZENI (datum - DATE)
        
 CREATE TABLE MOJE_PRVNI_TABULKA
 (
    ID INT
    ,JMENO VARCHAR(255)
    ,DATUM_NAROZENI DATE
 );

 SELECT * FROM MOJE_PRVNI_TABULKA;
 


------------------------------------------------------------------




---------------------------------------------------------
-- DROP TABLE (smazání tabulky), UNDROP (restore tabulky)
-- CREATE OR REPLACE TABLE (přepis již existující tabulky)
---------------------------------------------------------

-- DROP & UNDROP NOVA_TABULKA
DROP TABLE NOVA_TABULKA;

UNDROP TABLE NOVA_TABULKA; -- default 24 hodin, zalezi na data travel feature

SELECT * FROM NOVA_TABULKA;

-- DROP & CREATE TABLE

CREATE TABLE NOVA_TABULKA (
    ID INT
  , JMENO VARCHAR(255)
  , DATUM_NAROZENI DATE
  , MESTO_NAROZENI VARCHAR(255)
);

-- DROP TABLE NOVA_TABULKA;

-- CREATE OR REPLACE - використовувати тільки коли впевнені що треба змінити таблицю, бо воно зачищає всі дані і вже неможливо буде востановити

CREATE OR REPLACE TABLE NOVA_TABULKA (
    ID INT
  , JMENO VARCHAR(255)
  , DATUM_NAROZENI DATE
  , MESTO_NAROZENI VARCHAR(255)
  , VELIKOST_NOHY INT
);

DESC TABLE NOVA_TABULKA;

SELECT * FROM NOVA_TABULKA;

---------------------------------------------------------                        
-- INSERT INTO TABULKA (SLOUPEC1, SLOUPEC2) ... VALUES
---------------------------------------------------------                        
-- vložení jednotlivých řádků do tabulky

DESC TABLE NOVA_TABULKA;

INSERT INTO NOVA_TABULKA (ID, JMENO, DATUM_NAROZENI, MESTO_NAROZENI, VELIKOST_NOHY) -- можно не писати стовпчики в дужках, але краще писати
VALUES
      (1,'Oliver Potůček','1954-11-03','Rychnov u Jablonce nad Nisou',44)
    , (2,'Žaneta Kousalová','1978-02-27','Ústí nad Labem',36)
    , (3,'Věra Podešvová','1992-04-04','Nasavrky',39)
    , (4,'Petr Mička','1992-08-22','Kaplice',43)
;

SELECT * FROM NOVA_TABULKA;


-- !!! Kolikrát příkaz spustíme, tolikrát se data vloží.

-- UKOLY ----------------------------------------------------------

--> 3. Přepište svou tabulku MOJE_PRVNI_TABULKA tak, že bude mít následující strukturu:
        -- ID (celé číslo - INT) (zůstává stejné) 
        -- JMENO_ZAKAZNIKA (textový řetězec, max 1000 znaků - VARCHAR(1000))
        -- DATUM_NAROZENI (datum - DATE) (zůstává stejné)
        -- SLEVA (desetinné číslo s dvěmi místy - NUMBER(38,2))

CREATE OR REPLACE TABLE MOJE_PRVNI_TABULKA(
    ID INT
  , JMENO_ZAKAZNIKA VARCHAR(1000)
  , DATUM_NAROZENI DATE
  , SLEVA NUMBER(38,2)
);

SELECT * FROM MOJE_PRVNI_TABULKA;
DESC TABLE MOJE_PRVNI_TABULKA;

--> 4. Do tabulky vložte následující řádky:
    -- 1, 'Václav Košmel', '1968-01-03', 5.3
    -- 2, 'Květoslava Smílická', '1948-01-03', 10.5
    

INSERT INTO MOJE_PRVNI_TABULKA (ID, JMENO_ZAKAZNIKA, DATUM_NAROZENI, SLEVA)
VALUES
    (1, 'Václav Košmel', '1968-01-03', 5.3)
    ,(2, 'Květoslava Smílická', '1948-01-03', 10.5)
;

SELECT * FROM MOJE_PRVNI_TABULKA;

------------------------------------------------------------------

-- Co když budeme vkládat nevalidní data? (např. datum)
INSERT INTO MOJE_PRVNI_TABULKA (ID, JMENO_ZAKAZNIKA, DATUM_NAROZENI, SLEVA)
VALUES
(3, 'Jmeno Prijmeni', '1.1.2003', 5.3);


SELECT * FROM NOVA_TABULKA;

------------------------------------------------------------------
-- Pro zajímavost -  перепише дані в табулці на нові (зачищає старі та записує нові)
INSERT OVERWRITE INTO NOVA_TABULKA (ID, JMENO, DATUM_NAROZENI, MESTO_NAROZENI, VELIKOST_NOHY)
VALUES
      (111,'Lucie Kočičková','1993-08-11','Zlín',36)
    , (222,'František Švestka','1985-01-15','Pardubice',43)
    ;

---------------------------------------------------------                        
-- TEROR PŘÍKLAD - CREATE TABLE + INSERT
--------------------------------------------------------- 

CREATE TABLE NEW_TEROR (
  ID INT,
  GNAME VARCHAR(255),
  NKILL INT,
  NWOUND INT
); 

SELECT * FROM NEW_TEROR;
DESC TABLE NEW_TEROR;

INSERT INTO NEW_TEROR (ID, GNAME, NKILL, NWOUND) 
  VALUES 
    (1, 'Žoldáci', 10, 1), 
    (2, 'Nosiči smrti', 15, 2), 
    (3, 'Nějací další teroristi', 155, 5);

SELECT * FROM NEW_TEROR;

-- AUTOINCREMENT & PK VE SNOWFLAKE

CREATE OR REPLACE TABLE NEW_TEROR ( --> DATA SE SMAŽOU
  ID INT AUTOINCREMENT START 1 NOT NULL, -- ID se automaticky doplní a navýší o 1 s každou další řádkou v insertu
  GNAME VARCHAR(250),
  NKILL INT,
  NWOUND INT,
  CONSTRAINT id_pk PRIMARY KEY (id) -- přidávám constraint = primarni klic
);


SELECT * FROM NEW_TEROR;
DESC TABLE NEW_TEROR;
SHOW PRIMARY KEYS IN TABLE NEW_TEROR;

INSERT INTO NEW_TEROR (GNAME, NKILL, NWOUND) -- ID se doplni samo při každém insertu
  VALUES 
    ('Žoldáci', 10, 1), 
    ('Nosiči smrti', 15, 2), 
    ('Nějácí další teroristi', 155, 5);

SELECT * FROM NEW_TEROR;

-- unikátnost PK není ve SF vynucovaná

INSERT INTO NEW_TEROR (ID, GNAME, NKILL, NWOUND) -- ID se doplni samo při každém insertu
  VALUES 
    (1, 'Žoldáci', 10, 1);

SELECT * 
FROM NEW_TEROR
ORDER BY ID;


---------------------------------------------------------                        
-- INSERT INTO TABULKA(SLOUPEC1, SLOUPEC2) SELECT
---------------------------------------------------------                        

--> Chci tabulku NEW_TEROR obohatit o data z tabulky SCH_TEROR.TEROR 
-- data pouze z roku 2015, organizace 'Muslim extremists' a pouze útoky s alespoň jedním zabitým nebo jedním zraněným
-- pouze sloupečky, co jsou v tabulce NEW_TEROR, ID se opět doplní automaticky
;
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

INSERT INTO NEW_TEROR (GNAME, NKILL, NWOUND)
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

SELECT * FROM NEW_TEROR;
---------------------------------------------------------                        
-- CREATE TABLE TABULKA AS SELECT
---------------------------------------------------------                        

-- tabulku NEW_TEROR můžeme vytvořit přímo ze SELECT příkazu (nemusíme nejdřív vytvářet prázdnou tabulku)

-- CREATE TABLE NEW_TEROR_SELECT AS SELECT (bez ID)

CREATE TABLE NEW_TEROR_SELECT AS
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

SELECT * FROM NEW_TEROR_SELECT;

--> muzeme zde menit i datove typy

CREATE OR REPLACE TABLE NEW_TEROR_SELECT AS
SELECT 
    GNAME:: VARCHAR(255) AS GNAME
    , NKILL
    , NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

DESC TABLE NEW_TEROR_SELECT;

-- dá se do ní i dále insertovat

INSERT INTO NEW_TEROR_SELECT (GNAME, NKILL, NWOUND)
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2016 AND GNAME = 'Taliban' AND (NKILL>0 OR NWOUND>0)
;



---------------------------------------------------------                        
-- TRVALÁ vs. DOČASNÁ tabulka
--------------------------------------------------------- 

-- Vytvoříme si tabulku UDALOSTI_JEN_V_CESKU, kde budou sloupečky GNAME, CITY, NKILL A NWOUND, útoky jen z 'Czech Republic'

-- CREATE TABLE = trvalá tabulka
CREATE TABLE UDALOSTI_JEN_V_CESKU AS
SELECT 
    GNAME
    ,CITY
    ,NKILL
    ,NWOUND
FROM SCH_TEROR.TEROR
WHERE COUNTRY_TXT = 'Czech Republic'
;


-- CREATE TEMPORARY TABLE = dočasná tabulka, zanikne, když se odhlásíme
CREATE TEMPORARY TABLE TEMP_UDALOSTI_JEN_V_CESKU AS
SELECT 
    GNAME
    ,CITY
    ,NKILL
    ,NWOUND
    ,CITY as MESTO
FROM SCH_TEROR.TEROR
WHERE COUNTRY_TXT = 'Czech Republic'
;


-- Jakto, že tento příkaz nevrátil error, že už tabulka existuje?



DROP TABLE UDALOSTI_JEN_V_CESKU;

SELECT * FROM UDALOSTI_JEN_V_CESKU;

/*
CREATE TABLE TEMPORARY_TEROR AS 
SELECT * FROM UDALOSTI_JEN_V_CESKU;
*/

---------------------------------------------------------   
-- DELETE FROM TABULKA WHERE .. (smazání dat z tabulky na základě podmínky)
-- TRUNCATE TABLE (smazání dat z tabulky)
---------------------------------------------------------   

CREATE TABLE MAZACI_TABULKA (
  ID INT
  , TEXT VARCHAR(255)
);

INSERT INTO MAZACI_TABULKA(ID, TEXT)
    VALUES
    (1, 'TEXT1'),
    (2, 'TEXT2'),
    (3, 'TEXT3');

SELECT * FROM MAZACI_TABULKA;

-- DELETE s WHERE
DELETE FROM MAZACI_TABULKA
WHERE ID = 1;

-- DELETE bez WHERE
DELETE FROM MAZACI_TABULKA;

-- opět vložíme hodnoty
INSERT INTO MAZACI_TABULKA(ID, TEXT)
    VALUES
    (1, 'TEXT1'),
    (2, 'TEXT2'),
    (3, 'TEXT3');

-- TRUNCATE

TRUNCATE TABLE MAZACI_TABULKA;


---------------------------------------------------------                        
-- ALTER TABLE TABULKA ALTER COLUMN ...
---------------------------------------------------------                        

SELECT * FROM NEW_TEROR;
DESC TABLE NEW_TEROR;

-- Změna datového typu - pouze některé změny povoleny
ALTER TABLE NEW_TEROR ALTER COLUMN GNAME VARCHAR(350); -- můžeme pouze přidávat

---------------------------------------------------------                        
-- ALTER TABLE TABULKA RENAME TO
---------------------------------------------------------
ALTER TABLE NEW_TEROR RENAME TO NEW_TEROR2;

SELECT * FROM NEW_TEROR2;

--COLUMN
ALTER TABLE NEW_TEROR2 RENAME COLUMN GNAME TO TEROR_ORG;

--pro dalsi priklady to vratime zpet
ALTER TABLE NEW_TEROR2 RENAME TO NEW_TEROR;
ALTER TABLE NEW_TEROR RENAME COLUMN TEROR_ORG TO GNAME;

---------------------------------------------------------                        
-- ALTER TABLE TABULKA ADD/DROP COLUMN ..
---------------------------------------------------------

-- ADD
ALTER TABLE NEW_TEROR ADD CONTINENT VARCHAR(255); -- musíme opět definovat datový typ
SELECT * FROM NEW_TEROR;

-- DROP
ALTER TABLE NEW_TEROR DROP COLUMN CONTINENT;
SELECT * FROM NEW_TEROR;

---------------------------------------------------------                        
-- UPDATE TABULKA SET SLOUPEC = X WHERE PODMINKA
---------------------------------------------------------   

-- NEW_TEROR - NWOUND NULL nahradit 0
SELECT * FROM NEW_TEROR 
ORDER BY NWOUND DESC;

UPDATE NEW_TEROR SET NWOUND = 0
WHERE NWOUND IS NULL;

SELECT * FROM NEW_TEROR
WHERE NWOUND IS NULL;
 
-- Příkaz projde i bez podmínky!

-- Upravit se dá i několik sloupců v jednom příkazu
UPDATE NEW_TEROR SET NKILL = 50, NWOUND = 60
WHERE GNAME = 'Žoldáci'
;



-- UKOLY ----------------------------------------------------------

--> 5. Vytvořte dočasnou tabulku UDALOSTI_JEN_V_RAKOUSKU jako select z tabulky TEROR.
    -- Pouze sloupečky GNAME, CITY, NKILL A NWOUND
    -- COUNTRY_TXT = 'Austria'
    -- Dosaďte pomocí UPDATE do GNAME 'Neznámá organizace', kde je GNAME 'Unkown'
    -- Přidejte sloupeček COUNTRY a pomocí UPDATE dosaďte 'Rakousko'


------------------------------------------------------------------

CREATE TEMPORARY TABLE UDALOSTI_JEN_V_RAKOUSKU AS
SELECT 
    GNAME
    ,CITY
    ,NKILL
    ,NWOUND
FROM SCH_TEROR.TEROR
WHERE COUNTRY_TXT = 'Austria'
;

SELECT * FROM UDALOSTI_JEN_V_RAKOUSKU;

UPDATE UDALOSTI_JEN_V_RAKOUSKU SET GNAME = 'Neznámá organizace'
WHERE GNAME = 'Unknown';

SELECT * 
FROM UDALOSTI_JEN_V_RAKOUSKU
WHERE GNAME = 'Unknown';

ALTER TABLE UDALOSTI_JEN_V_RAKOUSKU ADD COUNTRY VARCHAR(255);

UPDATE UDALOSTI_JEN_V_RAKOUSKU SET COUNTRY = 'Rakousko'

---------------------------------------------------------                        
-- Import
-- Ukázka ve Snowflake
-- Použijte data.csv
---------------------------------------------------------                        




-- Data.csv
/*
- kroky:
1. podívat se do dat (Sublime Text, Atom, Notepad++ apod.)
2. vytvořit tabulku s názvy sloupců a datovými typy
3. vytvořit vyhovující file format
4. nalít data

- názvy sloupců
ID INT 
,FIRST_NAME VARCHAR(500)
,LAST_NAME VARCHAR(500)
,EMAIL VARCHAR(500)
,CATEGORY_ID INT
,SHOP_ID INT
,PEASANT_ID INT
,TRANSACTION_DATE VARCHAR(50)
,VIRGINITY_LEVEL INT
,PRICE_PER_GIG VARCHAR(500)
,SEGNEMNT_TEXT VARCHAR(200)
,URL VARCHAR(200)
,BLOCKCHAIN_HASH VARCHAR(64)
*/



CREATE TABLE KREICI_FAKE_TABLE (
ID INT 
,FIRST_NAME VARCHAR(500)
,LAST_NAME VARCHAR(500)
,EMAIL VARCHAR(500)
,CATEGORY_ID INT
,SHOP_ID INT
,PEASANT_ID INT
,TRANSACTION_DATE VARCHAR(50)
,VIRGINITY_LEVEL INT
,PRICE_PER_GIG VARCHAR(500)
,SEGNEMNT_TEXT VARCHAR(200)
,URL VARCHAR(200)
,BLOCKCHAIN_HASH VARCHAR(64)
);COURSES.SCH_CZECHITA_ILINAO.KREICI_FAKE_TABLE
                        
---------------------------------------------------------                        
-- ÚKOLY
---------------------------------------------------------

/*
Importujte ukol.csv do Snowflake. Vytvořte si tabulku, která bude obsahovat sloupce jako v csv souboru. 
    //Prohlédněte si nejdříve data třeba v textovem nastroji (Podívejte se na datové typy. NÁPOVĚDA: Datum není datum - importujte jako string).

//B/ Importujte data do tabulky. Pozor budete si muset vytvořit vlastní file format!!!


Úprava dat:
- 5.1: Najděte řádky, kde není vyplněné jméno, nebo datum narození a ty vymažte.
- 5.2: V poli Birth Date odstraňte přebytečné mezery a vytvořte sloupec s datovým typem Date.( NÁPOVĚDA: REPLACE)
- 5.3: Vytvořte dva nové sloupce Name and Surname a vložte do nich rozdělená data z pole Full name.
- 5.4: Pole Name a Surname upravte tak, aby první písmeno bylo vždy velké (nápověda funkce UPPER,SUBSTRING).
- 5.5: Vypište počet klientů dle věkových kategorií (1-10,10-20,20-30,více než 30) žijících v Číně.

*/





-- BONUSOVÉ

---------------------------------------------------------
---- BONUS: NULLS
---------------------------------------------------------
CREATE OR REPLACE TABLE NULLS (
  COL1 VARCHAR
  , COL2 VARCHAR
);


INSERT INTO NULLS 
  VALUES
  (NULL, '1'),
  ('1', NULL),
  (NULL, NULL);

SELECT * FROM NULLS;

---------------------------------------------------------                        
-- Nešťastný UPDATE a kouzelný SELECT AT (TIME TRAVEL)
---------------------------------------------------------                        

---- BONUS: TIME TRAVEL 
-- https://docs.snowflake.com/en/user-guide/data-time-travel
CREATE OR REPLACE TABLE xx_prycsemnou AS
SELECT
    gname
    ,city
    ,SUM(nkill) killed
    ,SUM(nwound) wounded
FROM SCH_TEROR.TEROR
WHERE iyear=2016
GROUP BY gname, city;
 
SELECT * FROM xx_prycsemnou;

 SELECT CURRENT_TIMESTAMP(); --2024-03-25 08:47:09.777 -0700

UPDATE xx_prycsemnou SET killed = 0; -- TADY NAM TROCHU CHYBI PODMINKA

-- jak to spravit?

SELECT * FROM xx_prycsemnou AT(OFFSET => -30);
SELECT * FROM xx_prycsemnou AT(STATEMENT => ''); --> query id selectu, kdy tabulka byla ok
SELECT * FROM xx_prycsemnou AT(TIMESTAMP => ''::TIMESTAMP); --> timestamp, kdy tabulka byla ok (CAS V UTC)


CREATE OR REPLACE TABLE xx_prycsemnou_zdrava AS
SELECT * FROM xx_prycsemnou BEFORE(STATEMENT => ''); --> query id selectu, ktery to zkazil

SELECT * FROM xx_prycsemnou_zdrava;

DROP TABLE xx_prycsemnou;



05_LEKCE.txt
Відображається "05_LEKCE.txt".