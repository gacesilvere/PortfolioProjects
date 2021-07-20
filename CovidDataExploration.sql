--Select * 
--From PortfolioProject..CovidDeaths

--Order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select data that I will be using here

Select location, date,total_Cases, new_cases, total_deaths,population 
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at Total cases vs Total deaths of Covid19 in United States

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
Order by 1,2

--Shows what percentage of population got Covid19 in United States

Select location, date, Population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location like '%states%'
Order by 1,2

 
 --Loking at countries with Highest Infection Rate compared to Population

 Select location,Population, Max(total_cases) as HighestInfection,Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
Group by location,population
Order by PercentPopulationInfected desc


--Showing countries with Highest death Count 

 Select location,Max(cast(total_deaths as int)) as HighestDeath
From PortfolioProject..CovidDeaths
Where continent is not Null
Group by location
Order by HighestDeath desc

--Showing Highest death Count per continent

 Select location,Max(cast(total_deaths as int)) as HighestDeath
From PortfolioProject..CovidDeaths
Where continent is Null
Group by location
Order by HighestDeath desc


--Showing Total death Count by countries

 Select location,Sum(cast(total_deaths as int)) as TotalDeathPerCountry
From PortfolioProject..CovidDeaths
Where continent is not Null
Group by location
Order by TotalDeathPerCountry desc

--Showing Total death Count by continents

 Select location,Sum(cast(total_deaths as int)) as TotalDeathPerContinent
From PortfolioProject..CovidDeaths
Where continent is Null
Group by location
Order by TotalDeathPerContinent desc

--Showing Total death Count in United States

 Select location,Sum(cast(total_deaths as int)) as TotalDeath_USA
From PortfolioProject..CovidDeaths
Where location like '%states%'
Group by location

--Global numbers

 Select SUM(new_cases) as TotalCases, location,Sum(cast(total_deaths as int)) as TotalDeathPerContinent
From PortfolioProject..CovidDeaths
Where continent is Null
Group by location
Order by TotalDeathPerContinent desc


--Looking a total population vs vaccinations


With PopvsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)--Use CTE
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated

(Continent nvarchar (255), Location nvarchar (255), Date datetime, Population numeric, New_Vacinations numeric, RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



--CREATING VIEWS

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3


--CREATING VIEW 2

Create view GlobalNumber as

 Select SUM(new_cases) as TotalCases, location,Sum(cast(total_deaths as int)) as TotalDeathPerContinent
From PortfolioProject..CovidDeaths
Where continent is Null
Group by location
--Order by TotalDeathPerContinent desc




--Select Command on Views created

Select * 
From PercentPopulationVaccinated


Select * 
From GlobalNumber