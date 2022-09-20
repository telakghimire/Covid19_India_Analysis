Use Covid19;


/** Month with % values**/
with proper_data as
(
Select state,state_short,month_name,year_name,month_number,state_total_population,SUM(confirmed) as confirmed, SUM(recovered) as recovered, SUM(deceased) as deceased, SUM(tested) as tested, SUM(vaccinated_1) as vaccinated_1, SUM(vaccinated_2) as vaccinated_2 from (select d.state,d.state_short,s.state_total_population,isnull(d.total_confirmed - LAG(d.total_confirmed) over(Partition By d.state_short order by d.state_short,date),MIN(d.total_confirmed) over(Partition by d.state_short)) as confirmed,
isnull(d.total_recovered - LAG(d.total_recovered) over(Partition By d.state_short order by d.state_short,date),MIN(d.total_recovered) over(Partition by d.state_short)) as recovered,
isnull(d.total_deceased - LAG(d.total_deceased) over(Partition By d.state_short order by d.state_short,date),MIN(d.total_deceased) over(Partition by d.state_short)) as deceased,
isnull(d.total_tested - LAG(d.total_tested) over(Partition By d.state_short order by d.state_short,date),MIN(d.total_tested) over(Partition by d.state_short)) as tested,
isnull(d.total_vaccinated_1 - LAG(d.total_vaccinated_1) over(Partition By d.state_short order by d.state_short,date),MIN(d.total_vaccinated_1) over(Partition by d.state_short)) as vaccinated_1,
isnull(d.total_vaccinated_2 - LAG(d.total_vaccinated_2) over(Partition By d.state_short order by d.state_short,date),MIN(d.total_vaccinated_2) over(Partition by d.state_short)) as vaccinated_2,
DATENAME(Month,d.date) as month_name,Month(d.date) as month_number,DATENAME(YEAR,d.date) as year_name from date_total_df d join states_total_df s on s.state_short=d.state_short) s
Group By state,state_short,month_number,month_name,year_name,state_total_population),

cte as
(
Select *,Round((Cast([state_total_confirmed] as float)/Cast([state_total_population] as float)),4)*100 as [Population_Effected_%],
Round((Cast([state_total_recovered] as float)/Cast([state_total_confirmed] as float)),4)*100 as [Recovery_%],
Round((Cast([state_total_deceased] as float)/Cast([state_total_confirmed] as float)),4)*100 as [Death_%],
Round((Cast([state_total_vaccinated_1] as float)/Cast([state_total_population] as float)),4)*100 as [Vaccinated1_%],
Round((Cast([state_total_vaccinated_2] as float)/Cast([state_total_population] as float)),4)*100 as [ Vaccinated2_%] from  
(select s.state as state_name,s.state_short,s.state_total_population,t.total_confirmed as state_total_confirmed,s.state_total_deceased,s.state_total_recovered,s.state_total_tested
,s.state_total_vaccinated_1,s.state_total_vaccinated_2 from (Select *,ROW_NUMBER() over(Partition by state Order by total_confirmed desc) as row  from date_total_df) t join states_total_df s
ON t.state_short = s.state_short
where row = 1) c )


Select pd.state,pd.state_short,pd.state_total_population,pd.month_name,pd.year_name,pd.confirmed,pd.deceased,pd.tested,pd.recovered,pd.vaccinated_1,pd.vaccinated_2,
ct.[Population_Effected_%],ct.[Recovery_%],ct.[Death_%],ct.[Vaccinated1_%],ct.[ Vaccinated2_%] 
from proper_data pd join cte ct on pd.state_short = ct.state_short 
Order by pd.state_short,pd.year_name,pd.month_number;

