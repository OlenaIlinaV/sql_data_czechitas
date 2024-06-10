------------------------------------------------------------------------------------------------------------------
LEKCE: OPAKOVANI JOINU, VNORENY SELECT, CTE
-----------------------------------------------------------------------------------------------------------------
LEFT JOIN
INNER JOIN - nejčastější, pomáhá s performací/výkonem
RIGHT JOIN
FULL JOIN
FULL OUTER JOIN
;


SELECT *
FROM PACIENTI;

CREATE OR REPLACE TEMPORARY TABLE PACIENTI_2 ( 
  ID INT,
  JMENO VARCHAR(1000),
  DATUM_NAROZENI DATE,
  TELEFON INT,
  ADRESA VARCHAR(2000)
);

INSERT INTO PACIENTI_2 (ID, JMENO, DATUM_NAROZENI, TELEFON, ADRESA)
  VALUES 
(1,'František Vomáčka','1990-03-12',666777888,'K Říčce 7, 12345 Plzeň'),
(2,'Linda Lízátková','1967-10-12',777345678,'Svatoplukova 21, 12111 Praha - Nové Město'),
(3,'Magdaléna Hodná','1968-12-12',737983920,'Václavské náměstí 1, 100000 Praha'),
(4,'Jan Krátký','1970-03-03',777123456,'Londýnská 5, 10001 Praha'),
(5,'Emanuela Smutná','1981-04-23',606123456,'Italská 5, 10002 Praha')
;

SELECT *
FROM PACIENTI_2;


-- JAKOU MA PORADI DULEZITOST?
select *
from pacienti
left join pacienti_2 on pacienti.id = pacienti_2.id
 -- vsechny radky z PACIENTI a vlastne vsechny radkyy z PACIENTI 2
;

select *
from pacienti_2
left join pacienti on pacienti.id = pacienti_2.id
-- v tomto pripade se vlastne vytvor INNER JOIN i kdyz nechtene a to kvuli poradi tabulek
;

select *
from pacienti_2
inner join pacienti on pacienti.id = pacienti_2.id
-- stejny vysledek
;
-------------------------------------------------------------------------
PROTO JE FAJN SI UDELAT NEKDY I FULL OUTER JOIN-->;

CREATE OR REPLACE TEMPORARY TABLE PACIENTI_3 ( 
  ID INT,
  JMENO VARCHAR(1000),
  DATUM_NAROZENI DATE,
  TELEFON INT,
  ADRESA VARCHAR(2000)
);

INSERT INTO PACIENTI_3 (ID, JMENO, DATUM_NAROZENI, TELEFON, ADRESA)
  VALUES 
--(1,'František Vomáčka','1990-03-12',666777888,'K Říčce 7, 12345 Plzeň'),
(2,'Linda Lízátková','1967-10-12',777345678,'Svatoplukova 21, 12111 Praha - Nové Město'),
(3,'Magdaléna Hodná','1968-12-12',737983920,'Václavské náměstí 1, 100000 Praha'),
(4,'Jan Krátký','1970-03-03',777123456,'Londýnská 5, 10001 Praha'),
(5,'Emanuela Smutná','1981-04-23',606123456,'Italská 5, 10002 Praha')
;

SELECT *
FROM PACIENTI_3;

select *
from pacienti
full outer join pacienti_3 on pacienti.id = pacienti_3.id
where pacienti.id is null or  pacienti_3.id is null

;


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 1
LOGIKA pri vytvareni skriptu.
Pojdme si projit krok po kroku logiku, pri vytvareni skriptu.

Zjednodušený postup pro LEFT JOIN dvou tabulek bez dalších cavyků:

1) Zamyslím se, co má být výsledkem - Jaká má být granularita výsledné tabulky? Kolik řádků očekávám? (Pokud bych si představila obě celé tabulky jednu vedle druhé, jak by to vypadalo?)

