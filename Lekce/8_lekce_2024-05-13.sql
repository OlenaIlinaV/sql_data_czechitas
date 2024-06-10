----------------------------------------------------------------------------------------------------
-- Nepovinná lekce Michal - Další užitečné funkce ve Snowflaku


-- Opakovací příklad na rozjezd (agregační funkce + UNION ALL)
-- CLONE TABLE a opakování práce s tabulkami a sloupci v nich
-- WINDOW funkce - další funkce: ROW_NUMBER, RANK

-- Tvorba ID a základní struktury tabulky
   -- UNIFORM, RANDOM, GENERATOR, CROSS JOIN, SEQUENCE, HASHovací funkce

-- Velký příklad
-- program DBeaver (práce s různými databázemi)
-- ukázka skriptu z praxe

-- MOŽNÉ BONUSY
   -- Komentované řešení úkolů - window funkce
   -- Polostrukturovana data: VARIANT, ARRAY, OBJECT, PARSE_JSON
----------------------------------------------------------------------------------------------------




----- Důležitá pravidla:

-- Když píšeš kód, průběžně ho testuj po malých částech - aby sis byla jistá co dělá.
-- Snaž se kód psát přehledně a piš komentáře!
-- Nevíš-li, hledej v dokumentaci a na fórech.






-------------------------------------------------------------------------------------------
----- Příklad z praxe jako dnešní rozcvička (agregační funkce + UNION ALL)
-------------------------------------------------------------------------------------------

-- Máme velkou tabulku účetního deníku, který obshuje miliony řádků. Tuto tabulku posíláme do PowerBI, pro který se ale stává příliš velká.
-- Domluvili jsme s klientem agregaci starších dat na měsíční bázi, aby se velikost tabulky zmenšila.

-- Pojďme si to společně vyzkoušet:
-- Vytvořte tabulku na bázi tabulky TEROR, která bude obsahovat sloupce Datum (IDATE), COUNTRY_TXT, NKILL, NKILLTER.
-- Pro roky 2014 až 2016 bude tato tabulka agregovaná na měsíční bázi (dimenze tedy budou datum (rok a měsíc), COUNTRY_TXT) a metriky NKILL, NKILLTER (resp. jejich suma). To znamená 1-n úroků = 1 řádek výsledné tabulky
-- Pro rok 2017 chceme mít v tabulce plná data (na denní bázi), to znamená 1 útok = 1 řádek. 
-- Všechny roky chceme sloučit do jenoho výsledku dotazu.
-- Práce s primárním klíčem: Pro roky 2014-2016 použij jako ID hodnotu v EVENTID. Pro rok 2017 pak vytvoř klíč z data a země.







-- Pro rok 2017 každý řádek tabulky TEROR = řádek výstupu
SELECT
      EVENTID::VARCHAR -- Přecastováváme protože v druhé části unionu máme i písmena
    , IDATE
    , COUNTRY_TXT
    , NKILL
    , NKILLTER
FROM TEROR
WHERE IYEAR = 2017

UNION ALL

SELECT
      DATE_TRUNC('MONTH', "IDATE") || COUNTRY_TXT AS ID -- Nově vytvořené id z data a země
    , DATE_TRUNC('MONTH', "IDATE")
    , COUNTRY_TXT
    , SUM(NKILL) -- Zde agregujeme na bázi data a země
    , SUM(NKILLTER) -- Zde agregujeme na bázi data a země
FROM TEROR
WHERE IYEAR IN ('2014', '2015', '2016')
GROUP BY DATE_TRUNC('MONTH', "IDATE"), COUNTRY_TXT
;

-------------------------------------------------------------------------------------------
----- CLONE TABLE a opakování práce se sloupci v tabulkách
-------------------------------------------------------------------------------------------

-- klonovat se daji i schemata, databaze a dalsi radosti
-- CLONE vytvori samostatnou kopii - zmeny v puvodni tabulce neovlivni zmeny v klonovane tabulce

DESC TABLE DUMMY_DATA;

CREATE OR REPLACE TABLE DUMMY_DATA_CLON CLONE DUMMY_DATA;

DESC TABLE DUMMY_DATA_CLON;
DROP TABLE DUMMY_DATA_CLON;

-- VERSUS
CREATE OR REPLACE TABLE DUMMY_DATA_CLON AS
SELECT * FROM DUMMY_DATA;
-- rozdil je ve vecech, ktere tolik nevidime - jak snowflake naklada se storage, jaka metadata se kopiruji


