----/* ANALYSIS QUERIES */----

USE funding_startup;

----/* TOTAL FUNDING BY YEAR*/----

SELECT `year`, ROUND(SUM(amount), 2) AS Total_funding FROM combined_fund
GROUP BY `year`
ORDER BY `year`;

----/* YEAR ON YEAR % GROWTH IN FUNDING */----

SELECT `year`, ROUND(SUM(amount), 1) AS Total_Fund,
LAG(ROUND(SUM(amount), 1)) OVER (ORDER BY `year`) AS Pre_year_fund,
ROUND( (ROUND(SUM(amount), 1) - LAG(ROUND(SUM(amount), 1)) OVER (ORDER BY `year`))*100.0
/LAG(ROUND(SUM(amount), 1)) OVER (ORDER BY `year`),1) as YoY_Growth
FROM combined_fund
GROUP BY `year`
ORDER BY `year`;

----/* TOP 10 INDUSTRIES BY FUNDING */----

SELECT industry,ROUND(SUM(amount), 2) AS Total_funding_industry FROM combined_fund 
GROUP BY industry
ORDER BY Total_funding_industry DESC ;

----/* TOP 10 CITIES THAT RECEIVED THE MOST FUNDING OVER THE YEARS */----

SELECT city,ROUND(SUM(amount), 2) AS Total_funding_city FROM combined_fund 
GROUP BY city
ORDER BY  Total_funding_city DESC LIMIT 10;

----/* FUNDING BY INVESTMENT TYPE */----

SELECT `round`, COUNT(`round`) AS Number_of_deals FROM combined_fund
GROUP BY `round`; 

----/* TOP FUNDED STARTUPS */----

SELECT startup_name, ROUND(SUM(amount),2 ) AS funding FROM combined_fund
GROUP BY Startup_name
ORDER BY funding DESC;

----/* MOST ACTIVE INVESTORS */----

SELECT investors, COUNT(*) AS deals FROM combined_fund
GROUP BY investors
HAVING investors IS NOT NULL
ORDER BY deals DESC;

----/* NUMBER OF DEALS DONE ON YEARLY BASIS */----

SELECT `year`, COUNT(*) AS deals_in_a_year FROM combined_fund
GROUP BY `year`
ORDER BY `year` ASC;


----/* CREATED 2 SEPARATE TABLES IN ORDER TO PERFORM JOIN QUERIES */----
         
CREATE TABLE Startup_D AS
SELECT DISTINCT startup_name, industry , city FROM combined_fund;

CREATE TABLE Funding_D AS
SELECT startup_name, `year`, amount ,`round`,investors FROM combined_fund;

----/* INDUSTRY WISE FUNDING */----

SELECT sd.industry, ROUND(SUM(fd.amount),2) AS Total_ind_fund FROM startup_D sd
JOIN funding_D fd ON sd.startup_name=fd.startup_name
GROUP BY sd.industry
ORDER BY round(sum(amount),2) DESC;

----/* CITY WISE FUNDING */----

SELECT sd.city, ROUND(SUM(fd.amount),2) AS Total_city_fund FROM startup_D sd
JOIN funding_D fd ON sd.startup_name=fd.startup_name
GROUP BY sd.city
ORDER BY round(sum(amount),2) DESC;

