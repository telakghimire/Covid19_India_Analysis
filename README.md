# Covid19_India_Analysis


**Objective**

- To understand the behavior of Covid19 cases and its effects across India.
- Extracting data from the website and performing Data Preparation and Cleaning for further analysis.
- To Analyze the weekly and monthly evolution of the number of confirmed cases, recovered cases, deaths, tests, and vaccination across India and also analyze the severity of cases in different states of India.

**Technology Stack**
- Python used for data extraction and data cleaning.
- SQL used for analysis .
- MS-Excel used for visualization and dashboard.

**Dataset Description**

The data was exctracted from the website (https://data.covid19india.org/) containing two json files namely data.min.json and timeseries.min.json.
![image](https://user-images.githubusercontent.com/108783182/191178291-c6286538-05a4-4421-8851-2ed54c318ade.png)

***Click on the below link to know more about the struture of the data***
- data.min.json: (https://data.covid19india.org/documentation/v4_data.html)
- timeseries.min.json: (https://data.covid19india.org/documentation/timeseries.min.html)

***From the above json files we have created six dataframes or tables for our anlysis by extracting the data from the json file-***
- StateWise_Data containing the attributes - State, Population, Confirmed, Deceased, Tested, Vaccination1, Vaccinated2.
- DistrictWise_Data containing the attributes - State, Disticts, Population, Confirmed, Deceased, Tested, Vaccination1, Vaccinated2. Here the data was in cummulative sum, where we needed to segregate it.
- TimeSeries_Data containing the attributes - State, Date, Confirmed, Deceased, Tested, Vaccination1, Vaccinated2.

**Problem Statement**

     - Weekly evolution of number of confirmed cases, recovered cases, deaths, tests. For instance, the dashboard should be able to compare Week 3 of May with Week 2 of August.
     - Let’s call `testing ratio(tr) = (number of tests done) / (population)`, now categorise every district in one of the following categories:
          Category A: 0.05 ≤ tr ≤ 0.1
          Category B: 0.1 < tr ≤ 0.3
          Category C: 0.3 < tr ≤ 0.5
          Category D: 0.5 < tr ≤ 0.75
          Category E: 0.75 < tr ≤ 1.0
       Now perform an analysis of number of deaths across all category. Example, what was the number / % of deaths in Category A district as compared for Category E districts.
     - Compare delta7 confirmed cases with respect to vaccination
     - Make at least 2 such KPI that presents the severity of case in different states (example: Any numerical measure to comment on how severe were the cases in Bihar as compared to that of Kerala).
     - Categorise total number of confirmed cases in a state by Months and come up with that one month which was worst for India in terms of number of cases.
     - Generate 2 - 3 insights that is very difficult to observe.
       
**Dashboard Overview**

![image](https://user-images.githubusercontent.com/108783182/191237509-be0a7dde-96c7-452d-817e-0626e29b3466.png)
![image](https://user-images.githubusercontent.com/108783182/191237272-38793ef9-6e7b-465c-91a9-5bff76f01cd6.png)


**Insights**
- In 2020 the cases start increasing from May Week1 and the highest recorded case was in September week 3 and number of deaths were also highest during same week i.e. September Week 3.
- In 2021 during April Week1 there was a spike in cases, and the highest recorded cases were during Second week of May while number of deaths were highest during the fourth week of May.
- In 2020, the highest cases was observed in the month of September, while in 2021 the highest cases was observed in the month of May, which was also the worst month of all, for both 2020 and 2021.
- The Distrists in Category A were the most effected as the Death Percentage were highest, maybe because they have the less number of testing ratio. We can also observe that as testing ratio increases, the death percentage starts declining.
- The first dose of vaccination started in January 2021, while the second dose started in February 2021, and we can see that as the number of vaccination increases, the number of recovery cases also increases. The highest first dose vaccination was done on August 2021, and for the second dose the highest was on September 2021.
- With respect to delta7 confirmed cases, Kerala is the most effected State in India.
- In terms of numbers, Maharashtra is most effected state in India with 6.61 Million Confirmed cases i.e 5.41% of the population and 140.22 Thousand deaths i.e 2.12% of the confirmed cases.
- In terms of percentages, Kerala has the most confirmed cases with 14.15% of the population being tested positive, while Punjab has the most percentage of deaths with 2.75% of the confirmed cases.
- The best performing state for controlling covid19 is Uttar Pradesh with only 0.93% of the population being effected and with recovery percentage of 98.65% of the confirmed cases.


**Techstack :**
Python, SQL Server , MS Excel.

