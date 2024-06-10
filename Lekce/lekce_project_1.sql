-- Подивитись таблицю "DobijeciStanice"

SELECT *
FROM "DobijeciStanice"
;

SELECT "obec", count("Provozovatel_dobijeci_stanice")
FROM "DobijeciStanice"
WHERE "obec" IN ('Praha 5', 'Praha 9', 'Praha 8' )
GROUP BY "obec"
;

SELECT *
FROM "DobijeciStanice"
ORDER BY "Dat_Prov"
LIMIT 10
;

select *
from "DobijeciStanice"
where "ulice" = 'Za Brumlovkou 5'
;


-- Подивитись таблицю "RegistrVozidel"

SELECT *
FROM "RegistrVozidel"
;

SELECT min(to_date(substr("prvni_registrace", 1,10), 'DD.MM.YYYY'))
FROM "RegistrVozidel"
;

-- problem 1 - необхідно замінити коми на крапки, для того, щоб можно було використовувати для математичних рахувань
-- problem 2 - необхідність переводу дати в один формат

select min(to_date("Dat_Prov", 'dd.mm.yyyy')), max(to_date("Dat_Prov", 'dd.mm.yyyy'))
from "DobijeciStanice"
;

select *
from "DobijeciStanice"
where "severni_sirka" = ''
;

select "severni_sirka" :: float, "vychodni_delka" :: float
from "Souradnice"
;

-- Вставляємо в кебулу

UPDATE "Souradnice"
SET "severni_sirka" = replace("severni_sirka", ',','.'),
    "vychodni_delka" = replace("vychodni_delka", ',','.')
;

UPDATE "Souradnice"
SET "severni_sirka" = replace("severni_sirka", 'N',' '),
    "vychodni_delka" = replace("vychodni_delka", 'E',' ')
;

UPDATE "Souradnice"
SET "severni_sirka" = "vychodni_delka",
    "vychodni_delka" = "severni_sirka"
WHERE "severni_sirka"::float < 30
AND "severni_sirka"::float > 0;

select *
from "Souradnice"
where  "vychodni_delka" > 30
;

delete
from "Souradnice"
where "radek_c" = 1323
;

--Створюємо нову таблицю після очищення дат

CREATE OR REPLACE TABLE "outDobijeciStanice" AS
SELECT "ulice", "PSC", "obec", "severni_sirka", "vychodni_delka", min(to_date("Dat_Prov",'DD.MM.YYYY')) as "uvedeni", count(*) as "pocet_mist" -- дата на минимум дозволяє отримати один рядок по заправці (ізначально там декілько дат)
FROM "Souradnice"
GROUP BY "ulice", "PSC", "obec", "severni_sirka", "vychodni_delka";

DROP TABLE outRegistrVozidel;

CREATE TABLE "outRegistrVozidel" AS
SELECT     "rok_vyroby",
    "stav",
    to_date(substr("prvni_registrace",1,10),'DD.MM.YYYY') as "prvni_registrace",
    to_date(substr("prvni_registrace_CR",1,10),'DD.MM.YYYY') as "prvni_registrace_CR",
    "druh",
    "druh_2r",
    "kategorie",
    "obchodni_oznaceni",
    "vin",
    "vyrobce_vozidla",
    "motor_vyrobce",
    CASE WHEN "palivo" = 'Elektropohon' then 'Elektroauto' else 'Hybrid' end as typAuta,
    "mist_celkem",
    "barva"
FROM "RegistrVozidel"
WHERE to_date(substr("prvni_registrace",1,10),'DD.MM.YYYY') > to_date('01.01.1962', 'DD.MM.YYYY');



CREATE TABLE "Calendar" AS 
WITH RECURSIVE Calendar AS (
  SELECT DATE '2011-01-01' AS date -- Zde specifikujte počáteční datum
  UNION ALL
  SELECT date + INTERVAL '1 day' FROM Calendar
  WHERE date < DATE '2023-10-31' -- Zde specifikujte konečný datum
)
SELECT date
FROM Calendar;

KEBOOLA_WORKSPACE_70890095
25Ur37vdqxnDHsB9NJmELS8PYsRPpzoS

