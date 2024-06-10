--Agenda:
----SQL flavours a jejich rozdily
----dalsi uzitecne funkce
----opakovani latky plus jeji rozsireny
----co po Czechitas

--CAST 1;
--DIFFERENT SQL FLAVOURS
-- SNOWFLAKE --vychazi z Oracle flavour, takze funkce a syntax vychazeji z Oracle
-- ORACLE
-- SQL Server
-- MySQL
-- PostgreSQL
-- SQLite


----------------------------------------------------------------------------------------------------------------------------------
--CAST 2;
--Priklady rozdilu
- CHARINDEX VS INSTR; --najdi znak nebo sadu znaku v stringu
    --SNOWFLAKE https://docs.snowflake.com/en/sql-reference/functions/charindex
    --ORACLE https://docs.oracle.com/database/121/SQLRF/functions089.htm#SQLRF00651
    --SQL SERVER https://www.w3schools.com/sql/func_sqlserver_charindex.asp
    --MySQL https://www.w3schools.com/sql/func_mysql_instr.asp

--Jak Charindex funguje, priklady:
--CHARINDEX(hledany znak/y, sloupecek, pozice kde zacit)
SELECT CHARINDEX('an', 'banana', 1), CHARINDEX('an', 'banana', 3);

SELECT "CAST", CHARINDEX(',', "CAST", 1) AS CARKA_POZICE
FROM NETFLIX_TITLES2
LIMIT 20;

--SAMOSTATNY UKOL - najdete, kde se nachazi mezera ve jmene pacienta. Pracujete s tabulkou PACIENTI ve schematu SCH_CZECHITA.
--Vypiste i sloupecek JMENO pro overeni spravnosti vypoctu.

- САМОСТАТНЫЙ УКОЛ - найдите, где находится пробел в имени пациента. Вы работаете с таблицей PATIENTS в SCH_CZECHITA.
--Перечислите также столбец ИМЯ, чтобы убедиться в правильности вычислений.


SELECT "JMENO", CHARINDEX(' ', "JMENO", 1) AS JMENO_2
FROM PACIENTI
;


----------------------------------------------------------------------------------------------------------------------------------
--CAST 3
-- SUBSTR VS SUBSTRING --zjednodussene MID v Excelu
--vyber kus stringu na zaklade 2 parametru: zacatek a konec (index)
    --ORACLE https://docs.oracle.com/database/121/SQLRF/functions196.htm#SQLRF06114
    --SNOWFLAKE https://docs.snowflake.com/en/sql-reference/functions/substr
    --SQL SERVER https://www.w3schools.com/sql/func_sqlserver_substring.asp

--SUBSTRING(sloupecek, zacatek, pocet znaku) --> CHARINDEX se nam bude hodit do indexu parametru zacatku
----------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TEMPORARY TABLE PLATBY 
(VARIABILNI_SYMBOL VARCHAR(50));

INSERT INTO PLATBY (VARIABILNI_SYMBOL)
values
('INV12345 / 124'),
('INV99999'),
( '2023/11/12 duplikat INV55555'),
('CREDIT MEMO INV44444'),
('zadna faktura');

--Chceme zjistit cislo faktury.
--Musime najit, kde cislo faktury zacina -- zacatek
--Faktura ma vzdy 8 znaku



SELECT VARIABILNI_SYMBOL
      , CHARINDEX('INV', VARIABILNI_SYMBOL, 1) POZICE_INV
      , CASE WHEN CHARINDEX('INV', VARIABILNI_SYMBOL, 1) = 0 THEN 'N/A' 
             ELSE SUBSTRING(VARIABILNI_SYMBOL,
                            CHARINDEX('INV', VARIABILNI_SYMBOL, 1),
                            8
                           ) 
        END AS CISLO_FAKTURY
FROM PLATBY;

----------------------------------------------------------------------------------------------------------------------------------
--CAST 4 SAMOSTATNY UKOL
    --Pracujte s tabulkou PACIENTI
    --Vytvorte (vypocitejte) nove sloupecky JMENO a PRIJMENI pomoci funkce SUBSTRING a CHARINDEX
    --Napoveda, budete potrebovat pracovat s funkci LENGTH

    