2) Určím, která tabulka má stejnou granularitu jako očekávaný výsledek. Tuto tabulku dám za FROM. Bude to tedy má levá tabulka, ze které se použijí všechny řádky. (Příklad: Chci mít řádek pro každého pacienta. Má levá tabulka bude tabulka, která na každém řádku obsahuje pacienta - ideálně číselník pacientů.)

3) Určím tabulku, kterou chci spojit s levou tabulkou. Název této tabulky dám za LEFT JOIN. Bude to má pravá tabulka, ze které se některé řádky nemusí použít vůbec, některé se použijí jednou a některé vícekrát.

4) Určím klíč, přes který tabulky mohu spojit. Klasicky to bude primární klíč tabulky typu číselník, který je obsažen jako cizí klíč v tabulce typu faktová. Za LEFT JOIN tabulka napíšu ON klíč z jedné tabulky se rovná klíč z druhé tabulky.

POZOR - my si i můžeme "vytvořit/definovat" klíče nebo může existovat vícero klíčů AND

5) Finálně do selektu vypíšu sloupce, které chci použít. Pokud je stejný název sloupce v obou tabulkách, musím rozlišit, kterou tabulku mám na mysli.



---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 2
Příklady na zubařském datasetu. SAMOSTATNA PRACE -* POUZE PRVNI 3 PRIKLADY. AZ BUDE HOTOVO, TAK DOHROMADY

PACIENTI
NAVSTEVY
POJISTOVNY

1) NAVSTEVY - Pro každou návštěvu chceme zjistit zdravotní pojišťovnu (zajímají nás sloupce datum a kod).;
2) NAVSTEVY - Pro každou adresu pacienta chceme zjistit datum každé návštěvy (zajímají nás sloupce adresa a datum).;
3) PACIENTI - Pro každé telefonní číslo chceme zjistit datum poslední návštěvy (zajímají nás sloupce telefon a MAX(datum)).;
4) NAVSTEVY - Pro každou návštěvu chceme zjistit celkový počet návštěv za den (zajímá nás sloupec datum).;

SELECT datum, kod
FROM navstevy as n
LEFT JOIN pojistovny as p
ON n.pojistovna_id = p.id
;

SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name = table2.column_name;


--; řešení
--1) 
SELECT datum, kod
FROM navstevy
LEFT JOIN pojistovny ON navstevy.pojistovna_id = pojistovny.id
;

--2)
SELECT adresa, datum
FROM pacienti
LEFT JOIN navstevy ON pacienti.id = navstevy.pacient_id
;
-- Co by se stalo, kdyby nějaký pacient v tabulce pacienti neměl žádný záznam v tabulce navstevy?

--3)
SELECT telefon, MAX(datum)
FROM pacienti
LEFT JOIN navstevy ON pacienti.id = navstevy.pacient_id
GROUP BY telefon
;

--4) Pro každou návštěvu chceme zjistit celkový počet návštěv za den.;

navsteva ID | navsteva - popis          | datum             | pacient ID | celkovy pocet navstev za den
    1       | PreventivnÍ prohlídka...  | 2023-03-14 16:20  |   1        |      2
    2       | Trhání 8A                 | 2023-03-14 15:00  |   1        |      2
    3       | Instalace nové korunky... | 2023-03-15 16:20  |   2        |      1                                      
; 
SELECT *
FROM NAVSTEVY;
-- Musíme si data nejdříve předchroustat a pak až je zpracujeme.

-- Předchroustání dat:
-- Nejdřiv si zobrazíme všechny navstevy
;

-- Následně s touto informací budeme pracovat dále:
-- Uděláme LEFT JOIN na tabulku navstevy, propojíme přes den a tím zjistíme celkový počet návštěv za den

SELECT *
FROM NAVSTEVY
LEFT JOIN ??? ON NAVSTEVY.DEN Z NAVSTEV = POCET_NAVSTEV;

