select * from dataset.dbo.coronavirusdataset
where Province is null or Country_Region is null or
Latitude is null or Longitude is null or 
Date is null or Confirmed is null or 
Deaths is null or Recovered is null


Select * from dataset.dbo.coronavirusdataset
Update dataset.dbo.coronavirusdataset
SET 
	Province = Coalesce(Province, '0'),
	Country_Region = Coalesce(Country_Region, '0'),
	Latitude = Coalesce(Latitude, '0'),
	Longitude = Coalesce(Longitude, '0'),
	Date = Coalesce(Date, '0'),
	Confirmed = Coalesce(Confirmed, '0'),
	Deaths = Coalesce(Deaths, '0'),
	Recovered = Coalesce(Recovered, '0');


Select COUNT(*) as totalRows from dataset.dbo.coronavirusdataset

use dataset
select
	MIN(TRY_CONVERT(date, Date, 103)) as startDate,
	MAX(TRY_CONVERT(date, Date, 103)) as endDate
from dataset.dbo.coronavirusdataset


use dataset
select
	COUNT(DISTINCT CONCAT(YEAR(TRY_CONVERT(date, Date, 105)), '-', 
	MONTH(TRY_CONVERT(date, Date, 105)))) 
	AS numberOfMonths
from dataset.dbo.coronavirusdataset


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105)) AS Month,
	AVG(CONVERT(float, TRY_CONVERT(int, Confirmed))) AS monthlyAverageConfirmed,
	AVG(CONVERT(float, TRY_CONVERT(int, Deaths))) AS monthlyAverageDeaths,
	AVG(CONVERT(float, TRY_CONVERT(int, Recovered))) AS monthlyAverageRecovered
FROM
	dataset.dbo.coronavirusdataset
WHERE
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) IN (2020, 2021)
GROUP BY
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105))
ORDER BY
	Year, Month;


WITH frequentValues AS (
	SELECT
		DATEPART(MONTH, TRY_CONVERT(date, Date, 105)) AS monthNumber,
		DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS yearNumber,
		Confirmed,
		Deaths,
		Recovered,
		RANK() OVER (PARTITION BY DATEPART(MONTH, TRY_CONVERT(date, Date, 105)),
		DATEPART(YEAR, TRY_CONVERT(date, Date, 105))
		ORDER BY COUNT(*) DESC) AS RANK
	FROM
		dataset.dbo.coronavirusdataset
	GROUP BY
		DATEPART(MONTH, TRY_CONVERT(date, Date, 105)),
		DATEPART(YEAR, TRY_CONVERT(date, Date, 105)),
		Confirmed, Deaths, Recovered
)

SELECT
	monthNumber,
	yearNumber,
	Confirmed,
	Deaths,
	Recovered
FROM
	frequentValues
WHERE
	RANK = 1
ORDER BY
	yearNumber, monthNumber ASC;


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	MIN(Confirmed) AS minimumConfirmed,
	MIN(Deaths) AS minimumDeaths,
	MIN(Recovered) AS minimumRecovered
FROM
	dataset.dbo.coronavirusdataset
GROUP BY DATEPART(YEAR, TRY_CONVERT(date, Date, 105))
ORDER BY Year ASC;


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	MAX(Confirmed) AS maximumConfirmed,
	MAX(Deaths) AS maximumDeaths,
	MAX(Recovered) AS maximumRecovered
FROM
	dataset.dbo.coronavirusdataset
GROUP BY DATEPART(YEAR, TRY_CONVERT(date, Date, 105))
ORDER BY Year ASC;


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105)) AS Month,
	SUM(Confirmed) AS totalConfirmed,
	SUM(Deaths) AS totalDeaths,
	SUM(Recovered) AS totalRecovered
FROM
	dataset.dbo.coronavirusdataset
GROUP BY 
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105))
ORDER BY Year, Month ASC;


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105)) AS Month,
	SUM(Confirmed) AS totalConfirmed,
	ROUND(AVG(Confirmed),2) AS avgConfirmed,
	ROUND(VAR(Confirmed),2) AS varianceConfirmed,
	ROUND(STDEV(Confirmed),2) AS STDConfirmed
FROM
	dataset.dbo.coronavirusdataset
GROUP BY 
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105))
ORDER BY Year, Month ASC;


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105)) AS Month,
	SUM(Deaths) AS totalDeaths,
	ROUND(AVG(Deaths),2) AS avgDeaths,
	ROUND(VAR(Deaths),2) AS varianceDeaths,
	ROUND(STDEV(Deaths),2) AS STDDeaths
FROM
	dataset.dbo.coronavirusdataset
GROUP BY 
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105))
ORDER BY Year, Month ASC;


SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)) AS Year,
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105)) AS Month,
	SUM(Recovered) AS totalRecovered,
	ROUND(AVG(Recovered),2) AS avgRecovered,
	ROUND(VAR(Recovered),2) AS varianceRecovered,
	ROUND(STDEV(Recovered),2) AS STDRecovered
FROM
	dataset.dbo.coronavirusdataset
GROUP BY 
	DATEPART(YEAR, TRY_CONVERT(date, Date, 105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date, 105))
ORDER BY Year, Month ASC;


SELECT TOP(1)
	Country_Region,
	SUM(Confirmed) as totalConfirmedCases
FROM
	dataset.dbo.coronavirusdataset
GROUP BY Country_Region
ORDER BY totalConfirmedCases DESC;


SELECT
	Country_Region,
	SUM(Deaths) as totalDeathCases
FROM
	dataset.dbo.coronavirusdataset
GROUP BY Country_Region
ORDER BY totalDeathCases ASC;

SELECT TOP(5)
	Country_Region,
	SUM(Recovered) as totalRecoveredCases
FROM
	dataset.dbo.coronavirusdataset
GROUP BY Country_Region
ORDER BY totalRecoveredCases DESC;