-- ALTER TABLE - přejmenování tabulky, přejmenování sloupce, přidání a odebrání sloupce z tabulky

ALTER TABLE DUMMY_DATA_CLON RENAME TO DUMMY_DATA_CLON2;

ALTER TABLE DUMMY_DATA_CLON2 DROP COLUMN COUNTRIES;

ALTER TABLE DUMMY_DATA_CLON2 RENAME COLUMN PLATFORM TO SERVICE;

ALTER TABLE DUMMY_DATA_CLON2 ADD COLUMN ORANGE NUMBER(38,5) DEFAULT 1;

SELECT * FROM DUMMY_DATA_CLON2;

-- DELETE FROM TABLE - smazání specifikovaných záznamů z tabulky

DELETE FROM DUMMY_DATA_CLON2
       WHERE ORANGE = 1 AND PRODUCT_ID != 219;

       
-- UPDATE IN TABLE - změna honoty konkrétních záznamů

UPDATE DUMMY_DATA_CLON2
       SET CREATED = dateadd(day, -1, CREATED)
       WHERE SERVICE = 'web';


------------------------------------------------------------------
-- PROCVIČUJEME WINDOW FUNKCE:
-----------------------
Na zubařském datasetu sestavte SELECT, který pro každou návštěvu určí následující:

ID_NAVSTEVY, JMENO, DATUM, POPIS, POCET_NAVSTEV_PACIENTA, KOLIKATA_NAVSTEVA_PACIENTA, KOLIKATA_NAVSTEVA_PACIENTA_V_DANY_DEN, KOLIKATA_NAVSTEVA_PACIENTA_V_ROCE, DATUM_PRVNI_NAVSTEVY_PACIENTA, POPIS_PRVNI_NAVSTEVY_PACIENTA, POPIS_POSLEDNI_NAVSTEVY_PACIENTA, KOLIK_MEL_PACIENT_POJISTOVEN, V_KOLIKA_DNECH_MA_PACIENT_NAVSTEVU

















SELECT 
      NAVSTEVY.ID AS ID_NAVSTEVY
    , PACIENTI.JMENO AS JMENO
    , DATUM
    , POPIS
    , COUNT(*) OVER (PARTITION BY PACIENT_ID) AS POCET_NAVSTEV_PACIENTA
    , COUNT(*) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM) AS KOLIKATA_NAVSTEVA_PACIENTA
    , COUNT(*) OVER (PARTITION BY PACIENT_ID, DATE(DATUM) ORDER BY DATUM) AS KOLIKATA_NAVSTEVA_PACIENTA_V_DANY_DEN
    , COUNT(*) OVER (PARTITION BY PACIENT_ID, YEAR(DATUM) ORDER BY DATUM) AS KOLIKATA_NAVSTEVA_PACIENTA_V_ROCE
    , MIN(DATUM) OVER (PARTITION BY PACIENT_ID) AS DATUM_PRVNI_NAVSTEVY_PACIENTA
    , FIRST_VALUE(POPIS) OVER (PARTITION BY PACIENT_ID ORDER BY PACIENT_ID) AS POPIS_PRVNI_NAVSTEVY_PACIENTA
    , LAST_VALUE(POPIS) OVER (PARTITION BY PACIENT_ID ORDER BY PACIENT_ID) AS POPIS_POSLEDNI_NAVSTEVY_PACIENTA
    , COUNT(DISTINCT POJISTOVNA_ID) OVER (PARTITION BY PACIENT_ID) AS KOLIK_MEL_PACIENT_POJISTOVEN
    , COUNT(DISTINCT DATE(DATUM)) OVER (PARTITION BY PACIENT_ID) AS V_KOLIKA_DNECH_MA_PACIENT_NAVSTEVU

FROM NAVSTEVY
LEFT JOIN PACIENTI ON NAVSTEVY.PACIENT_ID=PACIENTI.ID
;