/** Month And Year  **/
with proper_data as
(select state_short,date,isnull(total_confirmed - LAG(total_confirmed) over(Partition By state_short order by state_short,date),MIN(total_confirmed) over(Partition by state_short)) as confirmed,
isnull(total_recovered - LAG(total_recovered) over(Partition By state_short order by state_short,date),MIN(total_recovered) over(Partition by state_short)) as recovered,
isnull(total_deceased - LAG(total_deceased) over(Partition By state_short order by state_short,date),MIN(total_deceased) over(Partition by state_short)) as deceased,
isnull(total_tested - LAG(total_tested) over(Partition By state_short order by state_short,date),MIN(total_tested) over(Partition by state_short)) as tested,
isnull(total_vaccinated_1 - LAG(total_vaccinated_1) over(Partition By state_short order by state_short,date),MIN(total_vaccinated_1) over(Partition by state_short)) as vaccinated_1,
isnull(total_vaccinated_2 - LAG(total_vaccinated_2) over(Partition By state_short order by state_short,date),MIN(total_vaccinated_2) over(Partition by state_short)) as vaccinated_2,
DATENAME(Month,date) as month_name,Month(date) as month_number,DATENAME(YEAR,date) as year_name from date_total_df)

Select month_name,year_name,month_number,SUM(confirmed)as confirmed ,SUM(recovered) as recovered, SUM(deceased) as deceased, SUM(tested) as tested, SUM(vaccinated_1) as vaccinated_1, SUM(vaccinated_2) as vaccinated_2 from proper_data
Group By month_number,month_name,year_name
Order by year_name,month_number;

/** Joining confirmed with state_total  **/

with timeseries as 
(Select *,ROW_NUMBER() over(Partition by state Order by total_confirmed desc) as row  from date_total_df)

select s.state as state_name,s.state_short,s.state_total_population,t.total_confirmed as state_total_confirmed,s.state_total_deceased,s.state_total_recovered,s.state_total_tested
,s.state_total_vaccinated_1,s.state_total_vaccinated_2 from timeseries t join states_total_df s
ON t.state_short = s.state_short
where row = 1;


Select * From TimeSeries_Data;

--- Creating Year Column
Alter Table TimeSeries_Data Add Year int;
Update TimeSeries_Data Set Year= Year(Date);

---Creating MonthNumber column
Alter Table TimeSeries_Data Add MonthNumber int;
Update TimeSeries_Data Set MonthNumber= Month(Date);

---Creating Month Column
Alter Table TimeSeries_Data Add Month varchar(50);
Update TimeSeries_Data Set Month= Case
When Month(Date)=1 then 'January'
When Month(Date)=2 then 'February'
When Month(Date)=3 then 'March'
When Month(Date)=4 then 'April'
When Month(Date)=5 then 'May'
When Month(Date)=6 then 'June'
When Month(Date)=7 then 'July'
When Month(Date)=8 then 'August'
When Month(Date)=9 then 'September'
When Month(Date)=10 then 'October'
When Month(Date)=11 then 'November'
When Month(Date)=12 then 'December'
End;


Select Date, DATEPART(WEEK, Date)  - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,Date), 0))+ 1 From TimeSeries_Data;
---Creating WeekNumber Column
Alter Table TimeSeries_Data Add WeekNumber varchar(50);
Update TimeSeries_Data Set WeekNumber= DATEPART(WEEK, Date) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM,0,Date), 0))+ 1;


---Creating Month_WeekNumber Column
Alter Table TimeSeries_Data Drop Column Month_WeekNumber,
Alter Table TimeSeries_Data Add Month_WeekNumber varchar(50);
Update TimeSeries_Data Set Month_WeekNumber = concat(Month,'-','Week ',WeekNumber);

Select * From TimeSeries_Data;


---Segregating the cummulative data for each date
Select * into TimeSeries_Data2 From 
(Select State,Date,isnull(Confirmed - LAG(Confirmed) over(Partition By State order by State,date),MIN(Confirmed) over(Partition by State)) as Confirmed,
isnull(Recovered - LAG(Recovered) over(Partition By State order by State,date),MIN(Recovered) over(Partition by State)) as Recovered,
isnull(Deceased - LAG(Deceased) over(Partition By State order by State,date),MIN(Deceased) over(Partition by State)) as Death,
isnull(Tested - LAG(Tested) over(Partition By State order by State,date),MIN(Tested) over(Partition by State)) as Tested,
Year,MonthNumber,Month,WeekNumber,Month_WeekNumber from TimeSeries_Data) S;


Select * From TimeSeries_Data2
Order By State,Date;

