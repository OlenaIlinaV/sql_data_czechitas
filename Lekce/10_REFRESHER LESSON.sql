------------------------------------------------------------------------------------------------------------------
-- OPAKOVACÍ LEKCE SQL - CZECHITAS DATOVÁ AKADEMIE PRAHA JARO 2024, Michal Donát
------------------------------------------------------------------------------------------------------------------

-- Cílem je si připomenout, co už všechno umíme.
-- Nad každým příkladem chvíli popřemýšlejte a pak si ho projedeme společně


--------------------------------
-- CREATE TABLE, CREATE OR REPLACE TABLE, INSERT INTO TABLE, DELETE FROM TABLE
--------------------------------
-- Přepni se do svého schématu buď myší nebo s použitím USE SCHEMA SCH_CZECHITA_PRIJMENIJ;
-- Použít můžeš příkaz CREATE TABLE, ale (pokud je to tvůr záměr), raději vždy používej CREATE OR REPLACE TABLE
-- Vytvoř si tabulku NAVSTEVY_2022. Chceme, aby měla stejnou strukturu jako již existující tabulka NAVSTEVY.

--------------------------------
-- Перейдіть до вашої схеми за допомогою миші або за допомогою команди USE SCHEMA SCH_CZECHITA_PRIJMENIJ;
-- Ви можете використовувати команду CREATE TABLE, але (якщо це є наміром автора) завжди використовуйте CREATE OR REPLACE TABLE
-- Створіть таблицю NAVSTEVY_2022. Ми хочемо, щоб вона мала таку ж структуру, як і існуюча таблиця NAVSTEVY.



CREATE OR REPLACE TABLE NAVSTEVY_2022 ( 
  ID INT,
  DATUM DATETIME,
  POPIS VARCHAR(2000),
  PACIENT_ID INT,
  POJISTOVNA_ID INT
);

-- VLOŽENÍ DAT: Zde jsou data pro manuální vložení řádků do tabulky NAVSTEVY_2022. Vlož je.

(1,'2022-03-14 16:20','Preventivní prohlídka, rozhodnuto o trhání 8A',1,1),
(2,'2022-03-15 10:05', NULL,2,2),
(3,'2022-03-15 11:00','Výběr barvy korunky',3,4),
(4,'2022-03-15 17:00','Trhání 8A',1,1),
(5,'2022-06-15 12:30','Instalace nové korunky',3,3),
(6,'2022-08-16 12:45','Nastaly komplikace při trhání 8A, ošetření bolesti',1,2),
(7,'1970-01-01 00:01','Testovací záznam',10,10),
(8,'2022-12-31 17:30','Instalace nové korunky',2,2)
;



INSERT INTO NAVSTEVY_2022 (ID, DATUM, POPIS, PACIENT_ID, POJISTOVNA_ID)
  VALUES 
(1,'2022-03-14 16:20','Preventivní prohlídka, rozhodnuto o trhání 8A',1,1),
(2,'2022-03-15 10:05', NULL,2,2), -- pokud hodnotu nemáme, vložíme "prázdno"
(3,'2022-03-15 11:00','Výběr barvy korunky',3,4),
(4,'2022-03-15 17:00','Trhání 8A',1,1),
(5,'2022-06-15 12:30','Instalace nové korunky',3,3),
(6,'2022-08-16 12:45','Nastaly komplikace při trhání 8A, ošetření bolesti',1,2),
(7,'1970-01-01 00:01','Testovací záznam',10,10),
(8,'2022-12-31 17:30','Instalace nové korunky',2,2)
;


-- MAZÁNÍ DAT: Smaž řádek z tabulky NAVSTEVY_2022, který na první pohled vypadá jako chybný/testovací.



DELETE FROM NAVSTEVY_2022
WHERE id = 7
;

-- Spusť tyto dva skripty, ať máme stejná data (přidává časový údaj do sloupce datum)
CREATE OR REPLACE TABLE NAVSTEVY ( 
  ID INT,
  DATUM DATETIME,
  POPIS VARCHAR(2000),
  PACIENT_ID INT,
  POJISTOVNA_ID INT
)
;
INSERT INTO NAVSTEVY (ID, DATUM, POPIS, PACIENT_ID, POJISTOVNA_ID)
  VALUES 
