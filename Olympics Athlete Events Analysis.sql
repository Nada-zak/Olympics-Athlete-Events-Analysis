create database olympicsathlete_events;

-- 1 sports that participated in 18 or more olympics

select `Name`, count(Games) c
from athlete_events
group by `Name`
order by c desc;

select Sport
from athlete_events;


with t1 as
(select count(distinct Games) total_sum_games
from athlete_events
where Season= 'Summer'
), t2 as
(select distinct Sport, Games
from athlete_events
where season= 'Summer'
order by Games 
), t3 as
(select Sport, count(Games) count_for_each_sport
from t2
group by Sport
order by count_for_each_sport desc
)
select * 
from t3
where count_for_each_sport>= 18;

-- 2 select all athletes who won more than 2 gold medals

with t1 as
(select `Name` , count(Medal) num_of_medals
from athlete_events
where Medal= 'Gold'
group by `Name`
order by num_of_medals desc
), t2 as
(select *, dense_rank() over(order by num_of_medals desc) as rnk
from t1
)
select *
from t2
where rnk<=3 ;


-- 3 List down total gold, bronze, and silver medals won by each country

select * from athlete_events;
select * from noc_regions;

with t1 as
(select t2.region country,Medal, count(Medal) MED_CO
from athlete_events t1
join noc_regions t2
on t1.NOC = t2.NOC
where medal <> 'NA'
group by country, Medal
order by country, Medal
)
SELECT 
    country,
    SUM(CASE WHEN Medal = 'Bronze' THEN MED_CO ELSE 0 END) AS Bronze,
    SUM(CASE WHEN Medal = 'Gold' THEN MED_CO ELSE 0 END) AS Gold,
    SUM(CASE WHEN Medal = 'Silver' THEN MED_CO ELSE 0 END) AS Silver
FROM t1
GROUP BY country
order by Gold desc, Silver desc;
 
 -- 4 Identify which country won the most gold, most silver and most bronze medals in each olympic games.

select * from athlete_events;
select * from noc_regions;

with temp as
(
with t1 as
(select concat( Games, ' - ',t2.region) country_games,Medal, count(Medal) MED_CO
from athlete_events t1
join noc_regions t2
on t1.NOC = t2.NOC
where medal <> 'NA'
group by Games,t2.region, Medal
order by Games,t2.region, Medal
)
SELECT 
substr(country_games, 1 , position('-' in country_games)-1) Games,
substr(country_games , position('-' in country_games)+1) country,
    SUM(CASE WHEN Medal = 'Bronze' THEN MED_CO ELSE 0 END) AS Bronze,
    SUM(CASE WHEN Medal = 'Gold' THEN MED_CO ELSE 0 END) AS Gold,
    SUM(CASE WHEN Medal = 'Silver' THEN MED_CO ELSE 0 END) AS Silver
FROM t1
GROUP BY country_games
order by country_games
)
select  distinct Games, concat( first_value(Gold) over(partition by Games order by Gold desc),'-',
 first_value(country) over(partition by Games order by Gold desc) ) gold,
 concat( first_value(Silver) over(partition by Games order by Gold desc),'-',
 first_value(country) over(partition by Games order by Gold desc) ) silver,
 concat( first_value(Bronze) over(partition by Games order by Gold desc),'-',
 first_value(country) over(partition by Games order by Gold desc) ) bronze
from temp
order by Games;

-- 5  all Olympics games held 

select * from athlete_events;

select distinct `Year`, Season, City
from athlete_events
order by `Year`;

-- 6 total no of nations who participated in each olympics game

select * from noc_regions;
with t1 as
(select distinct Games, Region
from athlete_events t1
join noc_regions t2 on 
t1.NOC=t2.NOC
order by Games
)
select Games, count(Region) num_of_countries
from t1
group by Games
;

-- 7 the year with the highest and lowest no of countries participating in olympics

select * from noc_regions;
with t1 as
(select distinct Games, Region
from athlete_events t1
join noc_regions t2 on 
t1.NOC=t2.NOC
order by Games
), t2 as
(select Games, count(Region) num_of_countries
from t1
group by Games)
select distinct concat(first_value(Games) over(order by num_of_countries ) ,'-', first_value(num_of_countries) over(order by num_of_countries ) ) as lowest_num_of_countries,
 concat(first_value(Games) over(order by num_of_countries desc ) ,'-', first_value(num_of_countries) over(order by num_of_countries desc ) ) as highest_num_of_countries
from t2;

-- 8 countries that participated in 18 or more olympic games

select count(distinct Games)
from athlete_events;
with t1 as
(select distinct Games, region
from athlete_events t1
join noc_regions t2
on t1.noc = t2.noc), t2 as
(select region, count(Games) total_participated_games
from t1
group by region
order by total_participated_games desc
)
select * from t2
where total_participated_games >=18;

-- 9 which sports were played in only 1 game

with t1 as
(select distinct Sport, Games
from athlete_events
), t2 as
(select Sport, count(Games) num_games
from t1
group by Sport)
select t2.*, t1.Games
from t2 join t1
on t1.Sport= t2.Sport
where num_games = 1;

-- 10 no of sports played in each olympic game

with t1 as
(select distinct Games, Sport
from athlete_events)
select Games, count(Sport) coun
from t1
group by Games
order by coun desc;




