-----------------------------------------------------------------------------------------
 LEKCE 2: Datové typy a jejich převody, Podmínky a základní operátory, Agregační funkce
-----------------------------------------------------------------------------------------


SELECT
FROM
WHERE
ORDER BY
LIMIT
;


SELECT *
FROM TEROR
WHERE REGION_TXT = 'South America'
ORDER BY NWOUND DESC NULLS LAST
LIMIT 700
;


---------------------------------------------------------
-- CAST - PŘETYPOVÁNÍ DATOVÉHO TYPU
---------------------------------------------------------

SELECT
    *
FROM TEROR
LIMIT 100;


-- popise tabulku - datove typy

DESC TABLE TEROR; -- sloupec type

SHOW COLUMNS IN TABLE TEROR; -- sloupec data_type





-- Přetypování datového typu, použijeme funkci CAST

-- SYNTAXE, dvě možné, dělají to samé:
-- CAST (který_sloupec AS cílový_datový_typ)
-- který_sloupec::cílový_datový_typ







-- Přetypování datového typu - číslo


SELECT 1 as Cislo;

SELECT '1' as Text;  

SELECT CAST('1' AS INT);

SELECT CAST('tohle neni cislo' AS INT);


-- Jiný zápis pomocí dvou dvojteček (::)


SELECT '1'::INT;

SELECT 'tohle neni cislo'::INT;


-- Chceme desetinné číslo

SELECT '1'::FLOAT;



-- Přetypování datového typu -  textovy řetězec

SELECT 1::VARCHAR ; -- STRING


-- Přetypování datového typu - datum

SELECT '2021-03-13'::DATE; -- YYYY-MM-DD defaultně

SELECT '13.3.2021'::DATE;

SELECT '13/3/2021'::DATE;

SELECT '3/13/2021'::DATE;

SELECT '2021-03-13'::DATETIME;
SELECT CAST('2021-03-13' AS DATETIME)


-- Cvičení: Z tabulky TEROR vyberte sloupec COUNTRY a přetypujte ho na textový řetězec.
SELECT COUNTRY::STRING
//SELECT CAST(COUNTRY AS STRING) - два способи як перевести в необхідний тип дат
FROM TEROR;

-- Následně vyberte sloupec IDATE a přetypujte ho na textový řetězec.

SELECT CAST(COUNTRY AS STRING), IDATE::STRING
FROM TEROR;



SELECT COUNTRY::VARCHAR, IDATE::VARCHAR
FROM TEROR
;
-- nebo stejně bude fungovat CAST(COUNTRY AS VARCHAR)


---------------------------------------------------------
-- PODMÍNKY: Zakladní operátory
---------------------------------------------------------


a = b
a is equal to b.


a <> b
a != b
a is not equal to b.
-- Oba operátory fungují stejně, <> je univerzálnější

a > b
a is greater than b.

a >= b
a is greater than or equal to b.

a < b
a is less than b.

a <= b
a is less than or equal to b.


