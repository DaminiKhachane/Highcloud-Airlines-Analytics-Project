SELECT * FROM maindata;
    
--  Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats) 
-- Yearly
    with load_Factor_percentage_yearly as 
    (select year ,
    sum(Transported_passengers/Available_seats) as Load_Factor ,
    sum(sum(Transported_passengers/Available_seats)) over () as Grand_Total
    from maindata group by year)
    select year,
    round((Load_Factor/Grand_Total)*100,2) as Load_Factor 
    from Load_Factor_percentage_yearly;
    
--  Quarterly

with Load_Factor_percentage_Quarterly as(select cast(concat(year,"-",month,"-",day) as date) as date_field,
sum(Transported_passengers/Available_seats) as Load_Factor ,
    sum(sum(Transported_passengers/Available_seats)) over () as Grand_Total from maindata group by year,month,day)
    
    select Year(date_field),quarter(Date_field) as Quarters,round((sum(Load_Factor)/max(Grand_Total))*100,2) as Load_Factor  
    from Load_Factor_percentage_Quarterly group by Year(date_field),quarter(Date_field);
    
    
-- Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)
with load_Factor_percentage_on_a_Carrier_Name as (select carrier_name,sum(Transported_passengers / Available_seats) as Load_factor,
sum(sum(Transported_passengers / Available_seats)) over () as Grand_Total from maindata group by carrier_name)
select carrier_name,round((load_factor/grand_Total)*100,2) as Load_factor from load_Factor_percentage_on_a_Carrier_Name
order by load_factor desc;


-- Identify Top 10 Carrier Names based passengers preference 
with passengers_preference_by_carrier_name as(select carrier_name,sum(Transported_passengers)as 
passengers_preference from maindata group by carrier_name)
select carrier_name, passengers_preference  from passengers_preference_by_carrier_name 
order by passengers_preference  desc limit 10;
    
  --  Display top Routes ( from-to City) based on Number of Flights 
 with top_Routes_from_to_City as ( select From_To_City, count(Airline_ID)
 as Total_Number_of_Flights  from maindata group by From_To_City)
 select From_To_City,Total_Number_of_Flights from top_Routes_from_to_City 
 order by Total_Number_of_Flights desc limit 10;
 
 
 --  Identify the how much load factor is occupied on Weekend vs Weekdays. load_factor_of_weekend_and_weekday
with dates as( select cast(concat(year,"-",month,"-",day) as date) as Date_field
 from maindata),
load_factor_of_weekend_and_weekday as (select case
            WHEN DAYOFWEEK(Date_Field) IN (1, 7) THEN 'Weekend' 
            ELSE 'Weekday'
        END AS DayType,
        sum(Transported_passengers/Available_seats) as Load_Factor ,
    sum(sum(Transported_passengers/Available_seats)) over () as Grand_Total
    from   maindata as m
    join dates as d on m.year=year(d.date_field)
    and m.month=month(d.date_field)
    and m.day=day(d.date_field)
    group by daytype)
    select daytype,  round((Load_Factor/Grand_Total)*100,2) as Load_Factor 
    from load_factor_of_weekend_and_weekday order by load_factor desc ;
   
-- Identify number of flights based on Distance groups Distance_Group_ID Distance_Interval

SELECT 
    d.Distance_Interval AS Distance_Intervals,
    COUNT(m.Airline_ID) AS number_of_flights
FROM
    maindata AS m
        JOIN
    distance_groups AS d ON m.Distance_Group_ID = d.Distance_Group_ID
GROUP BY d.Distance_Interval;







  