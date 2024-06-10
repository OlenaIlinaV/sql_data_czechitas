---------------------------------------------------------                        
-- FUNKCE
---------------------------------------------------------
--- Ve světě databází jsou funkce programovatelné části kódu, které provádějí určité operace nebo výpočty nad daty v databázi.
--- Funkce jsou často používány pro transformaci dat, výpočty a zpracování dat
--- Funkce jako nadstavba (každá SQL flavor se může různit) -> dokumentace
------ Některé databázové systémy mohou nabízet rozšíření nebo vlastní funkce, které nejsou součástí standardního SQL a jsou specifické pro daný systém


---- jak zjistit datovy typ?




---------------------------------------------------------                        
-- STRING FUNCTIONS
---------------------------------------------------------
-- Manipulace s textem

/*
SPLIT
LENGTH, LEN
REPLACE
SUBSTRING
LEFT
RIGHT
LOWER, UPPER

*/

-- SPLIT
SELECT SPLIT('127.0.0.1', '.') 
--       ,SPLIT_PART('127.0.0.1', '.',2)
;

SELECT SPLIT_PART('127.0.0.1', '.',2)
;



SELECT
    city
    ,SPLIT(city, ' ')
    ,ARRAY_SIZE(SPLIT(city, ' '))
    ,ARRAY_SIZE(SPLIT(city,' '))-1
    ,SPLIT(city, ' ')[ARRAY_SIZE(SPLIT(city,' '))-1]::STRING
FROM teror; -- vybere vsechny mesta a rozdeli je podle poctu slov 




-- UKOLY ----------------------------------------------------------

-- Vypiste vsechny utoky, ktere maji trislovne a vice slovne nazvy mest (city).

------------------------------------------------------------------

SELECT CITY,
FROM TEROR
WHERE ARRAY_SIZE(SPLIT(CITY, ' '))>2
;


------------------------------------------------------------



-- LENGTH & REPLACE
SELECT LENGTH('12345'); -- textova hodnota

SELECT LENGTH(12345); -- ciselna hodnota

SELECT LENGTH('dobry den'); -- mezera je taky znak
//SELECT LEN('dobry den');


SELECT city
       ,REPLACE(city,' ','-')
FROM teror;



-- SUBSTRING & LOWER & UPPER
SELECT city 
       ,SUBSTRING(city,2,4) AS prvni_pismeno
//       ,SUBSTR(city,1,1) AS taky_prvni_pismeno 
FROM teror; -- vybere mesto a jeho prvni pismeno



-- SUBSTRING & LOWER & UPPER
SELECT city 
,SUBSTRING(city,2,4) AS prvni_pismeno
//,SUBSTRING(city,1,1) || SUBSTRING(city,2) -- SVISLÍTKO NEBOLI ROUŘÍTKO!
,LOWER(prvni_pismeno) || SUBSTRING(UPPER(city),2)
FROM teror; -- vybere mesto a jeho prvni pismeno

-- LEFT
SELECT city 
       ,LEFT(city,1) AS prvni_pismeno
FROM teror; -- vybere mesto a jeho prvni pismeno

-- RIGHT & UPPER
SELECT city, 
       UPPER(RIGHT(city,3)) AS posledni_tri_pismena 
FROM teror; -- vybere mesto a jeho posledni tri pismena v UPPERCASE

-- BONUS: CHARINDEX & POSITION
/*
SELECT 
    country_txt
    ,CHARINDEX('o',country_txt)
    ,POSITION('o',country_txt)
    ,POSITION('o' IN country_txt)
FROM teror;
*/
-- DALSI ZAJIMAVE FUNKCE: 
---- TRIM
---- TRANSLATE
/*
SELECT TRANSLATE(city,'o','Ö')
FROM teror;
*/

---------------------------------------------------------                        
-- MATH FUNCTIONS
---------------------------------------------------------
/*
HAVERSINE
ROUND
FLOOR
CEIL
*/

SELECT 
     latitude     --zeměpisná šířka
    ,longitude    --zeměpisná délka