SELECT CAST(DATUM AS DATE) AS DATUM, COUNT(*) AS POCET_NAVSTEV
FROM NAVSTEVY
GROUP BY CAST(DATUM AS DATE);


-- Jenže jak využít předchroustaná data ve druhém SELECTu???
-- Máme tři možnosti: Vytvoření (dočasné) tabulky, CTE a subSELECT

JAKE MAME TRI MOZNOSTI A JAKE JSOU ROZDILY ?
VYHODY NEVYHODY NEBO SPIS KDY MUSIME A MUZEME TO POUZIT


-- 1. Vytvoření dočasné tabulky
;
CREATE OR REPLACE TABLE temp_celkovy_pocet_navstev_za_den AS
SELECT cast(datum as date) as den, COUNT(*) AS pocet_navstev_za_den 
FROM navstevy 
GROUP BY cast(datum as date)
;

SELECT * FROM temp_celkovy_pocet_navstev_za_den;

SELECT navstevy.*, cast(navstevy.datum as date) as den, pocet_navstev_za_den 
FROM navstevy
LEFT JOIN temp_celkovy_pocet_navstev_za_den ON cast(navstevy.datum as date)  = temp_celkovy_pocet_navstev_za_den.den

;

-- 2. CTE (common table expressions)

WITH cte_celkovy_pocet_navstev_za_den AS
       (SELECT cast(datum as date) as den, COUNT(*) AS pocet_navstev_za_den 
        FROM navstevy 
        GROUP BY cast(datum as date) 
       )

SELECT * 
FROM navstevy
LEFT JOIN cte_celkovy_pocet_navstev_za_den ON cast(navstevy.datum as date)  = cte_celkovy_pocet_navstev_za_den.den
;

-- 3. SubSELECT (vnořený SELECT)

SELECT * 
FROM navstevy
LEFT JOIN 
       (SELECT cast(datum as date) as den, COUNT(*) AS pocet_navstev_za_den 
        FROM navstevy 
        GROUP BY cast(datum as date) 
        ) tabulka ON cast(navstevy.datum as date)  =  tabulka.den

;



CAST 3
---------------------------------------------------------                        
-- VNORENY SELECT (nested query) / SUBSELECT / SUBQUERY
---------------------------------------------------------  
https://docs.snowflake.com/en/user-guide/querying-subqueries.html

Vnořený SELECT, subSELECT, subquery, nested query

K čemu se využívá:
- Jako výpočet určité DYNAMICKÉ hodnoty
- Jako vytvoření „virtuální“ tabulky
;
Kde všude ho můžeme použít;
SELECT – k vypočtení hodnoty ve sloupečku;
FROM – k vytvoření „virtuální“ tabulky;
JOIN – k vytvoření „virtuální“ tabulky;
WHERE – k vypočtení hodnoty (=) nebo hodnot (in) pro splnění podmínky;
;


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 4        
-- Zobrazení všech teroristických událostí, které spáchala teroristická organizace s nejvetším počtem obětí v rámci jednoho útoku
LOGIKA:
1) Vytvořit si hlavní select, zajímají nás pouze sloupce gname,eventid, nkill. Pracujeme s tabulkou teror
2) Bokem si vypočítat, která organizace (gname) spáchala útok s nejvyšším počtem obětí
3) Vložit tento select do klauzule WHERE 

;SELECT GNAME, EVENTID, NKILL FROM TEROR LIMIT 20;

SELECT  gname, -- tento SELECT nam vrati jednu hodnotu = 1 sloupec, 1 radek
EVENTID, NKILL
               FROM teror 
               ORDER BY nkill DESC NULLS LAST
               LIMIT 1;

SELECT 
    gname
    ,eventid
    ,nkill
FROM teror
WHERE gname = 'Islamic State of Iraq and the Levant (ISIL)'; --> HARD-CODED hodnota --> jak na dynamickou hodnotu?


SELECT 
    gname
    ,eventid
    ,nkill