SELECT
      NAVSTEVY.ID AS ID_NAVSTEVY
    , PACIENTI.JMENO AS JMENO
    , DATUM
    , POPIS
    , COUNT(*) OVER (PARTITION BY PACIENT_ID) AS POCET_NAVSTEV_PACIENTA
    , COUNT(*) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM) AS KOLIKATA_NAVSTEVA_PACIENTA
    , COUNT(*) OVER (PARTITION BY PACIENT_ID, DATE(DATUM) ORDER BY DATUM) AS KOLIKATA_NAVSTEVA_PACIENTA_V_DANY_DEN
    , COUNT(*) OVER (PARTITION BY PACIENT_ID, YEAR(DATUM) ORDER BY DATUM) AS KOLIKATA_NAVSTEVA_PACIENTA_V_ROCE
    , MIN(DATUM) OVER (PARTITION BY PACIENT_ID) DATUM_PRVNI_NAVSTEVY_PACIENTA
    , FIRST_VALUE (POPIS) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM) AS POPIS_PRVNI_NAVSTEVY_PACIENTA
    , LAST_VALUE (POPIS) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM) AS POPIS_POSLEDNI_NAVSTEVY_PACIENTA
    , COUNT(DISTINCT POJISTOVNA_ID) OVER (PARTITION BY PACIENT_ID) AS  KOLIK_MEL_PACIENT_POJISTOVEN
    , COUNT(DISTINCT DATE(DATUM)) OVER (PARTITION BY PACIENT_ID) AS V_KOLIKA_DNECH_MA_PACIENT_NAVSTEVU
    , COUNT(DISTINCT DATE(DATUM)) OVER () AS V_KOLIKA_DNECH_BYLA_NAVSTEVA
    , COUNT(DISTINCT PACIENT_ID) OVER (PARTITION BY DATUM_NAROZENI) KOLIK_PACIENTU_MA_TO_STEJNE_DATUM_NAROZENI
    , COUNT(DISTINCT PACIENT_ID) OVER (PARTITION BY DATE(DATUM)) AS KOLIK_PACIENTU_MA_NEJAKOU_NAVSTEVU_VE_STEJNY_DEN
    , LAG(POPIS) OVER (ORDER BY DATUM)
    , LAG(POPIS) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM ASC) AS POPIS_PREDCHOZI_NAVSTEVY_PACIENTA
    , LAG(POPIS) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM DESC) AS POPIS_DALSI_NAVSTEVY_PACIENTA
    , LAG(DATE(DATUM)) OVER (PARTITION BY PACIENT_ID ORDER BY DATUM) AS DATUM_POSLEDNI_NAVSTEVY_PACIENTA
FROM NAVSTEVY
LEFT JOIN PACIENTI ON NAVSTEVY.PACIENT_ID = PACIENTI.ID


       
-------------------------------------------------------------------------------------------
----- UNIFORM, GENERATOR
-------------------------------------------------------------------------------------------

-- UNIFORM(min,max,generator) -- https://docs.snowflake.com/en/sql-reference/functions/uniform.html
-- random cislo z uniformni distribuce = kazde cislo ma stejnou pravdepodobnost vyberu

SELECT
    UNIFORM(50,100,RANDOM()) --> vzdy random cislo
    , UNIFORM(1, 10, 1)  --> vzdy konstantni cislo
;


-- Vytvoř šestistranou kostku pro Člověče nezlob se:















SELECT UNIFORM(1,6,RANDOM());


-- pouziti v tabulce
SELECT
    *
    ,UNIFORM(50,100,RANDOM())
FROM DUMMY_DATA;


-- RANDSTR(length,generator)
SELECT RANDSTR(9,RANDOM());


-- GENERATOR jako table function (=naplneni tabulky)

-- ROWCOUNT VS TIMELIMIT
SELECT
    1
FROM
TABLE(generator(rowcount => 10));

SELECT
    1
FROM
TABLE(generator(timelimit => 0.1));

SELECT
    RANDSTR(12,RANDOM()) -- generujeme náhodné řetězce ve velkém
FROM
TABLE(generator(rowcount => 100));

SELECT
    UNIFORM(0,100,RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => 50));

SELECT
    ROW_NUMBER() OVER (ORDER BY NULL) -- window funkce pro očíslování řádku
FROM TABLE(GENERATOR(ROWCOUNT => 50));



-- Pouziti generatoru ke generovani datumu, chceme ziskat posledních 90 dni.
-- trik: budeme ODECITAT ROW_NUMBER OD DNESNIHO DATA

















SELECT CURRENT_DATE() - ROW_NUMBER() OVER (ORDER BY NULL) + 1
FROM TABLE (GENERATOR(ROWCOUNT => 90))
;

-- To samé méně prasácky, ale složitěji na zápis :-)