--ВИКОНУЄМО 4 ОКРЕМІ ЗАВДАННЯ
    -- Робота з таблицею ПАЦІЄНТИ
    -- Створити (обчислити) нові стовпці NAME та RECEIVED за допомогою функцій SUBSTRING та CHARINDEX
    -- Підказка, вам потрібно буде попрацювати з функцією ДЛИНА


SELECT  JMENO AS JMEN_PRIJM, 
        SUBSTRING(JMENO, 1, CHARINDEX(' ', JMENO, 1) - 1) AS JMENO,
        SUBSTRING(JMENO, CHARINDEX(' ', JMENO, 1) + 1, LENGTH(JMENO)) AS PRIJMENI
FROM PACIENTI
;


-- LECTOR:

SELECT SUBSTRING(JMENO
                , 1 
                , CHARINDEX(' ', JMENO, 1) - 1)  AS JMENO
    , SUBSTRING(JMENO
                , CHARINDEX(' ', JMENO, 1) + 1
                , LENGTH(JMENO)
                )AS PRIJMENI
FROM PACIENTI;

----------------------------------------------------------------------------------------------------------------------------------
--CAST 5 - WINDOWS FUNCTION
-- QUALIFY pouze ve Snowflaku;--podminka pri windows function, dalsi kombinace jako je FROM-WHERE, GROUP BY-HAVING, WINDOWS FCE-QUALIFY

--Pracujeme s tabulkou NETFLIX_TITLES2
--Vybereme pouze filmy starsi 2010
--Spocitame celkovy pocet filmu za roky v kartotece
--Seradte filmy podle roku asc
--Spocitame running total (windows function), jak se nam pocet filmu zvysoval pres roky.
--Vybereme pouze ty roky, kde jsme celkove (RUNNING TOTAL) dosahli poctu filmu vic jak 5000 v kartotece (QUALIFY)






SELECT RELEASE_YEAR, COUNT(*) AS POCET_FILMU, SUM(POCET_FILMU) OVER (ORDER BY RELEASE_YEAR) AS RUNNING_TOTAL
FROM NETFLIX_TITLES2
WHERE RELEASE_YEAR > 2010
GROUP BY RELEASE_YEAR
QUALIFY RUNNING_TOTAL > 5000
ORDER BY RELEASE_YEAR;





--SAMOSTATNY PRIKLAD
--Pracujte s tabulkami IMDB_TITLES2 a IMDB_RATINGS2, schema SCH_CZECHITA
--Pracujte pouze s udaji, ktere jsou v obou tabulkach
--Vyhledejte vsechny filmy, ktere jsou starsi nez rok 2011
--Vypiste nasledujici sloupecky ORIGINALTITLE, TITLETYPE, STARTYEAR, AVERAGERATING
--Vypoctete prumerny AVERAGERATING v ramci roku a typu titulu pres windows function
--Vyberte pouze ty tituly, ktere maji alespon stejne hodnoceni (AVERAGERATING) jako prumerne hodnoce v ramci roku a typu titulu (viz predchozi krok)


--ОКРЕМИЙ ПРИКЛАД
--Робота з таблицями IMDB_TITLES2 та IMDB_RATINGS2, схема SCH_CZECHITA
--Робота тільки з тими даними, які є в обох таблицях
--Шукати всі фільми, які старші за 2011 рік
--Виведіть наступні стовпці ORIGINALTITLE, TITLETYPE, STARTYEAR, AVERAGERATING
--Обчисліть середнє усереднення за роком і типом назви за допомогою віконної функції
--Відберіть лише ті видання, які мають принаймні такий самий середній рейтинг, як і середній рейтинг за рік і тип видання (див. попередній крок).





SELECT IT.ORIGINALTITLE -- pozor, sloupecek ORIGINALTITLE je v obou tabulkach
      , TITLETYPE, STARTYEAR, AVERAGERATING
      , AVG(AVERAGERATING) OVER (PARTITION BY TITLETYPE, STARTYEAR) AS AVG_PER_YEAR_TYPE