-- Příklady TEXT

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE CITY = 'Prague';

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE CITY <> 'Prague'; */ також можемо використати != /*


-- Příklady čísla

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL = 0;

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL < 1;

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL >= 50;


-- Testujeme podmínky za pomoci jednoduchého SELECTu

SELECT 'Podmínka platí' (platit - діяти)
WHERE 1=1
;

-- Otestujte, jestli '2' = 2
SELECT 'Podmínka platí'
WHERE '2' = 2
;

-- Otestujte, jestli 1 + 4 - 2 / 2 je menší než 2 * 2
SELECT 'Podmínka platí' 
WHERE (1 + 4 - 2 / 2)<(2 * 2)
;

-- Otestujte, jestli 5 je menší nebo rovno 10
SELECT 'Podmínka platí'
WHERE 5<=10
;

-- Otestujte, jestli 500 (přecastováno na text) není rovno 10 (přecastováno na text)
SELECT 'Podmínka platí'
WHERE '500'<>'10'
;

SELECT 'Podmínka platí'
WHERE CAST(500 AS VARCHAR) <>'10'
;


-- UKOLY
// A Úkol 2.1  // Vyber z tabulky TEROR útoky, kde zemřel alespoň jeden terorista (NKILLTER). (jeden nebo více teroristů)      

// útok - напад

SELECT *
FROM TEROR
WHERE NKILLTER >=1
;

// B Úkol 2.2 // Zobraz jen sloupečky GNAME, COUNTRY_TXT, NKILL a všechny řádky (seřazené podle počtu mrtvých sestupně), na kterých je víc než 340 mrtvých (počet mrtvých je ve sloupci NKILL), sloupečky přejmenuj na ORGANIZACE, ZEME, POCET_MRTVYCH.

SELECT GNAME AS ORGANIZACE, COUNTRY_TXT AS ZEME, NKILL AS POCET_MRTVYCH
FROM TEROR
WHERE POCET_MRTVYCH > 340
ORDER BY POCET_MRTVYCH DESC
;




--A
SELECT *
FROM TEROR
WHERE NKILLTER > 0
;

--B
SELECT
    GNAME AS ORGANIZACE
  , COUNTRY_TXT AS ZEME
  , NKILL AS POCET_MRTVYCH
FROM TEROR
WHERE NKILL > 340
ORDER BY POCET_MRTVYCH DESC
;

---------------------------------------------------------
-- Porovnáváme více hodnot - čísla a textové řetězce

 IYEAR IN (1990, 1998, 1999)
 CITY IN ('Prague', 'Brno', 'Bratislava')
 ;

-- Úkol: Vyberte sloupce IYEAR a EVENTID z tabulky TEROR pro záznamy, které se staly v letech 2016 a 2017.


SELECT *
FROM TEROR
WHERE CITY IN ('Prague', 'Brno', 'Bratislava')
;


SELECT IYEAR, EVENTID
FROM TEROR
WHERE IYEAR IN ('2016','2017')
;


SELECT IYEAR, EVENTID
FROM TEROR
WHERE IYEAR IN (2016, 2017)
;

---------------------------------------------------------
-- AND, OR a závorky
---------------------------------------------------------

SELECT 'Podmínka platí'
WHERE 1=1 AND 2=2
;

SELECT 'Podmínka platí'
WHERE 1=1 OR 2=2
;


SELECT 'Podmínka platí'
WHERE 1=1 AND 3=2 // - не працює
;

-- Doplň podmínku: Obojí je pravda: 5 je menší nebo rovno 6 a 3*10 je 30.
SELECT 'Podmínka platí'
WHERE 5<=6 AND 3*10 = 30
;


-- Doplň podmínku: Buď platí, že 5 je menší než 4 nebo platí, že je 5 větší než 5. (Nebo platí obojí.)
SELECT 'Podmínka platí'
WHERE 5<4 OR 5>5
;




-- Úkol: Vyber z tabulky TEROR útoky v Německu (Germany), kde zemřel alespoň jeden TERORista (NKILLter).  


SELECT *
FROM TEROR
WHERE NKILLter >=1 AND COUNTRY_TXT = 'Germany'
;


SELECT *
FROM TEROR
WHERE 1=1
    AND NKILLTER > 0
    AND COUNTRY_TXT = 'Germany'
;


-- Pojďme se podívat na to, jak fungují závorky:

SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND CITY='Delina' OR CITY='Bara';

SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND CITY='Prague' OR CITY='Bara';

SELECT DISTINCT COUNTRY_TXT, CITY   
FROM TEROR 
WHERE COUNTRY_TXT = 'India' AND CITY='Bara' OR CITY='Delina';

SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND (CITY='Delina' OR CITY='Bara');


-- Příklad na podmínky a zároveň opakování funkce COUNT()
-- Spočítej počet záznamů v tabulce TEROR, 
-- kde bylo zraněno více než 1000 lidí nebo zabito více než 10 teroristů (v libovolném roce) nebo
-- kde bylo buď zabito více než 100 lidí a útok se stal v roce 2016 nebo
-- kde bylo zabito více nebo rovno než 110 lidí a útok se stal v roce 2017 


SELECT NKILL,NKILLTER,IYEAR
FROM TEROR
WHERE 1=1
    AND (NWOUND > 1000 OR NKILLTER > 10) - тут треба поставити дужки бо OR має нижче пріоритет ніж AND
    OR NKILL > 100 AND IYEAR = 2016 - тут вже можемо не писати дужки
    OR NKILL >= 110 AND IYEAR = 2017 - тут вже можемо не писати дужки
;

---------------------------------------------------------
-- AGREGAČNÍ FUNKCE
---------------------------------------------------------

---------------------------------------------------------                        
-- COUNT() - počet
---------------------------------------------------------                        

SELECT 
    COUNT(*) -- as pocet
FROM TEROR;

SELECT 
    COUNT(EVENTID)
FROM TEROR;

-- COUNT(DISTINCT x)

SELECT 
    COUNT(DISTINCT COUNTRY_TXT)
FROM TEROR;

---------------------------------------------------------                        
-- SUM() - součet
---------------------------------------------------------

SELECT 
    SUM(NKILL) AS pocet_mrtvych
FROM TEROR;

---------------------------------------------------------                        
-- AVG() - průměr
---------------------------------------------------------  

SELECT 
    AVG(NKILL) AS prumerny_pocet_mrtvych 
FROM TEROR;

---------------------------------------------------------                        
-- MAX() - maximální hodnota
---------------------------------------------------------                         

-- vratí jedno číslo
SELECT 
    MAX(NKILL) AS max_pocet_mrtvych
FROM TEROR;


-- stejný vysledek jinou cestou
SELECT 
    NKILL AS max_pocet_mrtvych
    , *
FROM TEROR 
WHERE NKILL IS NOT NULL 
ORDER BY NKILL DESC 
LIMIT 1; 

---------------------------------------------------------                        
-- MIN() - minimální hodnota
---------------------------------------------------------                         
                          
SELECT 
    MIN(NKILL) AS min_pocet_mrtvych
FROM TEROR
;


-- Cvičení: Napiš dotaz, který vrátí z Tabulky TEROR:
  -- Počet(кількість) různých měst ve sloupci CITY
  -- Minimální (nejmenší) datum ve sloupci IDATE
  -- Maximální počet mrtvých teroristů na jeden útok ve sloupci NKILLTER
  -- Průměrný počet zraněných na útok ze sloupce NWOUND
  -- Celkový počet zabitých osob v tabulce - sloupec NKILL


SELECT
      COUNT(DISTINCT CITY)
    , MIN(IDATE)
    , MAX(NKILLTER)
    , AVG(NWOUND)
    , SUM(NKILL)
FROM TEROR
;

---------------------------------------------------------                        
-- GROUP BY - vytváření skupin
---------------------------------------------------------                         

-- Seznam všech zemí
SELECT DISTINCT COUNTRY_TXT
FROM TEROR
;

-- Všechny záznamy rozskupinkovány dle zemí
SELECT COUNTRY_TXT
FROM TEROR
GROUP BY COUNTRY_TXT
;

-- Kolik je záznamů v každé skupině?
SELECT COUNTRY_TXT, COUNT(*)
FROM TEROR
GROUP BY COUNTRY_TXT
;

-- Cvičení: Vypiš všechny regiony (REGION_TXT) a spočítej, kolik bylo v každém regionu útoků.

SELECT REGION_TXT AS REGION, COUNT(*) AS COUNT
FROM TEROR
GROUP BY REGION_TXT
;



-- Počet zabitych dle GNAME (TERORisticke organizace)

SELECT GNAME, -- skupina
       SUM(NKILL) -- agregace
FROM TEROR
GROUP BY GNAME;

-- podle GNAME a COUNTRY_TXT

SELECT GNAME, -- skupina
       COUNTRY_TXT, -- skupina 
       SUM(NKILL), -- agregace
       COUNT(NKILL) -- agregace
FROM TEROR
GROUP BY GNAME, COUNTRY_TXT
ORDER BY GNAME DESC, GNAME ASC NULLS FIRST
;

-- UKOLY z KODIM.CZ ----------------------------------------------------------

// A // Zjisti počet obětí(жертв) a raněných po letech a měsících

// B // Zjisti počet obětí a raněných v západní Evropě po letech a měsících

// C // Zjisti počet útoků po zemích. Seřaď je podle počtu útoků(напад)  sestupně

// D // Zjisti počet útoků po zemích a letech, seřaď je podle počtu útoků sestupně

// E // Kolik která organizace spáchala útoků zápalnými zbraněmi (weaptype1_txt = 'Incendiary'), 
    --  kolik při nich celkem zabila obětí, kolik zemřelo TERORistů a kolik lidí bylo zraněno (NKILL, NKILLter, nwound)

A
SELECT 
    IYEAR AS YEAR,
    IMONTH AS MONTH,
    SUM(NKILL) AS KILL_PEOPLE,
    SUM(NWOUND) AS WOUND_PEOPLE
FROM TEROR
GROUP BY IYEAR, IMONTH
ORDER BY IYEAR, IMONTH
;

B
SELECT 
    IYEAR AS YEAR,
    IMONTH AS MONTH,
    SUM(NKILL) AS KILL_PEOPLE,
    SUM(NWOUND) AS WOUND_PEOPLE
FROM TEROR
WHERE REGION_TXT = 'Western Europe'
GROUP BY IYEAR, IMONTH
ORDER BY IYEAR, IMONTH
;

C
SELECT 
    COUNTRY_TXT,
    SUM(NKILL + NWOUND)
FROM TEROR
GROUP BY COUNTRY_TXT
ORDER BY SUM(NKILL + NWOUND) ASC
;

SELECT COUNTRY_TXT,
    COUNT(*) AS POCET
FROM TEROR
GROUP BY COUNTRY_TXT
ORDER BY POCET DESC;


D
SELECT

Вчитель

--A
SELECT IYEAR -- vybíráme rok události
    , IMONTH -- vybíráme měsíc události
    , SUM(NKILL) AS KILLED -- sumu počtu mrtvých (NKILL) označujeme jako "KILLED"
    , SUM(NWOUND) AS WOUNDED -- sčítáme počet zraněných a celkový součet označujeme jako "WOUNDED"
FROM TEROR -- vybíráme data z tabulky TEROR
GROUP BY IYEAR, IMONTH -- seskupujeme podle roku a měsíce
ORDER BY IYEAR, IMONTH; -- řadíme výsledky vzestupně podle roku a měsíce

--B
SELECT IYEAR
    , IMONTH
    , SUM(NKILL) AS KILLED
    , SUM(NWOUND) AS WOUNDED
FROM TEROR
WHERE REGION_TXT = 'Western Europe'
GROUP BY IYEAR, IMONTH
ORDER BY IYEAR, IMONTH;

--C
-- Vrací počet útoků pro každou zemi z tabulky TEROR
SELECT COUNTRY_TXT,
    COUNT(*)
FROM TEROR
GROUP BY 1
ORDER BY COUNT(*) DESC;

--D
SELECT COUNTRY_TXT,
    IYEAR,
    COUNT(*)
FROM TEROR
GROUP BY COUNTRY_TXT,
    IYEAR
ORDER BY COUNT(*) DESC;

--E
SELECT GNAME,
    COUNT(EVENTID),
    -- celkový počet útoků
    SUM(NKILL),
    -- součet všech mrtvých
    SUM(NKILLTER),
    -- součet mrtvých teroristů
    SUM(NWOUND) -- počet raněných
FROM TEROR -- Výběr útoků s použitím zápalných zbraní (weaptype1_txt = 'Incendiary')
WHERE WEAPTYPE1_TXT = 'Incendiary' -- Seskupení výsledků podle názvu organizace
GROUP BY GNAME;

------------------------------------------------------------------------------
---------------------------------------------------------                        
-- HAVING - možnost zapsat podmínky ke skupinám (GROUP BY)
---------------------------------------------------------                         

-- SQL query pořadí:

SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT


--- pocet mrtvych podle TERORisticke organizace kde je pocet obeti vetsi nez nula
SELECT 
      GNAME
    , SUM(NKILL) AS pocet_mrtvych 
    , COUNT(EVENTID) AS pocet_utoku
FROM TEROR 
GROUP BY GNAME 
HAVING SUM(NKILL) > 0 
ORDER BY pocet_mrtvych DESC; 

-- vs jiný případ, kde pracujeme pouze s útoky, které měly mrtvé
SELECT 
      GNAME
    , SUM(NKILL) AS pocet_mrtvych 
    , COUNT(EVENTID) AS pocet_utoku
FROM TEROR 
WHERE (NKILL) > 0
GROUP BY GNAME 
ORDER BY pocet_mrtvych DESC; 

--- pocet mrtvych podle TERORisticke organizace kde je pocet obeti a pocet mrtvych TERORistu vetsi nez nula
SELECT 
    GNAME
    , SUM(NKILL) AS pocet_mrtvych
    , SUM(NKILLter) AS pocet_mrtvych_TERORistu 
FROM TEROR 
GROUP BY GNAME 
HAVING SUM(NKILL) > 0 
   AND SUM(NKILLter) >= 1 
ORDER BY SUM(NKILL) DESC; 

-- UKOL KODIM.CZ ----------------------------------------------------------

// F // Stejné jako E, jen ve výsledném výpisu chceme jen organizace, které zápalnými útoky zabily 10 a více lidí.

-------------------------------------------------------------------------------


SELECT GNAME,
    COUNT(EVENTID),
    -- celkový počet útoků
    SUM(NKILL),
    -- součet všech mrtvých
    SUM(NKILLTER),
    -- součet mrtvých teroristů
    SUM(NWOUND) -- počet raněných
FROM TEROR -- Výběr útoků s použitím zápalných zbraní (weaptype1_txt = 'Incendiary')
WHERE WEAPTYPE1_TXT = 'Incendiary' -- Seskupení výsledků podle názvu organizace
GROUP BY GNAME
HAVING SUM(NKILL) <= 10 AND SUM(NKILL)<>0
;






--F
SELECT GNAME,
    COUNT(EVENTID) AS UTOKU,
    SUM(NKILL) AS MRTVI,
    SUM(NKILLTER) AS MRTVYCH_TERORISTU,
    SUM(NWOUND) AS RANENYCH
FROM TEROR
WHERE WEAPTYPE1_TXT = 'Incendiary'
GROUP BY GNAME
HAVING SUM(NKILL) > 10;
 