(1,'2023-03-14 16:20','PreventivnÍ prohlídka, rozhodnuto o trhání 8A',1,1),
(2,'2023-03-15 10:05','Ošetření vypadlé plomby',2,2),
(3,'2023-03-15 11:00','Výběr barvy korunky',3,3),
(4,'2023-03-15 12:00','Trhání 8A',1,1),
(5,'2023-03-15 12:30','Instalace nové korunky',3,3),
(6,'2023-03-16 12:45','Nastaly komplikace při trhání 8A, ošetření bolesti',1,2)
;

--------------------------------
-- UNION ALL, UNION, TVORBA ID
--------------------------------

-- UNION ALL spojí tabulky pod sebe, UNION navíc smaže z výsledku duplicitní řádky (stejně jako SELECT DISTINCT)

-- Spoj pod sebe tabulky NAVSTEVY a NAVSTEVY_2022 a vytvoř tak tabulku NAVSTEVY_KOMPLET
-- Sloupec id z tabulek přejmenuj na id_puvodni
-- Vytvoř nový sloupec id, který bude obsahovat primární unikátní klíč pro nově vzniklou tabulku ve formátu např. '2022_1' (rok podtržítko id z původních tabulek)
-- Jako rok pro tabulku NAVSTEVY_2022 použij 2022. Tabulka NAVSTEVY obsahuje pouze události z roku 2023.

-- UNION ALL об'єднує таблиці разом, UNION також видаляє повторювані рядки з результату (так само, як SELECT DISTINCT)

-- Об'єднати таблиці NAVSTEVY і NAVSTEVY_2022 для створення таблиці NAVSTEVY_COMPLET
-- Перейменувати стовпець id з таблиць на id_original
-- Створіть новий стовпець id, який міститиме первинний унікальний ключ для новоствореної таблиці у форматі, наприклад, '2022_1' (рік підкреслено ідентифікатором id з оригінальних таблиць)
-- Використовуйте 2022 рік як рік для таблиці NAVSTEVY_2022. Таблиця NAVSTEVY містить події лише з 2023 року.

CREATE OR REPLACE TABLE NAVSTEVY_KOMPLET AS
SELECT
      '2023'||'_'||id AS id
    , id AS id_puvodni
    , datum
    , popis
    , pacient_id
    , pojistovna_id
FROM NAVSTEVY

UNION ALL 

SELECT
      '2022'||'_'||id AS id
    , id AS id_puvodni
    , datum
    , popis
    , pacient_id
    , pojistovna_id
FROM NAVSTEVY_2022
;

--------------------------------
-- ALTER TABLE, UPDATE TABLE
--------------------------------
-- Můžeme přejmenovat sloupec, přidat a odebrat sloupec, měnit hodnoty atd.

-- Přidej do tabulky NAVSTEVY_KOMPLET nový sloupec "zpracovano", který bude mít defaultní hodnotu 1 a datový typ INTEGER.
-- Proveď kontrolu datových formátů v tabulce.


-- Ми можемо перейменовувати стовпець, додавати і видаляти стовпець, змінювати значення тощо.

-- Додайте до таблиці NAVSTEVY_COMPLET новий стовпець "processed", який матиме значення за замовчуванням 1 і тип даних INTEGER.
-- Перевірте формати даних у таблиці.



ALTER TABLE NAVSTEVY_KOMPLET ADD zpracovano INTEGER DEFAULT 1;

DESC TABLE NAVSTEVY_KOMPLET; -- Pro kontrolu sloupce a jeho datového typu


-- Změň hodnotu ve sloupci zpracovano na 0 pro záznamy, kde pojistovna_id = 3 (Zdravotní pojišťovna datových analitiků)

-- Змініть значення в оброблюваному стовпчику на 0 для записів, де insurance_id = 3 (Data Analysts Health Insurance Company)


UPDATE NAVSTEVY_KOMPLET SET zpracovano = 0
WHERE pojistovna_id = 3;