FROM teror;

-- HAVERSINE
----HAVERSINE( lat1, lon1, lat2, lon2 )
SELECT 
     gname --název teroristicke skupiny
    ,city 
    ,iyear
    ,nkill
//    ,latitude 
//    ,longitude
    ,HAVERSINE(50.0833472, 14.4252625, latitude, longitude) AS vzdalenost_od_czechitas -- v km
FROM teror 
WHERE vzdalenost_od_czechitas < 100 -- novy sloupec muzeme pouzit v podmince
ORDER BY nkill DESC;









-- co jednotlive funkce delaji?
SELECT 
     ROUND(1.5)
    ,CEIL(1.5)
    ,FLOOR(1.5)
    ,TRUNC(1.5) --TRUNCATE
       
    ,ROUND(1.1)
    ,CEIL(1.1) 
    ,FLOOR(1.1)
    ,TRUNC(1.1)
;
SELECT 
     ROUND(-1.5)
    ,CEIL(-1.5)
    ,FLOOR(-1.5)
    ,TRUNC(-1.5)
       
    ,ROUND(-1.1)
    ,CEIL(-1.1) 
    ,FLOOR(-1.1)
    ,TRUNC(-1.1)
;



-- UKOLY ----------------------------------------------------------

-- Zaokrouhlete cislo 1574.14676767676 na dve desetinna mista (два знаки після коми)(pokud si nevite rady -> dokumentace). Použijte funkce ROUND, CEIL, FLOOR, TRUNC.

SELECT 
    TRUNC (1574.14676767676,2)
    ,ROUND(1574.14676767676,2)
    ,CEIL(1574.14676767676,2)
    ,FLOOR(1574.14676767676,2)
;


------------------------------------------------------------------



-- Další funkce, o kterých je dobré vědět, že existují:
-- ABS()
-- POWER(), SQRT()
-- LOG()
-- RAND()
-- SIN(), COS(), TAN(),

-- Pokud vás víc zajímají -> dokumentace ;-)






---------------------------------------------------------                        
-- DATE FUNCTION
---------------------------------------------------------
--  Manipulace s daty a časem
/*
TO_DATE
DATE_FROM_PARTS
DATEADD
DATEDIFF
EXTRACT
*/


-- Co je snowflake datum?

/*

1. '2021-23-06'

2. '2020/03/05'

3. '2018-05-03'

4. '1.3.2019'


SELECT CAST('' AS DATE);
SELECT ''::DATE;

*/


-- Co s tim, kdyz to snowflake nepozna?
-- https://docs.snowflake.com/en/sql-reference/functions-conversion#date-and-time-formats-in-conversion-functions




-- TO_DATE
1. '2021-23-06'
SELECT TO_DATE('2021-23-06','YYYY-DD-MM');

-- UKOLY ----------------------------------------------------------

-- Jak bude vypadat funkce pro dalsi data?

2. '2020/03/05'
SELECT TO_DATE('2020/03/05','YYYY/DD/MM');

3. '2018-05-03'
SELECT TO_DATE('2018-05-03','YYYY-MM-DD');

4. '1.3.2019'
SELECT TO_DATE('1.3.2019','DD.MM.YYYY');



------------------------------------------------------------------





-- DATE_FROM_PARTS
SELECT 
    DATE_FROM_PARTS(iyear, imonth, iday)
    ,idate
--  ,*
FROM teror 
LIMIT 100;



-- DATEADD
SELECT DATE_FROM_PARTS(iyear, imonth, iday) AS datum
      ,DATEADD(year,2, datum) as budoucnost        
      ,DATEADD(year,-2, datum) as minulost
      ,DATEADD(month,-2, datum)
FROM teror
//WHERE datum > DATEADD(year, -4, '2020-03-12')
//WHERE DATEADD(year, 2, datum) = DATE_FROM_PARTS(2016, 1, 1)
WHERE DATEADD(year, 2, datum) = '2016-01-01' // также як написати budoucnost = '2016-01-01'
;
-- https://docs.snowflake.com/en/sql-reference/functions-date-time.html#label-supported-date-time-parts