SELECT
  DATEADD(
    DAY,
    '-' || ROW_NUMBER() OVER (ORDER BY NULL),
    DATEADD(DAY, '+1', CURRENT_DATE()
           )
  ) AS DATE
FROM TABLE (GENERATOR(ROWCOUNT => 90))
;


---------------------------------------------------------
-- CROSS JOIN
---------------------------------------------------------

-- Příkaz, který slouží ke spojení 2 tabulek v relační databázi. Jeho výsledkem je kartézský součin
   -- = všechny kombinace levé (A) a pravé (B) tabulky.
-- https://i.ytimg.com/vi/QJFq0Lko2Fw/maxresdefault.jpg

-- SYNTAXE
SELECT vybrane_sloupce
FROM Tabulka_A
CROSS JOIN Tabulka_B
;

-- Příklad, tvoříme menu v restauraci:
-- https://www.sqlshack.com/wp-content/uploads/2020/02/sql-cross-join-working-mechanism.png

CREATE OR REPLACE TABLE MEALS (MEALNAME VARCHAR(100));
CREATE OR REPLACE TABLE DRINKS (DRINKNAME VARCHAR(100));
INSERT INTO DRINKS
VALUES('ORANGE JUICE'), ('TEA'), ('COFEE');
INSERT INTO MEALS
VALUES('OMLET'), ('FRIED EGG'), ('SAUSAGE');
SELECT *
FROM MEALS;
SELECT *
FROM DRINKS;

-- Jdeme na CROSS JOIN:

SELECT *
FROM MEALS
CROSS JOIN DRINKS;


-- Co se stane, když máme v některé z zabulek duplicity?

INSERT INTO DRINKS
VALUES('ORANGE JUICE');

SELECT *
FROM MEALS
CROSS JOIN DRINKS;



---------------------------------------------------------------------------------
--- SEQUENCE
---------------------------------------------------------------------------------

-- https://docs.snowflake.com/en/user-guide/querying-sequences.html

-- Create sequence
CREATE OR REPLACE SEQUENCE "sequence_ukazkova" start = 1 increment = 1;

-- Použití sequence
SELECT
    NAME,
    "sequence_ukazkova".nextval AS SEKVENCE_ZEME
FROM COUNTRY
-- ORDER BY NAME DESC
;

-- Informace o existujících sekvencích
SHOW SEQUENCES;


---------------------------------------------------------------------------------
--- Tvorba ID, Hashovací funkce
---------------------------------------------------------------------------------

CREATE OR REPLACE TABLE NEMAM_KLIC (DESTINACE_ZAJEZDU VARCHAR(100), TERMIN_ZAJEZDU VARCHAR(100), POCET_UCASTNIKU VARCHAR(100));

INSERT INTO NEMAM_KLIC
VALUES
(('Mexiko'), ('1. - 15. ledna 2022'), ('30')),
(('Španělsko'), ('1. - 15. ledna 2022'), ('40')),
(('Mexiko'), ('20. - 31. ledna 2022'), ('15')),
(('Španělsko'), ('2. - 18. března 2022'), ('30'))
;

-- Když nemáme v tabulce unikátni id, můžeme si ho vytvořit:

CREATE OR REPLACE TABLE UZ_MAM_KLIC_HURA AS
SELECT
    "DESTINACE_ZAJEZDU"||"TERMIN_ZAJEZDU" AS ID, -- takto jednoduše
    "DESTINACE_ZAJEZDU"||' - '||"TERMIN_ZAJEZDU" AS ID_lepsi, -- Michalovo doporučení z praxe
    *
FROM NEMAM_KLIC;


-- Hashovací funkce: MD5, SHA2 
-- Vytvoří definovaně dlouhý řetěžec znaků a číslic
-- Stejný vstup vytvoří vždy stejný výstup
-- Malá změna na vstupu vyústí ve velkou změnu ve výstupu hashovací fce

-- Snadno spočítám hash, v opačném směru je to extrémně náročné až nemožné 
   -- Využití v zabezpečení internetového bankovnictví apod.


SELECT
    MD5(ID) AS MD5_HASH,
    SHA2(ID) AS SHA2_HASH,
    *
FROM UZ_MAM_KLIC_HURA;



---------------------------------------------------------------------------------
---- Co si odnést?