SELECT * FROM NAVSTEVY_KOMPLET
ORDER BY pojistovna_id; -- pro kontrolu

--------------------------------
-- WHERE A PODMÍNKY
--------------------------------
-- Vyber všechny sloupce z tabulky NAVSTEVY_KOMPLET.
-- Vyber pouze řádky, které:
 -- Datum je v roce 2022 a pojistovna_id je 3 NEBO datum je v roce 2023 a pojistovna_id je 1 nebo 2
 -- a zároveň kde popis návštěvy obsahuje řetězec '%orun%' nebo '%plom%' (ignoruj velikost písmen)
 -- a zároveň kde zpracovano = 1
 
-- Pokud nevíš, jak napsat některou funkci, vyjledej Googlem například "snowflake year" a nakoukni do dokumentace.


-- Виділити всі стовпці з таблиці NAVSTEVY_COMPLET.
-- Вибрати тільки ті рядки, які:
 -- дата у 2022 році та ідентифікатор страхової компанії дорівнює 3 АБО дата у 2023 році та ідентифікатор страхової компанії дорівнює 1 або 2
 -- і де опис візиту містить рядок '%orun%' або '%plom%' (ігнорувати регістр)
 -- і де processed = 1
 
-- Якщо ви не знаєте, як написати функцію, погугліть, наприклад, "snowflake year" і подивіться документацію.


Select *
from NAVSTEVY_COMPLET
where 1=1
    AND ((Year(DATUM) = 2012 AND POJISTOVNA_ID = 3) OR (Year(DATUM) = 2013 AND POJISTOVNA_ID IN (1, 2)))
    AND (POPIS ILIKE '%orun%' OR POPIS ILIKE '%plom%')
    AND ZPRACOVANO = 1   
;

від лектора:

SELECT *
FROM NAVSTEVY_KOMPLET
WHERE 1=1
    AND ((YEAR(datum) = 2022 AND pojistovna_id = 3) OR (YEAR(datum) = 2023 AND pojistovna_id IN (1, 2)))
    AND (popis ILIKE '%orun%' OR popis ILIKE '%plom%')
    AND zpracovano = 1
;

--------------------------------
-- ZÁKLADNÍ (SKALÁRNÍ) FUNKCE, ORDER BY, LIMIT
--------------------------------
-- Vytvoř SELECT, kterým vybereš sloupce id a popis z tabulky NAVSTEVY_KOMPLET.
-- Přidej sloupec, kde vynásobíš 25 s 4. Pojmenuj ho "nasobek" (včetně uvozovek, aby byl mamalými písmeny).
-- Vyber sloupec pojistovna_id, přecastuj ho na VARCHAR(255)
-- Z popis zobraz pouze první slovo
-- Ve sloupci popis nahraď mezery podtržítky
-- K datu přidej vždy dva dny
-- Každému složitějšímu sloupci přidej komentář, ať v budoucnu víš, co dělá
-- Zobraz pouze prvních 10 záznamů, seřazeno dle sloupce datum od nejnovějších

-- Створіть SELECT для вибору стовпців id та description з таблиці NAVSTEVY_COMPLET.
-- Додайте стовпець, в якому ви множите 25 на 4. Назвіть його "subsumed" (з лапками, щоб зробити його рядковим).
-- Виділіть стовпець insurance_id, перейменуйте його на VARCHAR(255)
-- Показувати тільки перше слово опису
-- У колонці description замінити пробіли на підкреслення
-- Завжди додавати два дні до дати
-- Додайте коментар до кожного складного стовпця, щоб ви знали, що він робить у майбутньому
-- Показувати лише перші 10 записів, відсортованих за стовпчиком дати від найновіших


SELECT
      id
    , popis
    , 25*4 AS "nasobek" -- prosté násobení dvou fixních čísel
    , pojistovna_id::VARCHAR(255) -- přecastování na text, jiný možný zápis: CAST(pojistovna_id AS VARCHAR(255))
    , SPLIT_PART(popis, ' ', 1) -- zobrazí první slovo popisu (resp. část textu před první mezerou)
    , REPLACE(popis, ' ', '_') -- nahrazuje mezery podtrřítky
    , DATEADD(day, 2, datum) -- přidává dva dny k datumu