SELECT CURRENT_DATE();

SELECT CURRENT_TIMESTAMP();


-- DATEDIFF

SELECT DATEDIFF(month,'2024-03-18',CURRENT_DATE());

SELECT DATEDIFF(day,'2024-03-18',CURRENT_DATE());


SELECT 
    DATE_FROM_PARTS(iyear, imonth, iday) AS datum
--  ,DATE_FROM_PARTS(2015,1,1)
    ,DATEDIFF(year,datum, DATE_FROM_PARTS(2015,1,1))
FROM teror
WHERE DATEDIFF(year,datum, DATE_FROM_PARTS(2015,1,1)) = -2
;



-- EXTRACT & DATE_PART
SELECT 
     idate AS datum 
    ,EXTRACT(YEAR FROM datum) AS rok --MONTH,DAY,WEEK,HOUR,QUARTER,MINUTE,SECOND
    ,YEAR(datum)
    ,MONTH(datum)
    ,DAY(datum)
//    ,DATE_PART(year,datum)
FROM teror;

-- Další zajímavé funkce s datumy:

-- LAST_DAY(): Vrátí poslední den v měsíci pro zadané datum.
-- DATE_TRUNC(): Zkrátí datum na určitý časový úsek, například den, měsíc nebo rok.

-- UKOLY KODIM.CZ ----------------------------------------------------------

// 2.5 // Z IYEAR, IMONTH a IDAY vytvořte sloupeček datum a vypište tohle datum a pak datum o tři měsíce později a klidně i o tři dny a tři měsíce.                        



 -------------------------------------------------------------------------------

---------------------------------------------------------
-- LIKE, ILIKE
---------------------------------------------------------
/*
% - 0 az N znaku
_ - jeden znak
*/

-- hledame Bombing/Explosion
SELECT DISTINCT attacktype1_txt
FROM teror 
//WHERE attacktype1_txt LIKE 'bomb%' -- nenajde nic
//WHERE attacktype1_txt LIKE 'Bomb%' -- najde Bombing/Explosion
//WHERE attacktype1_txt ILIKE 'bomb%' -- najde Bombing/Explosion
//WHERE LOWER(attacktype1_txt) LIKE 'bomb%' -- najde Bombing/Explosion
//WHERE attacktype1_txt LIKE '_omb%' -- najde Bombing/Explosion
;


SELECT DISTINCT region_txt
FROM teror 
WHERE region_txt ILIKE '%america%'; -- vybere unikatni nazvy regionu, ktere obsahuji america (kdekoliv a v jakekoliv velikosti)

SELECT DISTINCT gname
FROM teror 
WHERE gname ILIKE 'a%'; -- vybere unikatni nazvy organizaci, ktere zacinaji na a


SELECT DISTINCT gname 
FROM teror 
WHERE gname ILIKE '_a%'; -- vybere unikatni nazvy organizaci, ktere maji v nazvu druhe pismeno a


SELECT city 
FROM teror 
WHERE city like '% % %'; -- vybere vsechny mesta, ktera maji vice jak 2 slova

/*
SELECT 'ahoj
dneska 
je 
krásně' AS TEXTIK
WHERE TEXTIK not ILIKE '%\n%'
;
*/
-- UKOLY KODIM.CZ ----------------------------------------------------------

// 2.4 // Vypiš všechny organizace, které na jakémkoliv (будь який) místě v názvu obsahují výraz „anti“ a výraz „extremists“

SELECT DISTINCT gname
FROM TEROR
WHERE gname ILIKE '%anti%' AND gname ILIKE '%extremists%'
;


-------------------------------------------------------------------------------











---------------------------------------------------------     
-- IN, NOT IN
---------------------------------------------------------                     

-- IN, NOT IN

SELECT DISTINCT country_txt
FROM teror
WHERE country_txt <> 'India' AND country_txt <> 'Somalia';

