select *
from "dotace"
--limit 10
;

select *
from "registr"
;

select obec_text
from "registr"
group by obec_text
;

-- Проблема, що в таблиці маємо дублікати строк

  select "rok", "jmeno_nazev", "obec", "okres", "castka_bez_pvp", "fond_typ_podpory", "opatreni", "zdroje_cr", "zdroje_eu", "celkem_czk", "fond_typ_podpory2", "opatreni3", "celkem_czk4"
from "dotace"
group by "rok", "jmeno_nazev", "obec", "okres", "castka_bez_pvp", "fond_typ_podpory", "opatreni", "zdroje_cr", "zdroje_eu", "celkem_czk", "fond_typ_podpory2", "opatreni3", "celkem_czk4"
having count(1) > 1;

select *
from "dotace"
where "jmeno_nazev" = '" FUTUR ", s.r.o.'
and "opatreni" = '19.2.1-Podpora provádění operací v rámci komunitně vedeného'

select "jmeno_nazev", count(*) as pocet
from "dotace"
group by "jmeno_nazev"
--having count(1)<5
order by pocet desc
;

-- Проблема, що в наших двох таблицях по різному написані фірми. Немаємо ніякого іd.

SELECT *
FROM "dotace" as d
LEFT JOIN "registr" as r
ON r."FIRMA" = d."jmeno_nazev";

-- Маємо різну кількість фірм в двох таблицях, совпадіння тільки 30%

SELECT count(distinct d."jmeno_nazev") as pocetDotace, count(distinct r."FIRMA") as pocetReg, 
count(distinct r."FIRMA")/count(distinct d."jmeno_nazev")
FROM "dotace" as d
LEFT JOIN "registr" as r
ON r."FIRMA" = d."jmeno_nazev";

-- В регістре є фірми які вказані більше ніж 1 раз

select firma, count(1)
from "registr" as r
where firma in (select distinct "jmeno_nazev" from "dotace")
group by firma
having count(1) >1
;

select *
from "registr" as r
where firma = 'AVENA, spol. s r.o.'
;

select ICO, count(distinct FIRMA) as pocet
from "registr" as r
group by ICO
having pocet > 1
;

select *
from "registr" as r
inner join "registr" as r2
on r.FIRMA = replace(r2.FIRMA, '"', '')
where r.FIRMA != r2.FIRMA; -- <> не ровно

select *
from "registr" as r
where replace(r.FIRMA, '"', '')= 'Zemědělské družstvo Vysočina';

-- Перевіряємо, що деякі фірми повторюються, але один раз з кавичками а другий - без
select replace("jmeno_nazev",'"', '') as nazev, count(distinct "jmeno_nazev") as pocet
from "dotace"
group by nazev
having pocet >1;