FROM teror
WHERE gname = (SELECT  gname -- tento SELECT nam vrati jednu hodnotu = 1 sloupec, 1 radek
               FROM teror 
               ORDER BY nkill DESC NULLS LAST
               LIMIT 1
               ); 

--Co kdybychom chteli prvních 7 největších útoků?
SELECT 
    gname
    ,eventid
    ,nkill
FROM teror
WHERE gname IN (SELECT  gname -- tento SELECT nam vrati jednu hodnotu = 1 sloupec, 1 radek
               FROM teror 
               ORDER BY nkill DESC NULLS LAST
               LIMIT 7
               ); 


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 5
--Spocitej celkovy pocet mrtvych po letech pouze pro ty zeme, jejich celkovy soucet zabitych byl vic jako 30 tisíc.
1) Spocitat si celkovy pocet mrtvych po letech
2) Spocitat si pocet mrtvych po zemi. Pridej podminku, ze celkovy pocet zabitych musi byt vic jak 30 tisic.
3) Kam vnorime select?
4) Jakou podminku pouzijeme?

SELECT IYEAR, SUM(NKILL)
FROM TEROR
WHERE COUNTRY_TXT IN
                        (SELECT COUNTRY_TXT
                         FROM TEROR 
                         GROUP BY COUNTRY_TXT
                         HAVING SUM(NKILL) > 30000
                         ORDER BY SUM(NKILL) DESC NULLS LAST
                         ) 
GROUP BY IYEAR;



---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 6 SAMOSTATNA PRACE
// A/ Vypiš všechny teroristické události (EVENTID) v zemi, kde bylo spácháno nejvíce terosticých útoků. 
-- Vyber sloupečky CITY, COUNTRY_TXT a NKILL. Výsledek seraď podle názvu města


SELECT CITY, COUNTRY_TXT, NKILL
FROM TEROR
WHERE COUNTRY_TXT = 
                    (SELECT COUNTRY_TXT, COUNT(EVENTID)
                    FROM TEROR
                    GROUP BY COUNTRY_TXT
                    ORDER BY COUNT(EVENTID) DESC
                    LIMIT 1
                    )
ORDER BY city
;


SELECT city, country_txt, nkill
FROM  teror
WHERE country_txt = (SELECT country_txt
                     FROM (SELECT country_txt, count(eventid)
                          FROM teror
                          GROUP BY country_txt
                          ORDER BY 2 DESC
                          LIMIT 1
                          )
                    )
ORDER BY city
;
-- Jednodušeji:

SELECT city, country_txt, nkill
FROM  teror
WHERE country_txt = (SELECT country_txt
                     FROM teror
                     GROUP BY country_txt 
                     ORDER BY count(eventid) DESC
                     LIMIT 1
                    )
ORDER BY city
;


// B/ Vyber všechny organizace (GNAME), které nespáchaly útok v Evropě (REGION_TXT). Výsledek seřaď podle názvu organizace vzestupně.

SELECT DISTINCT GNAME
FROM TEROR
WHERE GNAME NOT IN (SELECT DISTINCT GNAME FROM TEROR WHERE REGION_TXT ILIKE '%EUROPE%')
ORDER BY GNAME
; 

-- Pozor na SPATNE RESENI! kde se pouze "smazou" radky, kdy se utok stal v Evrope. 
-- Muzete pouzit gname = 'Anarchists', ktera mela 56 utoku v Evrope a dalsich asi 13 nekde jinde.
-- Pokud pouzijeme tuto logiku, tak nam stale vyjde ve vysledku gname Anarchists, ktera tam nema co delat.

SELECT DISTINCT gname
FROM teror
WHERE region_txt NOT ilike '%europe%';

SELECT  gname, eventid, region_txt
FROM teror
WHERE region_txt NOT ilike '%europe%' AND gname = 'Anarchists';

