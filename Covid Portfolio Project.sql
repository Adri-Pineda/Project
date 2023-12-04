Select *
From ProjectPortfolio..CovidDeaths
Order by 3,4

--Select *
--From ProjectPortfolio..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases,total_deaths,population
From ProjectPortfolio..CovidDeaths
Order by 1,2


--Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, 
(Convert(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths
order by 1,2 

--Total Cases vs Population

ALTER TABLE ProjectPortfolio..CovidDeaths
ALTER COLUMN population bigint;

--Percentage of the population that has gotten covid

Select location, date, total_cases, population, 
(Convert(float,total_cases)/NULLIF(CONVERT(float,population),0))*100 as Percent_Infected
From ProjectPortfolio..CovidDeaths
order by 1,2 

--Countries with highest infection rate

Select location, population, MAX(total_cases) as highest_infection_count
From ProjectPortfolio..CovidDeaths
Group by location, population
Order by highest_infection_count desc

--Countries with highest death count

Select location, MAX(total_deaths) as total_death_count
From ProjectPortfolio..CovidDeaths
Group by location
order by total_death_count desc


--Global numbers

Select date, location,
(Convert(float,new_deaths)/NULLIF(CONVERT(float,new_cases),0))*100 as Death_Percent
From ProjectPortfolio..CovidDeaths
order by 1,2 

--Total Population vs Vaccinations

Select *
From ProjectPortfolio..CovidDeaths deaths
join ProjectPortfolio..CovidVaccinations vaccines
 On deaths.location = vaccines.location
 and deaths.date = vaccines.date

 Select deaths.continent,deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations
 From ProjectPortfolio..CovidDeaths deaths
 join ProjectPortfolio..CovidVaccinations vaccines
  On deaths.location = vaccines.location
  and deaths.date = vaccines.date
Where deaths.continent is not null
order by 2,3


--CTE
With PopulationvsVaccinations(Continent,location,date,population,new_vaccinations,sum_daily_vaccines)
as
(
Select deaths.continent,deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations,
SUM(CONVERT(int,deaths.new_vaccinations)) OVER (Partition by deaths.location order by deaths.location,deaths.date) as sum_daily_vaccine
 From ProjectPortfolio..CovidDeaths deaths
 join ProjectPortfolio..CovidVaccinations vaccines
  On deaths.location = vaccines.location
  and deaths.date = vaccines.date
Where deaths.continent is not null
--order by 2,3
)
Select *, (Convert(float,sum_daily_vaccines/nullif(Convert(float,population),0))* 100) as Percentage
From PopulationvsVaccinations