FROM NAVSTEVY_KOMPLET
ORDER BY datum DESC
LIMIT 10
;

--------------------------------
-- CASE WHEN, IFNULL
--------------------------------
-- Z tabulky NAVSTEVY_KOMPLET vyber sloupce id a datum.
-- Pokud ve sloupci popis je hodnota NULL, nahraď ji textem 'Není známo'
-- Přidej sloupec pojistovna_txt, kde:
  -- Pokud je pojistovna_id = 1 vypiš 'Odborová zdravotní pojišťovna'
  -- Pokud je pojistovna_id = 2 vypiš 'Všeobecná zdravotní pojišťovna'
  -- Pokud je pojistovna_id = 3 vypiš 'Zdravotní pojišťovna datových analitiků'
  -- Jinak vypiš 'Jiná'
  

-- Виберіть стовпці id та date з таблиці NAVSTEVY_COMPLET.
-- Якщо стовпець description дорівнює NULL, замініть його на 'Невідомо'.
-- Додати стовпець insurance_txt де:
  -- Якщо insurance company_id = 1, вивести 'Профспілкова лікарняна каса'.
  -- Якщо insurance company_id = 2, вивести 'Лікарняна каса'.
  -- Якщо insurance_id = 3, вивести 'Компанія медичного страхування аналітиків'.
  -- Інакше вивести 'Інше'
  

SELECT 
      id
    , datum
    , IFNULL(popis, 'Není známo')
    , CASE 
        WHEN pojistovna_id = 1 THEN 'Odborová zdravotní pojišťovna'
        WHEN pojistovna_id = 2 THEN 'Všeobecná zdravotní pojišťovna'
        WHEN pojistovna_id = 3 THEN 'Zdravotní pojišťovna datových analitiků'
        ELSE 'Jiná'
      END AS pojistovna_txt
FROM NAVSTEVY_KOMPLET
;

--------------------------------
-- COUNT, COUNT DISTINCT
--------------------------------
-- Spočítej, kolik záznamů je v tabulce NAVSTEVY_KOMPLET
-- Spočítej, v kolika různých dnech byla nějaká návštěva
-- Spočítej, kolik různých pojišťoven je v tabulce
-- Spočítej, u kolika záznamů je vyplněný popis (není NULL)

-- Підрахувати кількість записів у таблиці NAVSTEVY_KOMPLET
-- Підрахувати, скільки різних днів було відвідувань
-- Підрахувати, скільки різних страхових компаній є в таблиці
-- Підрахувати, скільки записів мають заповнений опис (не NULL)


SELECT
      COUNT (*) -- kolik záznamů je v tabulce
    , COUNT (DISTINCT DATE(datum)) -- v kolika různých dnech byla nějaká návštěva
    , COUNT (DISTINCT pojistovna_id) -- kolik různých pojišťoven je v tabulce
    , COUNT (popis) -- u kolika záznamů je vyplněný popis
FROM NAVSTEVY_KOMPLET
;

--------------------------------
-- AGREGČNÍ FUNKCE: GROUP BY, SUM, MAX
--------------------------------
-- Agreguj data v tabulce NAVSTEVY_KOMPLET na úrovni dní - GROUP BY DATE(datum)
-- Vypiš sloupec s datumem = DATE(datum)
-- Spočítej počet návštěv v daný den
-- Pro každý den vypiš čas nejpozdější návštěvy
-- Sečti pacient_id v daný den (nedává to smysl, jen ukázka sčítání)
-- Celé tohle udělej pouze se záznamy, které jsou zpracované (ZPRACOVANO = 1)

-- Об'єднати дані в таблиці NAVSTEVY_KOMPLET на рівні днів - GROUP BY DATE(дата)
-- Вивести стовпець з датою = DATE(дата)
-- Підрахувати кількість відвідувань у заданий день
-- Для кожного дня вивести час останнього візиту
-- Підсумувати patient_id у цей день (це не має сенсу, просто вибірковий підрахунок)
-- Робити все це тільки з обробленими записами (PROCESSED = 1)