FROM IMDB_TITLES2 IT
INNER JOIN IMDB_RATINGS2 IR ON IT.TCONST = IR.TCONST
WHERE STARTYEAR > 2011
QUALIFY AVERAGERATING >= AVG_PER_YEAR_TYPE
ORDER BY STARTYEAR DESC, TITLETYPE;



--SAMOSTATNY UKOL Jak vyresit situaci, kdyz SQL flavour nezna QUALIFY?
-- POZOR - v tomto pripade, potom sloupecek AVERAGERATING MUSI byt vypsan v subselektu, abyste s tim nadale mohly pracovat.

-- SAMOSTATNY UKOL Як вирішити ситуацію, коли SQL flavour не знає QUALIFY?
-- УВАГА - у цьому випадку стовпець AVERAGERATING ОБОВ'ЯЗКОВО має бути вказаний у підвибірці, щоб продовжити роботу з ним.



SELECT *
FROM
    (
    SELECT IT.ORIGINALTITLE, TITLETYPE, STARTYEAR, AVERAGERATING, AVG(AVERAGERATING) OVER (PARTITION BY TITLETYPE, STARTYEAR) AS AVG_PER_YEAR
    FROM IMDB_TITLES2 IT
    INNER JOIN IMDB_RATINGS2 IR ON IT.TCONST = IR.TCONST
    WHERE STARTYEAR > 2011
    )
WHERE AVG_PER_YEAR >= AVERAGERATING
ORDER BY STARTYEAR DESC, TITLETYPE;



----------------------------------------------------------------------------------------------------------------------------------
--CAST 6 NOVE FUNKCE

STRING_AGG vs LISTAGG
    --SRING_AGG v SQL Server
    --LISTAGG ve Snowflaku https://docs.snowflake.com/en/sql-reference/functions/listagg
    --Syntax LISTAGG(sloupecek, deliminator)   WITHIN GROUP (ORDER BY sloupecek) <-- tato cast nepovinna
;

--Chci vypsat vsechny zeme na jednom radku (sloupecku) pro regiony, oddelene carkou.
--Informace maji byt serazeny a nemaji se opakovat.

--1) vsechny unikatni kombinace regionu a zemi, kde se staly nejake teror. udalosti




SELECT DISTINCT REGION_TXT, COUNTRY_TXT FROM TEROR
ORDER BY REGION_TXT, COUNTRY_TXT
;



--??? Jak vypsat tyto informace do jednoho radku?;


-- перший етап
SELECT REGION_TXT, LISTAGG (COUNTRY_TXT, ',') AS ZEME_AGG
FROM TEROR
GROUP BY REGION_TXT
ORDER BY REGION_TXT, ZEME_AGG
;

-- другий етап
SELECT REGION_TXT, LISTAGG (DISTINCT COUNTRY_TXT, ',') AS ZEME_AGG
FROM TEROR
GROUP BY REGION_TXT
ORDER BY REGION_TXT, ZEME_AGG
;


-- третій етап
SELECT REGION_TXT, LISTAGG (DISTINCT COUNTRY_TXT, ',') WITHIN GROUP (ORDER BY country_txt) AS ZEME_AGG
FROM TEROR
GROUP BY REGION_TXT
ORDER BY REGION_TXT, ZEME_AGG
;




-- LECTOR


SELECT region_txt, LISTAGG(country_txt, ', ') as Countries --vsechny (i.e. duplikatni) radky (zeme) v poradi databaze
FROM TEROR
GROUP BY region_txt
ORDER BY region_txt; 


SELECT region_txt, LISTAGG(country_txt, ', ') WITHIN GROUP (ORDER BY country_txt) as Countries --vsechny (i.e. duplikatni) radky (zeme) v jasnem poradi
FROM TEROR
GROUP BY region_txt
ORDER BY region_txt;

SELECT region_txt, LISTAGG(DISTINCT country_txt, ', ') WITHIN GROUP (ORDER BY country_txt) as Countries  -- ORDER BY v ramci skupiny je pouze
FROM TEROR
GROUP BY region_txt
ORDER BY region_txt;