---Aggregating the data according to WeekNumber
Select Year,MonthNumber,Month_WeekNumber,Sum(Confirmed) As Confirmed,Sum(Recovered) As Recovered,Sum(Death) As Deaths,Sum(Tested) As Tested
From TimeSeries_Data2
Group By Year,MonthNumber,Month_WeekNumber
Order By Year,MonthNumber,Month_WeekNumber;

---Aggregating the data according to month(extra)
Select Year,MonthNumber,Month,Sum(Confirmed) As Confirmed,Sum(Recovered) As Recovered,Sum(Death) As Deaths,Sum(Tested) As Tested
From TimeSeries_Data2
Group By Year,MonthNumber,Month
Order By Year,MonthNumber;

Select * from DistrictWise_Data;

---Creating the Testing Ratio Table
Alter Table DistrictWise_Data Add [TestingRatio(tr)] float;
Update DistrictWise_Data Set [TestingRatio(tr)] = Round((Cast([Tested] as float)/Cast([Population] as float)),2);

---Creating the Category Table
Alter Table DistrictWise_Data Add Category varchar(50);
Update DistrictWise_Data Set Category = Case
When [TestingRatio(tr)] between 0.0 and 0.1 then 'Category A'
When [TestingRatio(tr)] between 0.11 and 0.3 then 'Category B'
When [TestingRatio(tr)] between 0.31 and 0.5 then 'Category C'
When [TestingRatio(tr)] between 0.51 and 0.75 then 'Category D'
When [TestingRatio(tr)] between 0.76 and 0.1 then 'Category E'
Else null
end;

Select * from DistrictWise_Data;

---Grouping by Category
Select Category, Avg(Population) as Avg_Population, Avg(Confirmed) As Avg_Confirmed,Avg(Recovered) As Avg_Recovered,Avg(Deceased) As Avg_Deaths,Avg(Tested) As Avg_Tested, Round(Avg([TestingRatio(tr)]),2) as Avg_TestingRatio
From DistrictWise_Data
Where Category is not null
Group By Category
Order By Category;

---Creating the Category Table
Select * into Category_table From
(Select Category, Avg(Population) as Avg_Population, Avg(Confirmed) As Avg_Confirmed,Avg(Recovered) As Avg_Recovered,Avg(Deceased) As Avg_Deaths,Avg(Tested) As Avg_Tested, Round(Avg([TestingRatio(tr)]),2) as Avg_TestingRatio
From DistrictWise_Data
Where Category is not null
Group By Category) s;

Select * from Category_table;

Select *, Round(Cast(Avg_Deaths as float)/Cast(Avg_Confirmed as float)*100,2) as [Death %] from Category_table;

select state, sum(population) as Population,sum(confirmed) as Confirmed,sum(deceased) as Deceased,sum(recovered) as Recovered,sum(tested) as Tested,sum(vaccinated1) as Vaccinated1,
sum(vaccinated2) as Vaccinated2 from delta7_district_cleaned group by state

--correlation with doeses and deceased
select state,sum(deceased) as Deceased,sum(vaccinated1 + vaccinated2) as 'Dual Doses' from delta7_district_cleaned group by state

--correlation between confirmed cases and deceased cases
select state,sum(confirmed) as Confirmed , sum(deceased) as Deceased from  delta7_district_cleaned group by state

--correlation between vaccinted 1 and deceased
select state,sum(vaccinated1) as Vaccinated,sum(deceased) as deceased from   delta7_district_cleaned group by state

select state,sum(tested) as Tested,sum(confirmed) as Confirmed   from   delta7_district_cleaned group by state


select state,sum(confirmed) as Confirmed,sum(recovered) as Recovered from delta7_district_cleaned group by state

-- delta 7 wrt vaccination
select state, sum(confirmed) as Confirmed, sum(vaccinated1 + Vaccinated2) as Fully_Vaccinated from delta7_district_cleaned group by state

select state, sum(confirmed) as Confirmed, sum(Vaccinated1) as Vaccinated from delta7_district_cleaned group by state

select state, sum(confirmed) as Confirmed, sum(Vaccinated2) as Vaccinated from delta7_district_cleaned group by state