SELECT 
    DATE(datum),
    COUNT(*),
    MAX(TIME(datum))
FROM NAVSTEVY_KOMPLET
WHERE ZPRACOVANO = 1
GROUP BY DATE(datum)
ORDER BY DATE(datum)
;

lector:

SELECT
      DATE(datum)
    , COUNT(*) -- počet návštěv v daný den
    , MAX(TIME(datum)) -- nejpozdější čas návštěvy v den
    , SUM(pacient_id) -- součet hodnot v pacient_id v daný den
FROM NAVSTEVY_KOMPLET
WHERE ZPRACOVANO = 1
GROUP BY DATE(datum) -- Pokud by zde bylo pouze datum, nejednalo by se o agregaci, protože každý návštěva v tabulce má svůj unikátní čas
;

--------------------------------
-- JOINY
--------------------------------
-- JOIN bingo: https://docs.google.com/spreadsheets/d/1VcuAykkHSMTxr4eme69_7a3mLYFLP5hIWPldKQ0q42A/edit?usp=sharing

-- Chceme vedle sebe spojit tabulku NAVSTEVY_KOMPLET a POJISTOVNY (pojistovna_id = id) a vybrat všechny sloupce.
-- Zajímá nás každá návštěva, chceme ji obohatit o další informace
 --> Použijeme tedy LEFT JOIN, kde tabulka návštěv bude vlevo
 -- Pokud nemáš ve svém schématu tabulku POJISTOVNY, vezmi si ji odsud: COURSES.SCH_CZECHITA.POJISTOVNY


-- Ми хочемо об'єднати таблиці NAVSTEVY_COMPLET та INSURANCE (insurance_id = id) і вибрати всі стовпці.
-- Нас цікавить кожен візит, ми хочемо збагатити його додатковою інформацією
 --> Використаємо LEFT JOIN, де таблиця відвідувань буде зліва
 -- Якщо у вашій схемі немає таблиці INSURANCE, візьміть її звідси: COURSES.SCH_CZECHITA.INSURANCE


SELECT *
FROM NAVSTEVY_KOMPLET AS n
LEFT JOIN COURSES.SCH_CZECHITA.POJISTOVNY AS i ON n.pojistovna_id = i.id
;


lector:

 SELECT *
 FROM NAVSTEVY_KOMPLET AS nav
 LEFT JOIN POJISTOVNY AS poj ON nav.pojistovna_id = poj.id
 ;

-- JOIN + agregace
-- Zajímá nás jmeno pojišťovny z tabulky POJISTOVNY obohacené o následující pole:
  -- Celkový počet návštěv pro pojišťovnu
  -- Datum první a datum poslední návštěvy nějakého pacienta pojišťovny
  -- Celkový počet pacientů, kteří uskutečnili návštěvu na danou pojišťovnu


-- Нас цікавить назва страхової компанії з таблиці INSURANCE COMPANY, доповненої наступними полями:
  -- Загальна кількість візитів для страхової компанії
  -- Дата першого та останнього візиту пацієнта до страхової компанії
  -- Загальна кількість пацієнтів, які здійснили візит до страхової компанії

SELECT 
    poj.jmeno,
    COUNT(nav.id),
    MAX(nav.datum),
    COUNT(DISTINCT pacient_id)
    
FROM COURSES.SCH_CZECHITA.POJISTOVNY AS poj
LEFT JOIN NAVSTEVY_KOMPLET AS nav ON nav.pojistovna_id = poj.id
GROUP BY poj.jmeno
;


lector:
  
SELECT
      poj.jmeno
    , COUNT(nav.id) -- počet návštěv pro pojišťovnu
    , MAX(nav.datum) -- poslední návštěva
    , MIN(nav.datum) -- první návštěva
    , COUNT(DISTINCT pacient_id) -- počet pacientů

FROM POJISTOVNY poj
LEFT JOIN NAVSTEVY_KOMPLET nav ON poj.id = nav.pojistovna_id
GROUP BY poj.jmeno
;