-- Na začátek je dobré si vytvořit požadovanou strukturu výstupní tabulky
  -- Pokud potřebuji např. všechny dny ve všech pobočkách:
    -- Vygeneruji si všechny dny (GENERATE)
    -- Vypíšu si všechny pobočky
    -- Spojím dohromady přes CROSS JOIN
    -- Do této struktury mohu najoinovat transakční data
    -- Pokud použiju (SELECT DISTINCT den, pobocka), je možné, že některé kombinace budou chybět

-- Když nemám v tabulce klíč, tak si ho vytvořím:
    -- spojím všechny dimenze do jednoho id,
    -- nebo použiji číslo řádku (ROW_NUMBER) 
    -- výsledek mohu zahashovat (výhoda: anonymizace)













----------------------------------------------------------------------------------------
-- UKOL na procvičení CROSS JOIN, LEFT JOIN, CTE, WINDOW funkcí, GENERATOR, GROUP BY atd.
----------------------------------------------------------------------------------------

-- 1: Připravte si SELECT pro výběr všech zemí z tabulky COUNTRY (každá země bude ve výsledku jednou)

-- 2: Napište SELECT pro vygenerování všech datumů mezi 2017-02-05 a 2017-02-14 (včetně) - použijte funkci GENERATOR
-- Proč je tento postup univerzálnější než si udělat SELECT všech datumů z transakční tabulky?

-- 3: Vytvořte CROSS JOIN těchto dvou dotazů - tedy nový dotaz, který zobrazí všechny země z tabulky COUNTRY a pro každou zemi vytvoří záznam pro každý den z vybraného období. Použijme CTE (dočasnou tabulku) pro DATUMY, protože nemáme práva tabulky vytvářet.

-- 4: Do tabulky vytvořené výše doplňte počet útoků, které proběhly v daný den v dané zemi z tabulky TEROR. Zachovejte strukturu, pouze přidejte dodatečný sloupec POCET_UTOKU. (Nápověda: využijeme LEFT JOIN)

-- 5: Vypište pouze jeden den (= jeden řádek) pro každou zemi, a to ten den, kdy byl počet útoků nejvyšší (myšleno pro danou zemi a ve sledovaném období).

-- 6: Vypište pouze jednu zemi (= jeden řádek) pro každý den, a to tu zemi, kdy byl počet útoků v daném dni nejvyšší. Doplňte, kolik útoků se v daný den v zemi odehrálo.








----------------------------------------------------------------------------------------
-- UKOL - ŘEŠENÍ
----------------------------------------------------------------------------------------

-- 1: Připravte si SELECT pro výběr všech zemí z tabulky COUNTRY (každá země bude ve výsledku jednou)

SELECT DISTINCT NAME
FROM COUNTRY
;

-- 2: Napište SELECT pro vygenerování všech datumů mezi 2017-02-05 a 2017-02-14 (včetně) - použijte funkci GENERATOR
-- Proč je tento postup univerzálnější než si udělat SELECT všech datumů z transakční tabulky?

SELECT '2017-02-04'::DATE + ROW_NUMBER() OVER (ORDER BY NULL) AS DATUM
FROM TABLE(GENERATOR (ROWCOUNT => 10))
;

-- 3: Vytvořte CROSS JOIN těchto dvou dotazů - tedy nový dotaz, který zobrazí všechny země z tabulky COUNTRY a pro každou zemi vytvoří záznam pro každý den z vybraného období. Použijme CTE (dočasnou tabulku) pro DATUMY, protože nemáme práva tabulky vytvářet.

WITH DATUMY AS
(SELECT '2017-02-04'::DATE + ROW_NUMBER() OVER (ORDER BY NULL) AS DATUM
FROM TABLE(GENERATOR(ROWCOUNT => 10)))

SELECT NAME, DATUM
FROM COUNTRY
CROSS JOIN DATUMY;

-- 4: Do tabulky vytvořené výše doplňte počet útoků, které proběhly v daný den v dané zemi z tabulky TEROR. Zachovejte strukturu, pouze přidejte dodatečný sloupec POCET_UTOKU. (Nápověda: vyuřžijeme LEFT JOIN)

WITH DATUMY AS
(SELECT '2017-02-04'::DATE + ROW_NUMBER() OVER (ORDER BY NULL) AS DATUM
FROM TABLE(GENERATOR(ROWCOUNT => 10)))

