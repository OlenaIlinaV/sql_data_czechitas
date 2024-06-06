SELECT 1 --comment
/*comment1
coment2 */

//comment

SELECT '1';

select 2/1 + 6;

select *
from teror
;

select 
      idate
    , eventid
    , nkill
    , * exclude idate
from terror
;

select distinct country_txt, city
from teror
;

select count(distinct country_txt, city)
from teror
;

select sum(nkill)
from teror
;


select country_txt, city
from teror
order by country_txt DESC, city ASC nulls last
limit 3
;

 select count(null);
 select 3 + sum(3 + null);



 -- 1
 select * from teror;

 -- 2
 select * from teror
 limit 10;

 -- 3
 select 
     eventid,
     iyear, 
     country_txt,
     region_txt
 from teror;
 
 
 -- 4
 select distinct iyear
 from teror;

 select iyear as rok
 from teror;

 select country_txt, city as mesto
 from teror
 order by 1, mesto;


 select count(*) as pocet
 from teror;



select
    nkill,
    nwound,
    country_txt ||', '|| city as lokace,
    --concat(country_txt, ', ', city) as lokace_2,
    nkill + nwound *0.25 as metrika,
    'text' as informace
from teror
order by metrika desc nulls last
;



select *
from teror
where city = 'San Antonio'
; 

select distinct country_txt
from teror
where city = 'San Antonio' and country_txt = 'Philippines'
;

select *
from teror
where 1=1
    and city = 'San Antonio'
    and country_txt = 'Philippines'
    and nkill > 1
    and iyear = 2020
;

 
select city, count(distinct country_txt) as ruznych_mest
from teror
group by city
order by 2 desc
;


--5
select *
from teror
where iyear = 2016
;

--6
select 
    country_txt as zeme,
    region_txt as region,
    iyear as rok
from teror
where iyear = 2015
limit 10
;


--8
select distinct idate
from teror
order by idate desc
limit 20
;


--9
select count(*)
from teror
where iyear > 2015
;
