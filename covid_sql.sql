select*
from Portfolio_project..covid_deaths$
where continent is not null
order by 3,4


--select*
--from Portfolio_project..covid_vacinations$
--order by 3,4

--select data that we are going to be using

select Location,date,total_cases,new_cases,total_deaths,population
from Portfolio_project..covid_deaths$
order by 1,2

--looking at toatl cases vs total deaths

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from Portfolio_project..covid_deaths$
where location like '%india%'
order by 1,2

--looking at total cases vs population
--shows what % of population got covid

select Location,date,total_cases,population,(total_cases/population)*100 as percentpopulationinfected
from Portfolio_project..covid_deaths$
where location like '%india%'
order by 1,2

--looking at countries with highest infection rate compared to population

select Location,population,max(total_cases) as highestinfectioncount,max((total_cases/population))*100 
as percentpopulationinfected
from Portfolio_project..covid_deaths$
--where location like '%india%'
where continent is not null
group by Location,population
order by percentpopulationinfected desc

--showing countries with highest death count per population

select Location,max(cast(total_deaths as int)) as totaldeathcount
from Portfolio_project..covid_deaths$
--where location like '%india%'
where continent is not null
group by Location
order by totaldeathcount desc

--by continent

select continent, MAX(cast(total_deaths as int)) as totaldeathcount
from Portfolio_project..covid_deaths$
--where location like '%india%'
where continent is not null
group by continent
order by totaldeathcount desc


--looking total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccination

from Portfolio_project..covid_deaths$ dea
join Portfolio_project..covid_vacinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3