SELECT DISTINCT country_txt
FROM teror
// WHERE country_txt NOT IN ('India','Somalia')
WHERE country_txt IN ('India','Somalia') -- jaka je alternativa?
;

---------------------------------------------------------                        
-- BETWEEN
---------------------------------------------------------    

-- cisla

SELECT * 
FROM teror
WHERE nkillter >= 40 AND nkillter <= 60;


SELECT DISTINCT country_txt
FROM teror
WHERE nkillter BETWEEN 40 AND 60; -- vcetne


SELECT DISTINCT iyear
FROM teror 
WHERE iyear BETWEEN 2014 AND 2016; -- vybere unikatni roky mezi roky 2014 a 2016 (vcetne krajnich hodnot)


-- pismena
SELECT city, 
       SUBSTRING(city,1,1) AS prvni_pismeno 
FROM teror 
WHERE prvni_pismeno BETWEEN 'A' AND 'C'; -- vybere mesta, ktera zacinaji na A, B nebo C

-- funguje i na datum

SELECT *
FROM teror
WHERE DATE_FROM_PARTS(iyear, imonth, iday) BETWEEN '2017-11-01' AND '2017-12-01';

------------------------------------------------
-- IS NULL, IS NOT NULL
------------------------------------------------
SELECT weaptype1_txt,
       nkillter 
FROM teror 
WHERE nkillter IS NOT NULL
ORDER BY nkillter DESC;


-- pozor, nekdy null hodnoty nejsou definovane, naucte se rozeznavat NULL hodnotu









-- UKOLY KODIM.CZ ----------------------------------------------------------

// 2.3 // Zobraz sloupečky IYEAR, IMONTH, IDAY, GNAME, CITY, ATTACKTYPE1_TXT, TARGTYPE1_TXT, WEAPTYPE1_TXT, WEAPDETAIL, NKILL, NWOUND a vyber jen útoky, 
//které se staly v Czech Republic v letech 2015, 2016 a 2017. 
-- Všechna data seřaď chronologicky sestupně


SELECT IYEAR, IMONTH, IDAY, GNAME, CITY, ATTACKTYPE1_TXT, TARGTYPE1_TXT, WEAPTYPE1_TXT, WEAPDETAIL, NKILL, NWOUND
FROM TEROR
WHERE 1=1
    AND COUNTRY_TXT ILIKE 'czech%'
    //AND NWOUND IS NOT NULL,
    //AND (IYEAR BETWEEN 2015 AND 2017)
    AND IYEAR IN (2015, 2016, 2017)
ORDER BY IYEAR
;



-------------------------------------------------------------------------------


---------------------------------------------------------                        
-- IFNULL
---------------------------------------------------------       

-- IFNULL
SELECT
    nkill
    ,IFNULL(nkill, -99) AS nkill
    ,IFNULL(nkill, 0) AS nkill
FROM teror;

SELECT AVG(nkill)
    ,AVG(IFNULL(nkill,-99))
    ,AVG(IFNULL(nkill,0))
FROM teror;

SELECT AVG(nkill)
    ,AVG(IFNULL(nkill,-99))
    ,AVG(IFNULL(nkill,0))
FROM teror
WHERE nkill IS NOT NULL
//WHERE nkill IS NULL
;

-- Podobná je také funkce COALESCE()

---------------------------------------------------------   
-- CASE WHEN
---------------------------------------------------------   
-- Umožňuje provádět různé akce nebo vrátit různé hodnoty na základě splnění určitých podmínek.

SELECT nkill,
       CASE 
        WHEN NKILL IS NULL THEN 0 
        ELSE NKILL
        END AS nkill_upraveno
      // ,IFNULL(nkill,0) AS nkill_upraveno2
FROM TEROR;


SELECT nkill,
       CASE
         WHEN nkill IS NULL THEN 'unknown'
         WHEN nkill > 100 THEN 'over 100 killed'
         WHEN nkill > 0 THEN '1-100 killed'
         WHEN nkill = 0 THEN 'none killed'
         ELSE '00-ERROR'
       END AS upraveny_nkill