--CAST 7 SAMOSTATNY UKOL
--2) Zobrazte vsechny rezisery (sloupecek director) na jednom raku podle roku vydani (RELEASE_YEAR) a typu filmu (TYPE). Oddelte rezisery carkou.
    --Seradte podle roku vydani a typu filmu.
    --Vyradte ty filmy, kde reziser neni zadan.
    --Pracujte s tabulkou NETFLIX_TITLES2 ve schematu SCH_CZECHITA;



--ВИВЕСТИ 7 ОКРЕМИХ ЗАВДАНЬ
--2) Вивести всіх режисерів (стовпець режисер) на одній стійці за роком випуску (RELEASE_YEAR) та типом фільму (TYPE). Відокремити режисерів лінією.
    --Відсортуйте за роком випуску та типом фільму.
    --Вирізати ті фільми, де не вказано режисера.
    --Робота з таблицею NETFLIX_TITLES2 в SCH_CZECHITA;



SELECT RELEASE_YEAR, TYPE, LISTAGG(DISTINCT DIRECTOR, ', ') WITHIN GROUP (ORDER BY DIRECTOR) AS TOTAL_LIST
FROM NETFLIX_TITLES2
WHERE DIRECTOR IS NOT NULL
GROUP BY RELEASE_YEAR, TYPE
ORDER BY RELEASE_YEAR, TYPE
;



-- LECTOR


SELECT RELEASE_YEAR, TYPE, LISTAGG(DISTINCT DIRECTOR, ', ') WITHIN GROUP (ORDER BY DIRECTOR) as Reziseri
FROM NETFLIX_TITLES
WHERE DIRECTOR IS NOT NULL
GROUP BY RELEASE_YEAR, TYPE
ORDER BY RELEASE_YEAR, TYPE;

--LISTAGGE A NULLOVE HODNOTY vs PRAZDNA HODNOTA
    --pokud je prazdna hodnota v bunce, output je taky prazdna hodnota
    --pokud jsou vsechny hodnoty NULL, tak output je prazdna hodnota ''
    --pokud je alespon jedna hodnota NULL a ostatni ne, tak vrati vsechny nenullove hodnoty (viz reziseri)




------------------------------------
--CAST 8;
--TIPY TRIKY
WHERE 1=1; -- podminka, co je vzdy pravdiva. Pouze napomaha pri testovani kodu, kdy si zkousime jine podminky

--Chceme si otestovat, kolik udaju (pocet radku) pri ruznych kombinaci podminek. NEpatri do produkce
SELECT COUNT(*)
FROM TEROR
WHERE 1=1 --> pravda
     AND IYEAR = 2014
     AND COUNTRY_TXT = 'Colombia'
     AND GNAME LIKE 'A%'
     AND GNAME LIKE 'B%'
     AND NKILL > 100
;
------------------------------------
--CAST 9;
--ORDER BY 1,2 vs ORDER BY s nazvy sloupecku; -- pouze napomaha pri testovani kodu, kdy se nechceme zdrzovat s vypisovanim sloupecku.

-- ROZDILY MEZI TEMITO SKRIPTY:
SELECT DISTINCT COUNTRY_TXT, REGION_TXT
FROM TEROR
ORDER BY REGION_TXT, COUNTRY_TXT
LIMIT 20; --TOHLE ZNAME :)

SELECT DISTINCT COUNTRY_TXT, REGION_TXT
FROM TEROR
ORDER BY 2, 1
LIMIT 20;

SELECT DISTINCT COUNTRY_TXT, REGION_TXT
FROM TEROR
ORDER BY 1, 2
LIMIT 20;




----------------------------------------------------------------------------------------------------------------------------------
--CAST 10 OPAKOVANI a ROZSIRENI ZNALOSTI
-- CORRELATED QUERIES
-- WINDOW FUNCTIONS
-- ??? Kdy MUSIME pouzit vnoreny selekt / korelovany selekt misto WINDOWS funkci?

--Zacneme tim, co uz umime - vnoreny selekt v JOIN
--Pracujeme s tabulkou IMDB_TITLES2
--Vyberte filmy starsi nez rok 2000 s zanrem romance.
--Omezte vyber filmu, kde je zadana nejaka hodnota ve sloupecku RUNTIMEMINUTES
--Spociteje celkovy AVG runtimeminutes v ramci databaze v ramci titletype a startyear