SELECT NAME, DATUM, COUNT(*) AS POCET_UTOKU
FROM COUNTRY AS CO
CROSS JOIN DATUMY AS DAT
LEFT JOIN TEROR AS TER ON TER.COUNTRY_TXT = CO.NAME AND DAT.DATUM = TER.IDATE
GROUP BY NAME, DATUM
;

-- 5: Vypište pouze jeden den (= jeden řádek) pro každou zemi, a to ten den, kdy byl počet útoků nejvyšší (myšleno pro danou zemi a ve sledovaném období).

WITH KOMPLETNI_TABULKA AS (
WITH DATUMY AS
(SELECT '2017-02-04'::DATE + ROW_NUMBER() OVER (ORDER BY NULL) AS DATUM
FROM TABLE(GENERATOR(ROWCOUNT => 10)))

SELECT NAME, DATUM, COUNT(*) AS POCET_UTOKU
FROM COUNTRY AS CO
CROSS JOIN DATUMY AS DAT
LEFT JOIN TEROR AS TER ON TER.COUNTRY_TXT = CO.NAME AND DAT.DATUM = TER.IDATE
GROUP BY NAME, DATUM
)

SELECT DISTINCT 
      NAME
    , FIRST_VALUE(DATUM) OVER (PARTITION BY NAME ORDER BY POCET_UTOKU DESC) AS DEN_S_NEJVICE_UTOKY
 -- , FIRST_VALUE(POCET_UTOKU) OVER (PARTITION BY NAME ORDER BY POCET_UTOKU DESC) AS POCET_UTOKU_V_DEN_S_NEJVICE_UTOKY

FROM KOMPLETNI_TABULKA
ORDER BY NAME
;

-- 6: Vypište pouze jednu zemi (= jeden řádek) pro každý den, a to tu zemi, kdy byl počet útoků v daném dni nejvyšší. Doplňte, kolik útoků se v daný den v zemi odehrálo.

WITH KOMPLETNI_TABULKA AS (
WITH DATUMY AS
(SELECT '2017-02-04'::DATE + ROW_NUMBER() OVER (ORDER BY NULL) AS DATUM
FROM TABLE(GENERATOR(ROWCOUNT => 10)))

SELECT NAME, DATUM, COUNT(*) AS POCET_UTOKU
FROM COUNTRY AS CO
CROSS JOIN DATUMY AS DAT
LEFT JOIN TEROR AS TER ON TER.COUNTRY_TXT = CO.NAME AND DAT.DATUM = TER.IDATE
GROUP BY NAME, DATUM
)

SELECT DISTINCT 
    DATUM
    , FIRST_VALUE(NAME) OVER (PARTITION BY DATUM ORDER BY POCET_UTOKU DESC) AS ZEME_S_NEJVICE_UTOKY
    , FIRST_VALUE(POCET_UTOKU) OVER (PARTITION BY DATUM ORDER BY POCET_UTOKU DESC) AS POCET_UTOKU_V_ZEMI_S_NEJVICE_UTOKY

FROM KOMPLETNI_TABULKA 
;




---------------------------------------------------------------------------------
--- Ukázka programu DBeaver
---------------------------------------------------------------------------------

-- Open source program pro práci s databázemi
-- Podporuje hrozně moc typů databází, ke kterým se můžeme připojit a pracovat s nimi

-- https://dbeaver.io/

-- Připojíme se do našeho Snowflaku?







------------------------------------------------------------------
-- Ukázka mého reálného skriptu
------------------------------------------------------------------

-- UNION, tvorba id, sekvence, window funkce, hash













---------------------------------------------------------
-- BONUSY
---------------------------------------------------------

---------------------------------------------------------
-- UKOLY Z LEKCE 7
---------------------------------------------------------

// A/ Vypiš tři největší útoky pro organizace s více než 500 obětmi. Vypiš sloupečky city, gname a nkill a rank. Výsledek seřaď podle gname a rank

-- pouze window funkce
----------------------






-- vnorena query
----------------







// B/ Vypiš 5 nejaktivnějších organizací (dle počtu útoků) podle regionu. Výsledek seraď podle regionu a ranku.








---------------------------------------------------------

-- ŘEŠENÍ:

-- A jako WINDOW funkce

SELECT 
    gname,
    city, 
    nkill, 
    RANK() OVER (PARTITION BY gname ORDER BY nkill DESC) AS rank 

FROM teror
  
WHERE nkill IS NOT NULL 
QUALIFY SUM(nkill) OVER (PARTITION BY gname) > 500 
    AND rank <= 3
