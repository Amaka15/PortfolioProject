/* GET DATA FROM DATABASE*/
SELECT * FROM PortifolioProject..CovidDeaths

/*TO MAKE SURE THAT DATA AM WORKING WITH I USE ORDER BY*/
SELECT * FROM PortifolioProject..CovidDeaths
ORDER BY 3,4

/* LOADING 2ND TABLE FROM DATABASE*/

--SELECT * FROM PortifolioProject..CovidVaccinations
--ORDER BY 3,4

/*SELECT DATA THAT AM GOING TO USE*/

SELECT location, date,population,total_cases, new_cases, total_deaths
FROM PortifolioProject..CovidDeaths
ORDER BY 1,2

/*TOTAL CASES VS TOTAL DEATH THIS QUERY COULDNT RUN BECAUSE THE DATA TYPES OF THE COLUMN IS IN NVARCHAR*/

SELECT location, date,total_cases, total_deaths, (total_deaths/total_cases) * 100
FROM PortifolioProject..CovidDeaths
ORDER BY 1,2

/* CHECKING FRO THE DATA TYPES BECAUSE I WAS GETTING ERROR EXECUTING THE LINE OF CODE AHEAD*/
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH AS MAX_LENGTH, 
    CHARACTER_OCTET_LENGTH AS OCTET_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeaths' 
AND COLUMN_NAME = 'total_cases';

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH AS MAX_LENGTH, 
    CHARACTER_OCTET_LENGTH AS OCTET_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeaths' 
AND COLUMN_NAME = 'total_deaths';

/* USING CAST AND FLOAT TO CONVERT IT TO INTEGER THE TOTAL DEATHS DIVIDED BT THE TOTAL CASES*/
SELECT 
    location, 
    date,
    total_cases, 
    total_deaths, 
    CASE 
        WHEN TRY_CAST(total_cases AS float) IS NOT NULL AND TRY_CAST(total_deaths AS float) IS NOT NULL
            THEN (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100
        ELSE NULL
    END AS DeathPercentage
FROM 
    PortifolioProject..CovidDeaths
ORDER BY 
    1, 2;

/* CHECKING FOR LOCATION IN Nigeria ON THEIR TOTAL CASES AND TOTAL DEATHS*/

SELECT 
    location, 
    date,
    total_cases, 
    total_deaths, 
    CASE 
        WHEN TRY_CAST(total_cases AS float) IS NOT NULL AND TRY_CAST(total_deaths AS float) IS NOT NULL
            THEN (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100
        ELSE NULL
    END AS DeathPercentage
FROM 
    PortifolioProject..CovidDeaths
	WHERE location LIKE '%nigeria%'
ORDER BY 
    1, 2;

/*TOTAL CASES OF COVID VS POPULATION IN NIGERIA*/
SELECT 
    location, 
    date,
    total_cases, 
    population, 
    CASE 
        WHEN TRY_CAST(total_cases AS float) IS NOT NULL AND TRY_CAST(population AS float) IS NOT NULL
            THEN (CAST(total_cases AS float) / CAST(population AS float)) * 100
        ELSE NULL
    END AS DeathPercentage
FROM 
    PortifolioProject..CovidDeaths
	WHERE location LIKE '%nigeria%'
ORDER BY 
    1, 2;

/*COUNTRIES WITH HIGHEST INFECTION RATE*/

SELECT 
    location, 
    population,
	MAX(total_cases) AS HighestInfection, 
    CASE 
        WHEN MAX(TRY_CAST(total_cases AS float)) IS NOT NULL AND MAX(TRY_CAST(population AS float)) IS NOT NULL
            THEN MAX((CAST(total_cases AS float) / CAST(population AS float))) * 100
        ELSE NULL
    END AS PopulationInfected
FROM 
    PortifolioProject..CovidDeaths
	--WHERE location LIKE '%states%'
	GROUP BY Location, population
ORDER BY 
    1, 2;

/* ORDER BY THE POPULATON INFECTED IN DESC*/

SELECT 
    location, 
    population,
	MAX(total_cases) AS HighestInfection, 
    CASE 
        WHEN MAX(TRY_CAST(total_cases AS float)) IS NOT NULL AND MAX(TRY_CAST(population AS float)) IS NOT NULL
            THEN MAX((CAST(total_cases AS float) / CAST(population AS float))) * 100
        ELSE NULL
    END AS PopulationInfected
FROM 
    PortifolioProject..CovidDeaths
	--WHERE location LIKE '%states%'
	GROUP BY Location, population
ORDER BY 
    PopulationInfected DESC;

/*HIGHEST COUNTRY WITH THE DEATH COUNT PER POPULATION*/
SELECT 
    location, 
	MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM 
    PortifolioProject..CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY Location
ORDER BY 
    HighestDeath DESC;


/*BREAKING THE QUERY DOWN WITH CONTINENT*/
SELECT 
    continent, 
	MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM 
    PortifolioProject..CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY continent
ORDER BY 
    HighestDeath DESC;

/*HIGHEST DEATH IN THE LOCATION*/
SELECT 
    location, 
	MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM 
    PortifolioProject..CovidDeaths
	WHERE continent IS NULL
	GROUP BY location
ORDER BY 
    HighestDeath DESC;


/*GLOBAL NUMBERS*/
SELECT 
    location, 
    date,
    total_cases, 
    total_deaths, 
    CASE 
        WHEN TRY_CAST(total_cases AS float) IS NOT NULL AND TRY_CAST(total_deaths AS float) IS NOT NULL
            THEN (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100
        ELSE NULL
    END AS DeathPercentage
FROM 
    PortifolioProject..CovidDeaths
	--WHERE location LIKE '%nigeria%'
	WHERE continent IS NOT NULL
ORDER BY 
    1, 2;

/*TOTAL NUMBERS OF */
SELECT SUM(new_cases) as Total_cases, sum(CAST(new_deaths as int)) as Total_Deaths,
SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM PortifolioProject..CovidDeaths
WHERE continent is not null
--ORDER BY 1,2



/*COVID VACCINATIONS*/

SELECT * FROM CovidVaccinations

/*JOINING TWO TABLES*/
SELECT * FROM CovidVaccinations vac
JOIN CovidDeaths dea
ON vac.location = dea.location
and vac.date = dea.date

/*total NUMBER OF PEOPLE WHO HAS VACCNATED*/
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
order by 2,3



/*BASICALLY INT WASNT WORKING*/
--SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date)
--FROM CovidDeaths dea
--JOIN CovidVaccinations vac
--ON dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    ISNULL(SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date), 0) AS cumulative_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    dea.location, dea.date;

/*TEMP TABLE*/
CREATE TABLE #Temp
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #Temp
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    ISNULL(SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date), 0) AS cumulative_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    dea.location, dea.date;

SELECT *,(RollingPeopleVaccinated/population)*100 as Results
from #Temp

/*CREATE VIEW TO STORE DATA FOR VISUALIZATION*/

CREATE VIEW PopulatedVaccine AS 
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    ISNULL(SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date), 0) AS cumulative_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
--ORDER BY 
--    dea.location, dea.date;