SELECT IMDB_TITLES2.TITLETYPE, PRIMARYTITLE, IMDB_TITLES2.STARTYEAR, RUNTIMEMINUTES, celkove_avg_delka_rok_type
FROM IMDB_TITLES2
LEFT JOIN 
    (SELECT TITLETYPE, STARTYEAR, AVG(RUNTIMEMINUTES) AS celkove_avg_delka_rok_type
     FROM IMDB_TITLES2 AS SUB 
     GROUP BY TITLETYPE, STARTYEAR
     --WHERE SUB.STARTYEAR = MAIN.STARTYEAR AND SUB.TITLETYPE = MAIN.TITLETYPE
    ) AVG_RUNTIME ON AVG_RUNTIME.TITLETYPE = IMDB_TITLES2.TITLETYPE AND AVG_RUNTIME.STARTYEAR = IMDB_TITLES2.STARTYEAR 

WHERE GENRES ilike '%romance%' and IMDB_TITLES2.startyear > 2000
      AND IMDB_TITLES2.runtimeminutes IS NOT NULL;

--Korelovany selekt
-- ??? muzeme radeji pouzit windows funkci??? Kdy ano, kdy ne?

SELECT TITLETYPE, PRIMARYTITLE, STARTYEAR, RUNTIMEMINUTES
        , AVG(RUNTIMEMINUTES) OVER (PARTITION BY STARTYEAR, TITLETYPE) AS avg_delka_rok_type --> bude tato hodnota stejna jako              korelovany subselect?
        , (SELECT AVG(RUNTIMEMINUTES) 
           FROM IMDB_TITLES2 AS SUB 
           WHERE SUB.STARTYEAR = MAIN.STARTYEAR AND SUB.TITLETYPE = MAIN.TITLETYPE 
           --> korelace! Muzeme si to predstavit jako: group by / klice
           ) AS celkove_avg_delka_rok_type
FROM IMDB_TITLES2 AS MAIN
WHERE GENRES ilike '%romance%' and startyear > 2000
     AND runtimeminutes IS NOT NULL 
; 




SELECT IMDB_TITLES2.TITLETYPE, PRIMARYTITLE, IMDB_TITLES2.STARTYEAR, RUNTIMEMINUTES, GENRES,
       avg(runtimeminutes) over (partition by IMDB_TITLES2.titletype, IMDB_TITLES2.startyear) as WINDOWS_avg_runtimeminutes
       , LEFT_JOIN_AVG_RUNTIMENUTES
       ,
        (
        SELECT avg(runtimeminutes)
        FROM IMDB_TITLES2
        ) AS CELKEM_AVG
        ,
        (
        SELECT avg(runtimeminutes)
        FROM IMDB_TITLES2 AS SUB
        WHERE SUB.TITLETYPE = IMDB_TITLES2.TITLETYPE AND SUB.STARTYEAR = IMDB_TITLES2.STARTYEAR
        ) AS KORELOVANY_AVG
FROM IMDB_TITLES2
LEFT JOIN
    (
    SELECT TITLETYPE, STARTYEAR, avg(runtimeminutes) AS LEFT_JOIN_AVG_RUNTIMENUTES
    FROM IMDB_TITLES2
    GROUP BY TITLETYPE, STARTYEAR
    ) AVG_RUNTIME ON IMDB_TITLES2.TITLETYPE = AVG_RUNTIME.TITLETYPE AND  IMDB_TITLES2.STARTYEAR = AVG_RUNTIME.STARTYEAR
where IMDB_TITLES2.startyear > 2000 and runtimeminutes is not null and genres ilike '%romance%'
order by IMDB_TITLES2.titletype, IMDB_TITLES2.startyear
      ;

      
--CAST  10a
--Jaky je pocet udalosti seskupene po regionu a zemi?
--Jaky je celkovy pocet udalost v roce 2015?
--Jaky je pocet udalosti pouze v roce 2015 seskupene po regionu a zemi?