ORDER BY gname, rank;

-- A jako vnořená query

SELECT city, gname, nkill, rank 

FROM (
  SELECT *, RANK() OVER (PARTITION BY gname ORDER BY nkill DESC) AS rank 
  FROM teror
  WHERE nkill IS NOT NULL 
      AND gname IN (    SELECT gname as sk 
                        FROM teror 
                        GROUP BY gname 
                        HAVING sum(nkill) > 500 
                        ORDER BY sum(nkill)
                    )
     ) 
 
WHERE rank <= 3
ORDER BY gname, rank
;

-- B

 SELECT * 
 FROM
    (    SELECT gname, region_txt, COUNT(*) as pocet_akci
         , RANK() OVER (PARTITION BY region_txt ORDER BY pocet_akci DESC) AS rank
         
         FROM teror
         WHERE nkill IS NOT NULL
         GROUP BY gname, region_txt
    ) 
 WHERE rank <= 5 
 ORDER BY region_txt, rank
 ;








---------------------------------------------------------------------------------
--- POLOSTRUKTUROVANA DATA - VARIANT, ARRAY, OBJECT
---------------------------------------------------------------------------------

-- VARIANT DATA TYPE -> umoznuje vlozit ruzne datove typy do jednoho sloupce (= nad ramec relacnich db)

-- z dokumentace na variant: https://docs.snowflake.com/en/sql-reference/data-types-semistructured.html
SELECT *
FROM VARTAB;


-- V = VARIANT
DESC TABLE VARTAB;

-- metoda pro VARIANT - zjisteni datoveho typu TYPEOF()
SELECT n, v, TYPEOF(v)
FROM vartab;



-- ARRAY (pole)
-- podivame se na to, jak snoflake pracuje s arrayem
-- backslash - espace characters

SELECT '["tohle", "je", "array"]'::VARIANT;
SELECT TYPEOF('["tohle", "je", "array"]'::VARIANT);

-- k vytvorit array pouzijeme -> parse_json
SELECT PARSE_JSON('["tohle", "je", "array"]'); -- pouze validni json strukturu, parse_json prevede na array, musi mit validni strukturu json, mam zmodrano(vevnitr mam entry, muzeme klikat)
SELECT TYPEOF(PARSE_JSON('["tohle", "je", "array"]')); -- az ted je to array uvnitr variant datoveho typu


-- OBJECT (obsahuje páry klíč - data) -- key with characteristics are called properties
SELECT '{"key": "value"}'; -- text -- strkutrua > {}
SELECT TYPEOF('{"key": "value"}'::VARIANT); -- variant, uvnitr text
SELECT PARSE_JSON('{"key": "value", "key1": "value"}'); -- variant, uvnitr object
SELECT TYPEOF(PARSE_JSON('{"key": "value", "key1": "value"}'));

SELECT PARSE_JSON('{"key": "value", "key1": "value"}'):"key"; -- jak pristupovat k hodnotam, vse pred timhe :"key"; je objekt, pomoci :"key"; si volam hodnotu co mam v objektu
-- "" vraci mi to hodnotu json s dvojtima uvozovkama, kdyz s tim chci pracovat, musim to prevedst, idealne na datovy typ, ktery na tu value sedi:
-- pozor, jedna dvojtecka, pristupuju k objektu, dve dvojtecky, pretypovavam

SELECT PARSE_JSON('{"key": "value", "key1": "value"}'):"key"::STRING; -- vzdy pretypovat na spravny datovy typ - zbavime se uvozovek
-- mame pretypovano

-- vnorene json struktur, misto hodnoty muzete mit list a podobne
SELECT PARSE_JSON('{"key": "value", "key1": {"key_uvnitr": "value_uvnitr"}}') AS json_str
       , json_str:"key1" -- prvni (nulta) uroven vnoreni
       , json_str:"key1"."key_uvnitr"::STRING -- druha uroven vnoreni - pristupujeme pres tecku
;


-- priklad v datech
SELECT *
FROM DUMMY_DATA_CLON2;

DESC table DUMMY_DATA_CLON2;


SELECT
    *
    -- pokud nemame datovy typ variant + uvnitr object
    , PARSE_JSON(platform_metadata):"orderId"::INT AS "orderId"
    -- pokud mame variant - parse_json neni potreba
    --, platform_metadata:"orderId"::INT AS "orderId"
FROM DUMMY_DATA_CLON2;
