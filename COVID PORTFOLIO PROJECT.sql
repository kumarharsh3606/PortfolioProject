SELECT * FROM coviddeaths
ORDER BY 3,4;
SELECT * FROM covidvaccinations
ORDER BY 3,4 ;

SELECT LOCATION, DATE, total_cases,new_cases,total_deaths,population
FROM coviddeaths
ORDER BY 1,2 ;
----------------------------------------------------------------------------------------------------------------------------
-- LOOKING AT PER DAY TOTAL CASES VS TOTAL DEATHS
-- SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY

SELECT LOCATION, DATE, POPULATION, TOTAL_CASES, TOTAL_DEATHS,
(TOTAL_DEATHS)/(TOTAL_CASES) * 100 as DEATHPERCENTAGE
FROM coviddeaths
WHERE LOCATION = 'INDIA';

-- LOOKING AT MONTH WISE TOTAL CASES VS TOTAL DEATHS

SELECT LOCATION, monthname(DATE) AS MONTH, POPULATION, sum(total_cases) AS TOTALCASES, sum(TOTAL_DEATHS) AS TOTALDEATHS,
SUM(TOTAL_DEATHS)/SUM(TOTAL_CASES) * 100 as DEATHPERCENTAGE
FROM coviddeaths
WHERE LOCATION = 'INDIA'
GROUP BY 1,2,3;

-- LOOKING AT YEAR WISE TOTAL CASES VS TOTAL DEATHS

SELECT LOCATION, YEAR(DATE) AS YEAR, POPULATION, sum(total_cases) AS TOTALCASES, sum(TOTAL_DEATHS) AS TOTALDEATHS,
SUM(TOTAL_DEATHS)/SUM(TOTAL_CASES) * 100 as DEATHPERCENTAGE
FROM coviddeaths
WHERE LOCATION = 'INDIA'
GROUP BY 1,2,3
ORDER BY YEAR;
--------------------------------------------------------------------------------------------------------------------------------
-- LOOKING AT TOTAL CASES VS POPULATION
-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID

SELECT LOCATION, DATE , POPULATION, total_cases, (TOTAL_CASES/POPULATION) * 100 as CASEPERCENTAGE
FROM coviddeaths
WHERE LOCATION = 'INDIA'; 
---------------------------------------------------------------------------------------------------------------------------

-- LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT LOCATION,POPULATION, max(TOTAL_CASES) AS HIGHESTCASE, MAX((TOTAL_CASES/POPULATION)*100) AS CASEPERCENTAGE
FROM coviddeaths
group by 1,2
ORDER BY 4 DESC;
----------------------------------------------------------------------------------------------------------------------------

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT LOCATION, max(TOTAL_deaths) as HIGHESTDEATHS
FROM COVIDDEATHS 
where continent is not null
GROUP BY location
order by highestdeaths desc;
--------------------------------------------------------------------------------------------------------------
-- REPLACE BLANK VALUES WITH NULL
SET SQL_SAFE_UPDATES=0;   
set autocommit=0;
start transaction;
SAVEPOINT A;
UPDATE coviddeaths SET CONTINENT = null WHERE CONTINENT = "";
SAVEPOINT B;
UPDATE coviddeaths SET TOTAL_DEATHS = null WHERE TOTAL_DEATHS = "";
UPDATE coviddeaths SET NEW_DEATHS = null WHERE NEW_DEATHS = "";
COMMIT ;

-- CHANGE THE DATA TYPE OF COLUMNS FROM TEXT TO INTEGER TO GET THE CORRECT OUTPUT FOR ABOVE QUERRY
alter table coviddeaths MODIFY total_deaths INT;
alter table coviddeaths MODIFY new_deaths INT;
DESC COVIDDEATHS;
---------------------------------------------------------------------------------------------------------------------------

-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT CONTINENT, max(TOTAL_deaths) as HIGHESTDEATHS
FROM COVIDDEATHS 
WHERE CONTINENT IS NOT NULL
GROUP BY 1
order by highestdeaths desc;
--------------------------------------------------------------------------------------------------------------------------

-- GLOBAL NUMBERS

SELECT DATE, sum(NEW_CASES) AS TOTALCASES, sum(NEW_DEATHS) AS TOTALDEATHS,
(sum(NEW_DEATHS)/sum(NEW_CASES))*100 AS DEATHPERCENTAGE
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 1 ;

--------------------------------------------------------------------------------------------------------------------------------
-- LOOKING AT TOTAL VACCINATION VS POPULATION

SELECT X.*, (TOTALVACCINATIONS/POPULATION)*100 AS VACCINATIONPERCENTAGE
FROM (SELECT D.continent, D.LOCATION,D.DATE, D.POPULATION, C.NEW_VACCINATIONS,
SUM(C.NEW_VACCINATIONS) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION, D.DATE) AS TOTALVACCINATIONS
FROM coviddeaths AS D  JOIN  covidvaccinations AS C
ON D.LOCATION = C.location AND D.DATE = C.DATE
WHERE D.CONTINENT IS NOT NULL) AS X
ORDER BY 2,3;		
-------------------------------------------------------------------------------------------------------------------------

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PERCENTAGEPEOPLEVACCINATED AS 
SELECT X.*, (TOTALVACCINATIONS/POPULATION)*100 AS VACCINATIONPERCENTAGE
FROM (SELECT D.continent, D.LOCATION,D.DATE, D.POPULATION, C.NEW_VACCINATIONS,
SUM(C.NEW_VACCINATIONS) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION, D.DATE) AS TOTALVACCINATIONS
FROM coviddeaths AS D  JOIN  covidvaccinations AS C
ON D.LOCATION = C.location AND D.DATE = C.DATE
WHERE D.CONTINENT IS NOT NULL) AS X ;

SELECT * FROM percentagepeoplevaccinated;