SELECT REGION_TXT, COUNTRY_TXT, COUNT(*) AS POCET_UDALOSTI
       , (SELECT COUNT(*) FROM TEROR WHERE IYEAR = 2015) AS UDALOSTI_2015
       , (SELECT COUNT(*) FROM TEROR AS SUB 
          WHERE SUB.REGION_TXT = MAIN.REGION_TXT AND SUB.COUNTRY_TXT = MAIN.COUNTRY_TXT) AS POCET_GROUP_BY
       , (SELECT COUNT(*) FROM TEROR AS SUB 
          WHERE IYEAR = 2015 AND
                SUB.REGION_TXT = MAIN.REGION_TXT AND SUB.COUNTRY_TXT = MAIN.COUNTRY_TXT) AS POCET_GROUP_BY
FROM TEROR AS MAIN
GROUP BY REGION_TXT, COUNTRY_TXT
ORDER BY REGION_TXT, COUNTRY_TXT
;

-- SAMOSTATNY UKOL:
-- spocitejte pres korelovanou query
--Vypiste tyto sloupecky: primarytitle, startyear, titletype, genres, numvotes
--Pracujeme s tabulkou NETFLIX_IMDB_TEST
--Vyberte pouze tituly JEDNE kategorie (kde se nenachazi carka)
--Spocitejte avg numvotes v ramci TITLETYPE, GENRES, STARTYEAR jako SUBQUERY
--Vypocitejte stejne ale jako WINDOWS funkce





SELECT primarytitle, startyear, titletype, genres, numvotes
       , avg(numvotes) over(partition by startyear, titletype) as celkem_hlasu
       , (SELECT AVG(NUMVOTES) 
           FROM NETFLIX_IMDB_TEST AS SUB 
           WHERE SUB.STARTYEAR = MAIN.STARTYEAR AND SUB.TITLETYPE = MAIN.TITLETYPE AND SUB.GENRES = MAIN.GENRES) AS         
          celkove_avg_numvotes_rok_type_genres
FROM NETFLIX_IMDB_TEST AS MAIN
WHERE GENRES NOT LIKE '%,%'
;



 
----------------------------------------------------------------------------------------------------------------------------------
--CAST 11;
--COALESCE; --OUTPUT PRVNI NENULLOVA HODNOTA ZE ZADANYCH SLOUPECKU
--Syntax COALESCE(sloupecek1, sloupecek2, sloupecek3, sloupecek_n...)

CREATE OR REPLACE TEMPORARY TABLE EMPLOYEES_DETAILS 
(EMPLOYEE_ID INT
, NAME VARCHAR(250)
, MOBILE_PHONE INT
, OFFICE_PHONE INT
, WORK_MOBILE_PHONE INT);

INSERT INTO EMPLOYEES_DETAILS (EMPLOYEE_ID, NAME, MOBILE_PHONE, OFFICE_PHONE, WORK_MOBILE_PHONE )
values
(1, 'petra chytra', 606123123, 800123123, 606999999),
(2, 'jan vesely', null, null , 606123123),
(3, 'emilka uspesna', 606123123, null, null),
(4, 'jana odvazna', null, 800123123, 606999999 ),
(5, 'petr hezky', null, null, null);

select Name, COALESCE(WORK_MOBILE_PHONE, OFFICE_PHONE, MOBILE_PHONE, 9) from EMPLOYEES_DETAILS; --> COALESCE PREBIRA DATOVY TYP PRVNIHO ZADANEHO SLOUPECKU!!!

--> BUDE TU CHYBA???
select Name, COALESCE(WORK_MOBILE_PHONE, OFFICE_PHONE, MOBILE_PHONE, 'nevolejte mi!!!') from EMPLOYEES_DETAILS;


---------------------------------------------------------------------------------------------------------------------
--CAST 13;
--SAMOSTATNY UKOL 
-- Pri migraci dat do tabulky NETFLIX_TITLES2, se spatne sparovala data. Proto, kdyz je v DESCRIPTION nullova hodnota, pouzij sloupecek DURATION. Pokud i hodnota v DURATION je nullova, vypis 'SPATNA MIGRACE, POTREBA OPRAVIT'. Serad podle sloupecku DESCRIPTION sestupne
--Overte si data tak, ze vyhledate pouze ty tituly, kde ani jeden sloupecek nema zadanou hodnotu


