FROM teror
ORDER BY NKILL DESC NULLS LAST
; 


SELECT DISTINCT region_txt
FROM teror;

SELECT DISTINCT region_txt,
       CASE
         WHEN region_txt ILIKE '%america%' THEN 'Amerika'
         WHEN region_txt ILIKE '%africa%' THEN 'Afrika'
         WHEN region_txt ILIKE '%asia%' THEN 'Asie'
         WHEN region_txt ILIKE '%europ%' THEN 'Europa'
         ELSE region_txt
       END AS continent
FROM teror; -- vytvorime sloupec kontinent podle regionu


-- Podobná funkce IFF()




-- UKOLY KODIM.CZ ----------------------------------------------------------

                        
// 2.6 // Vypiš všechny druhy útoků ATTACKTYPE1_TXT

SELECT DISTINCT ATTACKTYPE1_TXT
FROM TEROR
;
                        
// 2.7 // Vypiš všechny útoky v Německu v roce 2015, vypiš sloupečky IYEAR, IMONTH, IDAY, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND. Ve sloupečku COUNTRY_TXT bude všude hodnota ‘Německo’

SELECT 
    IYEAR
    ,IMONTH
    ,IDAY
    ,COUNTRY_TXT
    ,REGION_TXT
    ,PROVSTATE 
    ,CITY
    ,NKILL
    ,NKILLTER
    ,NWOUND
FROM TEROR
WHERE 1=1
    AND IYEAR = 2015
    AND COUNTRY_TXT = 'Germany'
ORDER BY COUNTRY_TXT
;
    

// 2.8 // Kolik událostí se stalo ve třetím a čtvrtém měsíci a počet mrtvých teroristů není NULL?
                    
// 2.9 // Vypiš první 3 města seřazena abecedně kde bylo zabito 30 až 100 teroristů nebo zabito 500 až 1000 lidí. Vypiš i sloupečky nkillter a nkill.

// 2.10 // Vypiš všechny útoky z roku 2014, ke kterým se přihlásil Islámský stát ('Islamic State of Iraq and the Levant (ISIL)').
/*
Vypiš sloupečky IYEAR, IMONTH, IDAY, GNAME, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND 
a na konec přidej sloupeček EventImpact, který bude obsahovat:

'Massacre' pro útoky s víc než 1000 obětí
'Bloodbath' pro útoky s 501 - 1000 obětmi
'Carnage' pro ůtoky s 251 - 500 obětmi
'Blodshed' pro útoky se 100 - 250 obětmi
'Slaugter' pro útoky s 1 - 100 obětmi
a ‘N/A’ pro všechny ostatní útoky.
*/

                        
// 2.11 // Vypiš všechny útoky, které se staly v Německu, Rakousku, Švýcarsku, Francii a Itálii, s alespoň jednou mrtvou osobou. 
/*U Německa, Rakouska, Švýcarska nahraď region_txt za ‘DACH’, u zbytku nech původní region. Vypiš sloupečky IYEAR, IMONTH, IDAY, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND. Výstup seřaď podle počtu raněných sestupně.*/



                        
// 2.12 // Vypiš COUNTRY_TXT, CITY, NWOUND a 
/* 
přidej sloupeček vzdalenost_od_albertova obsahující vzdálenost místa útoku z pražské části Albertov v km 
a sloupeček kategorie obsahující ‘Blízko’ pro útoky bližší 2000 km a ‘Daleko’ pro ostatní. 
Vypiš jen útoky s víc než stovkou raněných a seřad je podle vzdálenosti od Albertova.

-------------------------------------------------------------------------------
ÚKOL Z LEKCE 3
-------------------------------------------------------------------------------

// 3.7 // Vypište celkový počet útoků podle druhu zbraně weaptype1_txt, počet mrtvých, mrtvých teroristů, průměrný počet mrtvých, průměrný počet mrtvých teroristů, kolik mrtvých obětí připadá na jednoho mrtvého teroristu a kolik zraněných...

*/