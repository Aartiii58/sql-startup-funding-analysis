----/* DATA CLEANING QUERIES */----

use funding_startup;
SET sql_safe_updates=0;

----/* EXTRACTING YEAR FROM DATE  */----

SELECT * FROM newfund;
ALTER TABLE newfund
ADD COLUMN YEAR INT;

UPDATE newfund
SET YEAR = RIGHT(DATE,4);

SELECT * FROM newfund
ORDER BY YEAR ASC;

----/* HANDLING INCONSISTENCIES */----

UPDATE newfund
SET startup = lower(trim(startup)),
	industry = lower(trim(industry)),
    city = lower(trim(city)),
    investors = lower(trim(investors)),
    investmentType = lower(trim(investmentType));
    
SELECT * FROM oldfund;   
UPDATE oldfund
SET startup = lower(trim(startup)),
	vertical = lower(trim(vertical)),
    city = lower(trim(city)),
    investors = lower(trim(investors)),
    `round` = lower(trim(`round`));
    
SELECT * FROM oldfund;
UPDATE oldfund
SET investors= NULL WHERE investors IN ('not disclosed','undisclosed','undisclosed investors');

UPDATE oldfund
SET `round`= NULL WHERE `round`= 'undisclosed';    
    

UPDATE oldfund
SET `round`= CASE
             WHEN `round` IN ('seed','seed round','seed funding') THEN 'seed funding'
             WHEN `round` IN ('private funding','private equity','privateequity','private')THEN 'private equity'
             WHEN `round` LIKE 'equity%' THEN 'equity funding'
             WHEN `round` IN ('venture','venture round') THEN 'venture round'
             WHEN `round` IN ('debt','debt financing','debt-funding') THEN 'debt funding'
             WHEN `round` IN ('angel','angel round','angel funding') THEN 'angel funding'
             WHEN `round` IN ('seed / angle funding','seed / angel funding','seed/angel funding','seed/ angel funding','angel / seed funding') THEN 'seed/angel funding'
			 WHEN `round` IN ('pre series a','pre-series a') THEN 'pre-series a'
             ELSE `round`
             END;


UPDATE oldfund
SET city = 'bangalore' WHERE city IN ('bengaluru','bangaluru','bangalore');
             

----/* DELETION OF COLUMNS*/----

ALTER TABLE oldfund
DROP COLUMN `Sr No`;

ALTER TABLE oldfund
DROP COLUMN state;

----/* COMBINING THE REQUIRED DATA FIELDS OF THE TWO TABLES*/----

CREATE TABLE combined_fund AS
SELECT startup AS Startup_name,vertical AS industry,city, investors, `round`, `year`, amount AS 'amount' FROM oldfund
UNION ALL
SELECT startup AS startup_name, industry,city,investors,InvestmentType AS `round`,`year`,InvestmentAmount_USD/1000000 AS 'amount' FROM newfund;
select * from combined_fund;

----/* HANDLING INCONSISTENCIES IN THE COMBINED DATASET */----

UPDATE combined_fund
SET `round`= CASE
             WHEN `round` IN ('bridge','bridge round') THEN 'bridge round'
             WHEN `round` IN ('angel funding','angel')THEN 'angel funding'
             WHEN `round` IN ('debt funding','debt')THEN 'debt funding'
             WHEN `round` IN ('seed funding','seed')THEN 'seed funding'
             ELSE `round`
             END;
            select distinct investors From oldfund;
            select * from oldfund;