SELECT DESCRIPTION, DURATION, COALESCE(DESCRIPTION,DURATION,'SPATNA MIGRACE, PROSIM OPRAVIT')
FROM NETFLIX_TITLES2
WHERE DESCRIPTION IS NULL OR DURATION IS NULL;

---------------------------------------------------------------------------------------------------------------------------------
--CAST 14;
--HIERARCHICKE TABULKY ANEB SELF-JOIN (-> LEFT JOIN);

/*
LEFT JOIN
RIGHT JOIN
INNER JOIN
FULL (OUTER) JOIN
CROSS JOIN
*/

--nejdriv si vytvorime tabulku
CREATE OR REPLACE TEMPORARY TABLE EMPLOYEES 
(EMPLOYEE_ID INT
, NAME VARCHAR(250)
, MANAGER_ID INT);

--zadame hodnoty do tabulky
INSERT INTO EMPLOYEES (EMPLOYEE_ID, NAME, MANAGER_ID)
values
(1, 'petra chytra', null),
(2, 'jan vesely', 1),
(3, 'emilka uspesna', 1),
(4, 'jana odvazna', 2),
(5, 'petr hezky', 4);

--podivame se na tabulku
SELECT * FROM EMPLOYEES;


--self-join prvni urovne. Dulezity je ALIAS!!!
SELECT *
FROM EMPLOYEES AS PODRIZENY
LEFT JOIN EMPLOYEES AS NADRIZENY ON PODRIZENY.MANAGER_ID = NADRIZENY.EMPLOYEE_ID;











SELECT *
FROM EMPLOYEES AS PODRIZENY
LEFT JOIN EMPLOYEES AS NADRIZENY ON PODRIZENY.MANAGER_ID = NADRIZENY.EMPLOYEE_ID;

--pozor na inner join pri self joinu!!!! 















SELECT E.*, M.EMPLOYEE_ID AS EMP_ID, M.NAME
FROM EMPLOYEES E
INNER JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
ORDER BY E.EMPLOYEE_ID;

--jeste vetsi pozor na inner join, s kazdym self-joinem se nam vysledek zmensuje!














SELECT *
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN EMPLOYEES M1 ON M.MANAGER_ID = M1.EMPLOYEE_ID
LEFT JOIN EMPLOYEES M2 ON M1.MANAGER_ID = M2.EMPLOYEE_ID
ORDER BY E.EMPLOYEE_ID;


---------------------------
--CAST 15;
--SAMOSTATNY UKOL
--!!!! VYTVORTE SI TEMPORARY TABLE - SKRIPT NIZE!!!!
-- Spocitejte 2 kategorie (nahoru).
CREATE OR REPLACE TEMPORARY TABLE ZBOZI
(ID INT
, NAZEV VARCHAR(250)
, KATEGORIE_ID INT);



INSERT INTO ZBOZI (ID, NAZEV, KATEGORIE_ID)
values
(1,'Masne vyrobky', NULL)
,(2,'Mlecne vyrobky', NULL)
,(3,'Jogurty', 2)
,(4,'Syry', 2)
,(5,'Sunky', 1)
,(6,'Salamy', 1)
,(7,'Mleko', 2)
,(8,'Polotucne mleko', 7)
,(9,'Plnotucne mleko', 7)
,(10,'Emental', 4)
,(11,'Gouda', 4)
,(12,'Sunka od kosti', 5)
,(13,'Lovecky salam', 6);





















----------------------------------------------------------------------------------------------------------------------------------
--CAST 16;
CO PO CZECHITAS
- co se dal ucit?
    - RECURSIVE CTE << PYTHON
    - NERELACNI FORMATY: XML, JSON
    - USER DEFINED FUNCTIONS
    - STORED PROCEDURES
    - PROGRAMOVANI V SQL
    - ML, AI
- jak vypada prace Data analysty?
- jake tooly se realne pouzivaji?
- kde hledat odpovedi?
- jak se dal rozvijet?
- kde hledat praci?
