---------------------------------------------------------------------------
--JOINY 2.0
---------------------------------------------------------------------------

--NOVÉ TABULKY: teror2, attacktype, country, region, weaptype

SELECT *
FROM teror2
LIMIT 10;


SELECT *
FROM attacktype
LIMIT 10; -- sloupce ID a NAME

SELECT *
FROM country
    LIMIT 10; -- sloupce ID a NAME

SELECT *
FROM weaptype
LIMIT 10; -- sloupce ID a NAME

---------------------------------------------------------------------------
--INNER JOIN
---------------------------------------------------------------------------
-- ve Snowflaku v query INNER JOIN = JOIN

SELECT *
FROM teror2
JOIN attacktype 
    ON attacktype1 = id
LIMIT 10; -- obsahuje všechny sloupce z obou tabulek - zascrollujte se úplně doprava

-- pokud by se sloupce v jedné z tabulek, které joinujeme, jmenovaly stejně, Snowflake by netušil, který sloupec myslíme a vyhodil by chybu. Proto se používají aliasy (klíčové slovo AS).
-- Aliasy se můžou používat pro zkrácení, protože názvy tabulek mohou být v reálu dlouhé jako písnička
SELECT *
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
LIMIT 10;

SELECT 
    a.*
    ,t.*
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
LIMIT 10; --opět vidíme všechny sloupce, nyní první z tabulky attacktype a pak až z teror2


COURSES.SCH_TEROR.TEROR2 --můžeme vybrat jen konkrétní sloupečky, které chceme zobrazit a nemusí to být sloupečky, přes které jsme napojovali






-- na normálním teroru si ukážeme, že lze používat i funkce v klauzuli ON

SELECT 
    t.attacktype1_txt
    ,a.name
FROM teror AS t
JOIN attacktype AS a
    ON LOWER(t.attacktype1_txt) = LOWER(a.name)
;

SELECT 
    t.country_txt
    ,c.name
FROM teror AS t
JOIN country AS c
    ON t.country_txt ILIKE c.name
;

SELECT *
FROM TABULKA1 AS t1
JOIN TABULKA2 AS t2
    ON t1.DATUM BETWEEN t2.VALID_FROM AND t2.VALID_TO;

-- opět můžeme nabalovat i ostatní klíčová slova a funkce

SELECT 
    t.IDATE
    ,c.name
    ,t.nkill
    ,t.approxdate
    ,t.country
    ,c.id
FROM teror2 AS t
JOIN country AS c
    ON t.country = c.id
WHERE t.approxdate IS NOT NULL AND c.name ILIKE '%republic%'
ORDER BY nkill DESC NULLS LAST
--LIMIT 10
;

-- včetně oblíbeného GROUP BY
SELECT 
    a.name AS attack_type
    ,COUNT(*) AS pocet_utoku
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
GROUP BY attack_type
HAVING attack_type ILIKE 'u%' OR attack_type ILIKE 'h%'
ORDER BY pocet_utoku DESC;






-- více JOINů v jednom dotazu
SELECT
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM TEROR2 AS t
INNER JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
INNER JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
INNER JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
; -- 449 řádků

----------------
--ÚKOLY
----------------
-- používejte tabulku (teror2)
-- 1. Vypište id útoku (EVENTID), datum útoku (IDATE) a stát (NAME), ve kterém útok proběhl. 

SELECT t.EVENTID
    ,t.IDATE
    ,a.NAME
FROM TEROR2 AS t
JOIN ATTACKTYPE AS a
  ON t.attacktype1 = a.id
;

SELECT t.EVENTID
    ,t.IDATE
    ,c.NAME
FROM teror2 AS t
JOIN country AS c
  ON t.country = c.id
;


-- 2. Vypište id útoku (EVENTID), datum útoku (IDATE) a stát (NAME), ve kterém útok proběhl. 
--Vyfiltrujte pouze roky (IYEAR) 2016 a 2017 a výsledek seřaďte podle státu vzestupně (A-Z).


SELECT t.EVENTID
    ,t.IDATE
    ,a.NAME
    ,t.IYEAR
FROM TEROR2 AS t
JOIN ATTACKTYPE AS a
  ON t.attacktype1 = a.id
WHERE t.IYEAR = 2016 AND t.IYEAR = 2017
ORDER BY a.NAME DESC NULLS LAST
;


SELECT t.EVENTID
    ,t.IDATE
    ,c.NAME
FROM teror2 AS t
JOIN country AS c
  ON t.country = c.id
WHERE t.IYEAR = 2016 AND t.IYEAR = 2017  
ORDER BY a.NAME DESC NULLS LAST
;






-- 3. Vypište počet mrtvých po státech a dnech (GROUP BY). Seřaďte výsledek podle počtu mrtvých sestupně a NULLy z výsledku vyřaďte.


SELECT 
    ,t.IDATE
    ,c.NAME
    ,SUM(t.nkill)
FROM teror2 AS t
JOIN country AS c
  ON t.country = c.id
GROUP BY c.name, t.IDATE
HAVING SUM(t.nkill) IS NOT NULL 
ORDER BY SUM(t.nkill)
;




-------------------------------------------
--ÚKOL Z KODIM.CZ, LEKCE 4
-------------------------------------------
-- 1. Vypiš IDATE, GNAME, NKILL, NWOUND z tabulky teror2 (!) a přes sloupeček country připoj zemi z tabulky COUNTRY.












---------------------------------------------------------------------------
--LEFT JOIN
---------------------------------------------------------------------------

SELECT *
FROM teror2
LEFT JOIN attacktype 
    ON attacktype1 = id
LIMIT 10;


SELECT
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM TEROR2 AS t
LEFT JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
LEFT JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
LEFT JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
; -- 84341 řádků