--------------------------------
-- VNOŘENÝ SELECT, CTE
--------------------------------
-- Pro každého pacienta chceme přidat informaci, kolikrát nás pacient navštívil
-- Chceme tedy vypsat celou tabulku pacienti a pridat sloupec KOLIKRAT
-- Nejdříve si připravíme tabulku s počtem návštěv na pacienta
-- Následně ji spojíme s tabulkou PACITENTI (dáme ji do vnořeného selectu)


-- Для кожного пацієнта ми хочемо додати інформацію про те, скільки разів пацієнт відвідував нас
-- Тому ми хочемо перерахувати всю таблицю пацієнтів і додати стовпчик з назвою NUMBER
-- Спочатку підготуємо таблицю з кількістю візитів для кожного пацієнта
-- Потім ми об'єднаємо її з таблицею ПАЦІЄНТИ (помістимо її у вкладений вибір)



-- Přípravná tabulka alias předchroustání
SELECT pacient_id, COUNT(*) AS kolikrat
FROM NAVSTEVY_KOMPLET
GROUP BY pacient_id
;
-- Sem ji pak vkládáme:
SELECT PACIENTI.*, kolikrat
FROM PACIENTI
LEFT JOIN (     SELECT pacient_id, COUNT(*) AS kolikrat
                FROM NAVSTEVY_KOMPLET
                GROUP BY pacient_id
          ) ON id = pacient_id
;

-- To samé jako CTE:
WITH chroustame AS (SELECT pacient_id, COUNT(*) AS kolikrat
FROM NAVSTEVY_KOMPLET
GROUP BY pacient_id)

SELECT PACIENTI.*, kolikrat
FROM PACIENTI
LEFT JOIN chroustame ON id = pacient_id
;

--------------------------------
-- WINDOW FUNKCE
--------------------------------
-- Chceme docílit toho stejného jako v minulém připadě, bez použití agregace a vnořené query
-- Tedy: Pro každého pacienta chceme informaci, kolikrát nás pacient navštívil
-- Dále chceme ke každému pacientovi přidat informaci (sloupec):
   -- posledni_navsteva: Kdy byl pacient na návštěvě naposledy
   -- kolik_pojistoven: Kolik různých zdravotních pojišťoven pacient využil
   -- posledni_popis: Popis u poslední návštěvy pacienta


SELECT DISTINCT 
      PACIENTI.*
    , COUNT(*) OVER (PARTITION BY pacient_id) AS kolikrat
    , MAX(datum) OVER (PARTITION BY pacient_id) AS posledni_navsteva
    , COUNT(DISTINCT pojistovna_id) OVER (PARTITION BY pacient_id) AS kolik_pojistoven
    , LAST_VALUE(popis) OVER (PARTITION BY pacient_id ORDER BY datum) AS posledni_popis
    
FROM PACIENTI
LEFT JOIN NAVSTEVY_KOMPLET ON PACIENTI.id = pacient_id
;


-- prace s tabulkami v DB COURSES, SCH_CZECHITA schematu:

--1) Jaky je nazev nejdelsiho filmu? Pouzij tabulku IMDB_TITLES2

--1) Як називається найдовший фільм? Використовуйте таблицю IMDB_TITLES2

-- 1 var
SELECT primarytitle, originaltitle, runtimeminutes
FROM SCH_CZECHITA.IMDB_TITLES2
ORDER BY runtimeminutes DESC nulls last
limit 1;

-- 2 var
SELECT PRIMARYTITLE
FROM SCH_CZECHITA.IMDB_TITLES2
WHERE RUNTIMEMINUTES = (SELECT MAX(runtimeminutes) FROM SCH_CZECHITA.IMDB_TITLES2);

--2) jaka je prumerna delka filmu po rokach? Film se pocita jako hodnota ve sloupecku TITLETYPE = 'movie', 'short', 'tvMovie', 'tvShort'. Vyber pouze fimy z 21. stoleti. Pouzij tabulku IMDB_TITLES2
-- Serad podle prumerne delky filmu sestupne. Nezapomen osetrit situaci NULL hodnot