-----------------------------------------------------------------------------------------------------------------...
---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 7
-- Úkol pro ukázku: Vyberte sloupec GNAME z tabulky, ve které jsou tři organizace (GNAME) s nejvyšším množstvím zabitých lidí (MAX(NKILL)) z tabulky TEROR.

SELECT GNAME
FROM 
     (SELECT GNAME, MAX(NKILL) 
      FROM TEROR 
      GROUP BY GNAME
      ORDER BY MAX(NKILL) DESC NULLS LAST
      LIMIT 3
     );

     
---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 8
- Vyber vsechny utoky, kde attacktype1_txt byl ten, co nejvic zabijel
1) Spocitat si, jaky typ utoku ma nejvic zabitych (attacktype1_txt)
2) Jaka typ utoku to byl?
3) Vlozit tento select do podminky do hlavniho selektu
4) V hlavnim selektum chceme pouze gname, attacktype1_txt, nkill a eventid

SELECT GNAME, ATTACKTYPE1_TXT, NKILL, EVENTID -- COUNTRY_TXT
FROM TEROR 
WHERE ATTACKTYPE1_TXT = (select attacktype1_txt from 
                                                        (select attacktype1_txt, sum(nkill)
                                                        from teror
                                                        group by attacktype1_txt
                                                        order by sum(nkill) desc
                                                        limit 1)
                        )



    
---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 9
-- Zajímá nás počet mrtvých v letech 2017 a 2016 které má na svědomí Islámský Stát. Chceme vidět název organizace a ve sloupcích počet mrtvých pro oba roky a meziroční změnu.
-- Pojďme si problém rozebrat na jednotlivé kroky:
Priklad vysledku:
    
GNAME                                       | POCETMRTVYCH2017  | POCETMRTVYCH2016  |   MEZIROCNE
Islamic State of Iraq and the Levant (ISIL) |       7176        |       11719       |       -4543
Khorasan Chapter of the Islamic State       |       1045        |   	696	        |      349
    ...
    
-- Výsledný skript:
SELECT 
      pm17.gname
    , pm17.pocetmrtv2017
    , pm16.pocetmrtv2016     
    , pm17.pocetmrtv2017 - pm16.pocetmrtv2016 AS mezirocne

FROM (SELECT   gname
              ,SUM(nkill) AS pocetmrtv2017
      FROM teror
      WHERE iyear=2017 
            AND gname ILIKE'%islamic state%' 
      GROUP BY GNAME
      ORDER BY pocetmrtv2017 DESC) AS pm17

LEFT JOIN (SELECT gname
                 ,SUM(nkill) AS pocetmrtv2016
           FROM teror
           WHERE iyear=2016 
                 AND gname ILIKE'%islamic state%'
           GROUP BY 1
          ORDER BY pocetmrtv2016 DESC) AS pm16

ON pm17.gname = pm16.gname;


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 10
-- Priklad - chceme vypocitat celkovy pocet zabitych podle regionu a zeme a potom jeste celkovy pocet zabitych POUZE v ramci regionu jako takoveho
-- Příklad: Vyber region (REGION_TXT), zemi (COUNTRY_TXT), počet zabitých v zemi (NKILL). Seřaď podle region_txt, country_txt.
-- Přidej sloupeček celkoveho poctu zabitých v regionu. --> vypocitame bokem a pripojime pres LEFT JOIN

-- Řešení: Vyber region (REGION_TXT), zemi (COUNTRY_TXT), počet zabitých v zemi (NKILL):

SELECT region_txt
       , country_txt
       , SUM(nkill) AS zabitych_zeme
      
FROM teror
GROUP BY region_txt, country_txt
ORDER BY region_txt, country_txt
;

-- Přidej sloupeček celkoveho poctu zabitých v regionu:

SELECT teror.region_txt
       , country_txt
       , SUM(nkill) AS zabitych_zeme
       , navic_region.zabitych_region    
FROM teror