-- vs INNER JOIN. Jaký je rozdíl?
SELECT
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM TEROR2 AS t
INNER JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
INNER JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
INNER JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
; -- 449 řádků

----------------
--ÚKOLY
----------------
-- používejte tabulku (teror2)
-- 4. Napište předcházející dotaz tak, abyste pomocí LEFT JOINu a WHERE dostali stejný výsledek jako s INNER JOINem. 
--Přeloženo: vypište EVENTID a názvy attacktype1, attacktype2 a attacktype3. Čerpejte z tabulek TEROR2 a ATTACKTYPE.
-- Vypište jen řádky, kde jsou uvedeny všechny tři attacktype, pomocí LEFT JOIN a WHERE.  

SELECT 
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM teror2 AS t
LEFT JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
LEFT JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
LEFT JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
where t.attacktype1 IS NOT NULL AND t.attacktype2 IS NOT NULL AND t.attacktype3 IS NOT NULL
;






-------------------------------------------
--ÚKOLY Z KODIM.CZ, LEKCE 4
-------------------------------------------
-- 2. Vypiš IDATE, GNAME, NKILL, NWOUND z tabulky teror2 (!) a
-- přes sloupeček country připoj zemi z tabulky COUNTRY
-- přes sloupeček weaptype1 připoj název zbraně z tabulky WEAPTYPE
-- přes sloupeček weaptype2 připoj název zbraně z tabulky WEAPTYPE






-- 3. Vypiš IDATE, gname, nkill, nwound z tabulky teror2 (!) a
-- přes sloupeček country připoj zemi z tabulky COUNTRY
-- přes sloupeček weaptype1 připoj nazev zbraně z tabulky WEAPTYPE
-- přes sloupeček weaptype2 připoj nazev zbraně z tabulky WEAPTYPE
-- vypiš jen útoky jejichž sekundární zbraň byla zápalná ('Incendiary')







--------------------------------------------------------------------
-- typy joinů lze v jednom selectu kombinovat dle potřeby

SELECT c.name as country, 
       atyp1.name as attack_type1, 
       atyp2.name as attack_type2, 
       atyp3.name as attack_type3
FROM teror2 as t2
LEFT JOIN country as c 
ON t2.country = c.id
JOIN attacktype as atyp1 
ON t2.attacktype1 = atyp1.id
JOIN attacktype as atyp2
ON t2.attacktype2 = atyp2.id
JOIN attacktype as atyp3 
ON t2.attacktype3 = atyp3.id; 


-------------------------------------------------------------------------
-- RIGHT JOIN
-------------------------------------------------------------------------

SELECT *
FROM teror2
RIGHT JOIN attacktype 
    ON attacktype1 = id;
--LIMIT 10;



SELECT 
    t.COUNTRY
    ,c.NAME AS COUNTRY_NAME
    ,t.IDATE
    ,a.NAME AS ATTACKTYPE1_TXT
FROM teror2 AS t
RIGHT JOIN country AS c
    ON t.country = c.id
RIGHT JOIN ATTACKTYPE AS A
    ON t.ATTACKTYPE1=A.ID
WHERE c.name = 'Czech Republic'
  AND t.iyear IN (2015, 2016)
  AND a.NAME = 'Facility/Infrastructure Attack'
;




-------------------------------------------------------------------------
-- FULL OUTER JOIN
-------------------------------------------------------------------------
-- vrati zaznamy, pro ktere najde shodu plus zbyle zaznamy z obou tabulek, pouziva se zridka
-- TABULKA_OLD obsahuje (1,'Jan Smutný'),(2,'Jana Červená'),(3,'Monika Broučková'),(4,'Pavel Obr')
-- TABULKA_NEW obsahuje (1,'Jan Smutný'),(4,'Pavel Obr'),(5,'Tereza Okatá')
SELECT * FROM COURSES.SCH_CZECHITA_HRISTE.TABULKA_OLD AS o
FULL OUTER JOIN COURSES.SCH_CZECHITA_HRISTE.TABULKA_NEW AS n
ON o.id = n.id
;

-------------------------------------------------------------------------
-- CROSS JOIN
-------------------------------------------------------------------------
-- kartezsky soucin
-- vrati kombinace vsech radku z obou tabulek bez shody mezi jakymikoli sloupci

SELECT count(*)
FROM teror2; -- 84341

SELECT count(*)
FROM attacktype; -- 9

SELECT *
FROM teror2 AS t
CROSS JOIN attacktype AS a
;--759 069

SELECT 9 * 84341; --759 069

-- pozor na CROSS JOIN velkých tabulek
SELECT *
FROM teror2 AS t1
CROSS JOIN teror2 AS t2
;--

SELECT 84341 * 84341; --507 177

-- pozor na nechtěný CROSS JOIN
SELECT *
FROM teror2 AS t
JOIN attacktype AS a
--ON 1=1
; --507 177





-------------------------------------------
--ÚKOLY Z KODIM.CZ, LEKCE 4
-------------------------------------------

-- 4. Z tabulky teror2 vypis pocet utoku, pocty mrtvych a ranenych v roce 2016 -- podle pouzitych zbrani (WEAPTYPE1)






-- 5. Vypiste pocet unesenych lidi (kdy byl typ utoku unos rukojmich) a pocet udalosti podle regionu a roku.
--     Vysledek seradte podle poctu unesenych lidi sestupne. Sloupecky pojmenujte region, rok, pocet_unesenych, pocet_udalosti






-- 6. Zjistí počty útoků z tabulky teror2 po letech a kontinentech. 
--Tj. napoj sloupecek region z tabulky teror2 na tabulku region a vytvoř sloupeček kontinent z nazvu regionu a podle něj a podle roku tabulku "zgrupuj" (zagreguj).

