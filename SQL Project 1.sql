select *
from Portfolio_Project..CovidDeaths
where continent is not null
order by 3,4

--select *
--from Portfolio_Project..CovidVaccinations
--order by 3,4

--select the data that we are going to be using


select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Project..CovidDeaths
where continent is not null
order by 1,2

--Looking at total cases vs total deaths


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from Portfolio_Project..CovidDeaths
where continent is not null
order by 1,2

--Looking at total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 as infection_percentage
from Portfolio_Project..CovidDeaths
where location like'%states%'
where continent is not null
order by 1,2

--Looking at countries with highest infection rate compared to population

select location, MAX(total_cases) as CurrentCases, population, MAX((total_cases/population))*100 as currnet_infection_percentage
from Portfolio_Project..CovidDeaths
where continent is not null
group by population, location
order by currnet_infection_percentage desc

--Looking at countries with highest death rate compared to population

select location, MAX(cast(total_deaths as int)) as CurrentDeaths, population, MAX((total_deaths/population))*100 as currnet_death_percentage
from Portfolio_Project..CovidDeaths
where continent is not null
group by population, location
order by currnet_death_percentage desc

--Looking at Total Population vs Vaccinations

--Using Temp Tables


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as rollingvaccines
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	on dea.location = vac.location	
	and dea.date = vac.date
where vac.new_vaccinations is not null
--order by 2,3
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as rollingvaccines
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	on dea.location = vac.location	
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 1,2,3


--Creating Views for later visualization

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as rollingvaccines
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	on dea.location = vac.location	
	and dea.date = vac.date
where vac.new_vaccinations is not null