LEFT JOIN
          (SELECT region_txt, SUM(nkill) AS zabitych_region
          FROM teror
          GROUP BY region_txt) AS navic_region
    ON teror.region_txt   =  navic_region.region_txt

GROUP BY teror.region_txt, country_txt, navic_region.zabitych_region
ORDER BY teror.region_txt, country_txt
;

-- Můžeme to udělat i "složitěji", kdy si připravíme dvě hotové tabulky, které spojíme:

SELECT  puvodni_tabulka.*
      , navic_region.zabitych_region
FROM 
      (SELECT region_txt
             , country_txt
             , SUM(nkill) AS zabitych_zeme     
      FROM teror
      GROUP BY region_txt, country_txt
       ) AS puvodni_tabulka

LEFT JOIN
          (SELECT region_txt, SUM(nkill) AS zabitych_region
          FROM teror
          GROUP BY region_txt) AS navic_region
    ON puvodni_tabulka.region_txt   =  navic_region.region_txt

ORDER BY puvodni_tabulka.region_txt, country_txt
;



---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 11
-- SUBSELECT V SELECT

-- Vypočítej následující sloupčeky:
      --počet všech útoků, kde byla použita Fake Weapons
      --počet zabitých, kde byla použita Fake Weapons
      --počet všech útoků, kde NEbyla použita Fake Weapons
      --počet zabitých, kde NEbyla použita Fake Weapons

     
SELECT 
      (SELECT count(nkill) FROM teror WHERE weaptype1_txt = 'Fake Weapons') AS attaks_fake_weapons   
    , (SELECT SUM(nkill) FROM teror WHERE weaptype1_txt = 'Fake Weapons') AS nkill_fake_weapons
    , (SELECT count(nkill) FROM teror WHERE weaptype1_txt != 'Fake Weapons') AS attacks_without_fake_weapons
    , (SELECT SUM(nkill) FROM teror WHERE weaptype1_txt != 'Fake Weapons') AS nkill_without_fake_weapons
;


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 12
---------------------------------------------------------                        
-- CTE (Common Table Expression)
---------------------------------------------------------  

-- Výhoda CTE – 1x se vytvoří, x krát se může použít / referovat na ni


WITH cte_celkovy_pocet_navstev_za_den AS
       (SELECT cast(datum as date) as den, COUNT(*) AS pocet_navstev_za_den 
        FROM navstevy 
        GROUP BY cast(datum as date) 
       )

SELECT navstevy.*, pocet_navstev_za_den
FROM navstevy
LEFT JOIN cte_celkovy_pocet_navstev_za_den ON cast(navstevy.datum as date)  = cte_celkovy_pocet_navstev_za_den.den
;


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 13
--Vytvor unikatni kombinace teror. skupiny a zeme jako CTE, pak vyber vsechny sloupecky z CTE tabulky


WITH teror_country AS
    (SELECT DISTINCT 
         t.gname AS skupina
        ,c.name AS zeme 
     FROM teror2 t 
     INNER JOIN country c ON t.country=c.id )
 
SELECT * 
FROM teror_country;


---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 14
-- vice tabulek - oddeleno carkou
WITH rukojmi_po_letech_fake AS
    (SELECT 
        iyear
        ,SUM(nhostkid) AS rukojmi_fake 
     FROM teror 
     WHERE weaptype1_txt = 'Fake Weapons' AND nhostkid <> -99 
     GROUP BY iyear), 
 
    rukojmi_po_letech_bez_fake AS
    (SELECT 
        iyear
        ,SUM(nhostkid) AS rukojmi_bez_fake  
     FROM teror 
     WHERE weaptype1_txt <> 'Fake Weapons' AND nhostkid <> -99 
     GROUP BY iyear)

SELECT * 
FROM rukojmi_po_letech_fake
RIGHT JOIN rukojmi_po_letech_bez_fake as bf on f.iyear = bf.iyear
;
 