--2) яка середня тривалість фільму за роками? Фільм обчислюється як значення у стовпчику TITLETYPE = 'movie', 'short', 'tvMovie', 'tvShort'. Вибирайте тільки фільми з 21 століття. Використовуйте таблицю IMDB_TITLES2
-- Відсортуйте фільми за спаданням середньої тривалості. Не забудьте встановити в ній значення NULL

SELECT startyear, AVG(runtimeminutes) AS "Time"
FROM SCH_CZECHITA.IMDB_TITLES2
WHERE TITLETYPE IN ('movie', 'short', 'tvMovie', 'tvShort')
    AND startyear > 2000;
GROUP BY startyear
ORDER BY "Time" DESC nulls last
;

-- 3) Ktere roky meli prumerne hodnoceni vic jak 8? Ber v potaz pouze ty filmy, ktere maji vic jak tisic hlasu.
--Pracuj pouze s udaji, ktere se nachazeji v tabulce IMDB_TITLES2 a take v IMDB_RATINGS2

-- 3) У які роки середній рейтинг фільмів перевищував 8 балів? Розглядайте лише ті фільми, які набрали більше тисячі голосів.
-- Працюйте лише з тими даними, які є в таблиці IMDB_TITLES2, а також в IMDB_RATINGS2

SELECT startyear, AVG(averagerating)
FROM SCH_CZECHITA.IMDB_TITLES2 AS t
INNER JOIN SCH_CZECHITA.IMDB_RATINGS2 AS r ON t.tconst = r.tconst
WHERE numvotes > 1000
GROUP BY startyear
HAVING AVG(averagerating) > 8
;


-- 4) Ktery rok ma nejvic filmu pro dospele? Ber v potaz pouze ty filmy mezi lety 1960 a 1980
--Pracuj pouze s udaji, ktere se nachazeji v tabulce IMDB_TITLES2 a take v IMDB_RATINGS2

-- 4) Який рік має найбільше фільмів для дорослих? Враховуйте лише ті фільми, що вийшли між 1960 та 1980 роками.
-- Працюйте лише з даними з таблиці IMDB_TITLES2 та IMDB_RATINGS2


SELECT startyear, count(*) AS pocet_filmu
FROM SCH_CZECHITA.IMDB_TITLES2 AS t
INNER JOIN SCH_CZECHITA.IMDB_RATINGS2 AS r ON t.tconst = r.tconst
WHERE isadult = 1 
AND startyear >= 1960 AND startyear <= 1980 -- startyear between 1960 and 1980
GROUP BY startyear
ORDER BY pocet_filmu desc
limit 1
;

--5 Jaky je prumerne hodnoceni za rok? Berte v potaz pouze filmy za poslednich 10 let. Spocitejte navic jaky je celkovy prumer od roku 2014.
--Pracuj pouze s udaji, ktere se nachazeji v tabulce IMDB_TITLES2 a take v IMDB_RATINGS2

--5 Який середній рейтинг за рік? Візьміть до уваги лише фільми за останні 10 років. Крім того, обчисліть загальний середній показник з 2014 року.
--Працюйте лише з даними, що містяться в таблиці IMDB_TITLES2, а також в IMDB_RATINGS2

-- 1 var
SELECT startyear,avg(averagerating), avg(avg(averagerating)) over () AS celkovy_prumer -- window funkce
FROM SCH_CZECHITA.IMDB_TITLES2 AS t
INNER JOIN SCH_CZECHITA.IMDB_RATINGS2 AS r ON t.tconst = r.tconst
WHERE startyear >= 2014
GROUP BY startyear
ORDER BY startyear desc
;

-- 2 var

SELECT startyear,prumer_za_roky, avg(prumer_za_roky) over () AS prumer_prumery
FROM

(
SELECT startyear,avg(averagerating) AS prumer_za_roky
FROM SCH_CZECHITA.IMDB_TITLES2 AS t
INNER JOIN SCH_CZECHITA.IMDB_RATINGS2 AS r ON t.tconst = r.tconst
WHERE startyear >= 2014
GROUP BY startyear
ORDER BY startyear desc

)
;