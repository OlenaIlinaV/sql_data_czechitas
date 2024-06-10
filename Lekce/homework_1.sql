// 1 Task

SELECT 
    COUNTRY_TXT AS ZEME
    ,DATE_FROM_PARTS(IYEAR, IMONTH, IDAY) AS DATUM
    ,COUNT(EVENTID) AS POCET_UTOKU -- celkový počet útoků
    ,SUM(COALESCE(NKILL, 0) - COALESCE(NKILLTER, 0)) AS POCET_ZABITYCH_OBETI -- počet obětí
    ,SUM(NKILLTER) AS POCET_ZABITYCH_TERORISTU -- součet mrtvých teroristů
    ,SUM(NWOUND) AS POCET_ZRANENYCH -- počet raněných
FROM TEROR
WHERE 1=1
    AND IYEAR = 2015
    --AND (COUNTRY_TXT ILIKE 'syria' OR (COUNTRY_TXT ILIKE 'iraq' OR COUNTRY_TXT ILIKE  'nigeria'))
    AND LOWER(COUNTRY_TXT) IN ('iraq','nigeria', 'syria')
GROUP BY ZEME, DATUM
HAVING POCET_UTOKU >= 10 AND POCET_ZABITYCH_OBETI >= 8
ORDER BY ZEME, DATUM
; 


// 2 Task

-- Var 1 Použila jsem LATERAL (vytvoření dodatečného sloupce - VZDALENOST)

SELECT -- explain
    COUNT(EVENTID) AS POCET_UTOKU, -- celkový počet útoků
    SUM(COALESCE(NKILL, 0) - COALESCE(NKILLTER, 0)) AS POCET_ZABITYCH_OBETI, -- počet obětí   
    
    CASE -- CASE має знаходитися всередині вибірки (SELECT) 
         WHEN VZDALENOST >= 1000 THEN '1000+ км'
         WHEN VZDALENOST >= 500 THEN '500-999 km'
         WHEN VZDALENOST >= 100 THEN '100-499 km'
         WHEN VZDALENOST >= 0 THEN '0-99 km'
         ELSE 'exact location unknown'
    END AS VZDALENOST_OD_PRAHY
       
FROM TEROR,
LATERAL (SELECT ST_DISTANCE(
        TO_GEOGRAPHY('POINT(14.4378 50.0755)'),
        TO_GEOGRAPHY('POINT('|| LONGITUDE ||' '|| LATITUDE ||')') ) / 1000 AS VZDALENOST
    ) AS SUB,
    
WHERE IYEAR BETWEEN 2014 AND 2015
GROUP BY VZDALENOST_OD_PRAHY
ORDER BY POCET_UTOKU DESC
;

-- Var 2 Použila jsem vzorec ST_DISTANCE a Vnořené SELECTy

SELECT -- explain
    COUNT(*) AS POCET_UTOKU, -- celkový počet útoků
    SUM(obeti) AS POCET_ZABITYCH_OBETI, -- počet obětí   
    VZDALENOST_OD_PRAHY
FROM (
    SELECT
        COALESCE(NKILL, 0) - COALESCE(NKILLTER, 0) as obeti,
        ST_DISTANCE(
            TO_GEOGRAPHY('POINT(14.4378 50.0755)'),
            TO_GEOGRAPHY('POINT('|| LONGITUDE ||' '|| LATITUDE ||')') ) / 1000 AS VZDALENOST,
        CASE -- CASE має знаходитися всередині вибірки (SELECT) 
             WHEN VZDALENOST >= 1000 THEN '1000+ км'
             WHEN VZDALENOST >= 500 THEN '500-999 km'
             WHEN VZDALENOST >= 100 THEN '100-499 km'
             WHEN VZDALENOST >= 0 THEN '0-99 km'
             ELSE 'exact location unknown'
        END AS VZDALENOST_OD_PRAHY
           
    FROM TEROR
    WHERE IYEAR BETWEEN 2014 AND 2015
) sub 
GROUP BY VZDALENOST_OD_PRAHY
ORDER BY POCET_UTOKU DESC
;

-- Var 3 Použila jsem vzorec HAVERSINE a Vnořené SELECTy

SELECT -- explain
    COUNT(*) AS POCET_UTOKU, -- celkový počet útoků
    SUM(obeti) AS POCET_ZABITYCH_OBETI, -- počet obětí   
    VZDALENOST_OD_PRAHY
FROM (
    SELECT
        COALESCE(NKILL, 0) - COALESCE(NKILLTER, 0) as obeti,
        HAVERSINE(50.0755, 14.4378, latitude, longitude) AS VZDALENOST, -- HAVERSINE( lat1, lon1, lat2, lon2 ), km
        CASE -- CASE має знаходитися всередині вибірки (SELECT) 
             WHEN VZDALENOST >= 1000 THEN '1000+ км'
             WHEN VZDALENOST >= 500 THEN '500-999 km'
             WHEN VZDALENOST >= 100 THEN '100-499 km'
             WHEN VZDALENOST >= 0 THEN '0-99 km'
             ELSE 'exact location unknown'
        END AS VZDALENOST_OD_PRAHY
           
    FROM TEROR
    WHERE IYEAR BETWEEN 2014 AND 2015
) sub 
GROUP BY VZDALENOST_OD_PRAHY
ORDER BY POCET_UTOKU DESC
;

-- Var 4 Použila jsem vzorec HAVERSINE a BEZ Vnořené SELECTy

SELECT
    COUNT(*) AS POCET_UTOKU, 
    SUM(COALESCE(NKILL, 0) - COALESCE(NKILLTER, 0)) AS POCET_ZABITYCH_OBETI,
   
    CASE 
        WHEN HAVERSINE(50.0755, 14.4378, latitude, longitude) >= 1000 THEN '1000+ km'
        WHEN HAVERSINE(50.0755, 14.4378, latitude, longitude) >= 500 THEN '500-999 km'
        WHEN HAVERSINE(50.0755, 14.4378, latitude, longitude) >= 100 THEN '100-499 km'
        WHEN HAVERSINE(50.0755, 14.4378, latitude, longitude) >= 0 THEN '0-99 km'
        ELSE 'exact location unknown'
    END AS VZDALENOST_OD_PRAHY
    
FROM TEROR
WHERE IYEAR BETWEEN 2014 AND 2015
GROUP BY VZDALENOST_OD_PRAHY
ORDER BY POCET_UTOKU DESC
;


// 3 Task

SELECT
    EVENTID,
    IYEAR,
    COUNTRY_TXT,
    CITY,
    ATTACKTYPE1_TXT,
    TARGTYPE1_TXT,
    GNAME,
    WEAPTYPE1_TXT,
    NKILL
FROM TEROR
--WHERE (COUNTRY_TXT ILIKE 'Afghanistan' OR COUNTRY_TXT ILIKE 'Pakistan' OR COUNTRY_TXT ILIKE  'Nigeria')
WHERE LOWER(COUNTRY_TXT) IN ('afghanistan','pakistan', 'nigeria')
    AND NOT (TARGTYPE1_TXT = 'Private Citizens & Property' AND GNAME != 'Taliban')
ORDER BY NKILL DESC NULLS LAST
LIMIT 15
;