--spojeni pres roky
SELECT  
    f.iyear
    ,f.rukojmi_fake
    ,bf.rukojmi_bez_fake
FROM rukojmi_po_letech_fake AS f 
LEFT JOIN rukojmi_po_letech_bez_fake AS bf ON f.iyear=bf.iyear
; 

-- ZMENA PORADI TABULEK
WITH rukojmi_po_letech_fake AS
    (SELECT 
        iyear
        ,SUM(nhostkid) AS rukojmi_fake 
     FROM teror 
     WHERE weaptype1_txt = 'Fake Weapons' AND nhostkid <> -99 
     GROUP BY iyear), 
 
    rukojmi_po_letech_bez_fake AS
    (SELECT 
        iyear
        ,SUM(nhostkid) AS rukojmi_bez_fake  
     FROM teror 
     WHERE weaptype1_txt <> 'Fake Weapons' AND nhostkid <> -99 
     GROUP BY iyear)
 
--spojeni pres roky
SELECT  
    f.iyear
    ,f.rukojmi_fake
    ,bf.rukojmi_bez_fake
FROM rukojmi_po_letech_bez_fake AS bf
LEFT JOIN rukojmi_po_letech_fake AS f    ON f.iyear=bf.iyear
; 



---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 15
// C/ Vyber všechny organizace (GNAME), které nespáchaly útok v Asii (REXION_TXT). Výsledek seřaď podle názvu organizace vzestupně.
-- C1: Napište jako CTE


WITH ORG_IN_ASIA AS 
(SELECT DISTINCT GNAME FROM TEROR WHERE REGION_TXT ILIKE '%ASIA%')

SELECT DISTINCT GNAME
FROM TEROR
WHERE GNAME NOT IN (SELECT GNAME FROM ORG_IN_ASIA)
ORDER BY GNAME
;

-- C2: Nejdříve si vytvořte dočasnou tabulku ASIA, následně vytvořte dotaz nad touto dočasnou tabulkou:


CREATE OR REPLACE TEMPORARY TABLE ASIA AS 
SELECT DISTINCT GNAME FROM TEROR WHERE REGION_TXT ILIKE '%ASIA%'
;

SELECT DISTINCT GNAME
FROM TEROR
WHERE GNAME NOT IN (SELECT GNAME FROM ASIA)
ORDER BY GNAME
;

---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 16
Napište dotaz s využitím vnořeného SELECTu (bez CTE nebo pomocné tabulky):


SELECT DISTINCT GNAME
FROM TEROR
WHERE GNAME NOT IN (SELECT DISTINCT GNAME FROM TEROR WHERE REGION_TXT ILIKE '%ASIA%')
ORDER BY GNAME
;

---------------------------------------------------------------------------------------------------------------------------------------------------------
CAST 17
// E/ Přepiš tento dotaz, který obsahuje vnořený select do podoby CTE (bez vnořeného SELECTu):

SELECT teror.region_txt
       , country_txt
       , SUM(nkill) AS zabitych_zeme
       , navic_region.zabitych_region    
FROM teror
LEFT JOIN
          (SELECT region_txt, SUM(nkill) AS zabitych_region
          FROM teror
          GROUP BY region_txt) AS navic_region
    ON teror.region_txt   =  navic_region.region_txt
GROUP BY teror.region_txt, country_txt, navic_region.zabitych_region
ORDER BY teror.region_txt, country_txt
;


WITH 
navic_region AS (
        SELECT region_txt, SUM(nkill) AS zabitych_region
          FROM teror
          GROUP BY region_txt)

SELECT   teror.region_txt
       , country_txt
       , SUM(nkill) AS zabitych_zeme  
       , zabitych_region
FROM teror

LEFT JOIN navic_region ON teror.region_txt = navic_region.region_txt
GROUP BY teror.region_txt, country_txt, zabitych_region
ORDER BY teror.region_txt, country_txt
;
