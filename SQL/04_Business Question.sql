

                                                 --Запросы

        --1)Найти отрасли с наибольшей средней недельной зарплатой

        WITH Ranked_Industries AS (
    SELECT 
        d.[Year],
        d.Time_Period,
        i.Industry_Name,
        i.NAICS_Code,
        AVG(f.Average_Weekly_Wages) AS Avg_Weekly_Wage,
        SUM(f.Average_Monthly_Employment) AS Total_Employment,
        DENSE_RANK() OVER (
            PARTITION BY d.[Year], d.Time_Period 
            ORDER BY AVG(f.Average_Weekly_Wages) DESC
        ) AS Wage_Rank
    FROM dbo.Fact_Employment_Wages f
    JOIN dbo.Dim_Date d ON f.Date_ID = d.Date_ID
    JOIN dbo.Dim_Industry i ON f.Industry_ID = i.Industry_ID
    GROUP BY d.[Year], d.Time_Period, i.Industry_Name, i.NAICS_Code
)
SELECT 
    [Year],
    Time_Period,
    Wage_Rank,
    Industry_Name,
    NAICS_Code,
    Avg_Weekly_Wage,
    Total_Employment
FROM Ranked_Industries
WHERE Wage_Rank <= 5
ORDER BY [Year] DESC, Time_Period, Wage_Rank;

--2) Показать умение считать динамику (YoY) между периодами для оценки инфляционного и экономического роста.

WITH Yearly_Wages AS (
    SELECT 
        d.[Year],
        i.Industry_Name,
        AVG(f.Average_Weekly_Wages) AS Current_Avg_Wage
    FROM dbo.Fact_Employment_Wages f
    JOIN dbo.Dim_Date d ON f.Date_ID = d.Date_ID
    JOIN dbo.Dim_Industry i ON f.Industry_ID = i.Industry_ID
    GROUP BY d.[Year], i.Industry_Name
),
YoY_Calculation AS (
    SELECT 
        [Year],
        Industry_Name,
        Current_Avg_Wage,
        LAG(Current_Avg_Wage, 1) OVER (
            PARTITION BY Industry_Name 
            ORDER BY [Year]
        ) AS Previous_Year_Wage
    FROM Yearly_Wages
)
SELECT 
    [Year],
    Industry_Name,
    Current_Avg_Wage,
    Previous_Year_Wage,
    ROUND(((Current_Avg_Wage - Previous_Year_Wage) * 100.0 / NULLIF(Previous_Year_Wage, 0)), 2) AS Wage_Growth_Pct
FROM YoY_Calculation
WHERE Previous_Year_Wage IS NOT NULL
ORDER BY Wage_Growth_Pct DESC;

--3) Сравнить объём фонда оплаты труда (Total_Wages_All_Workers) каждого округа со средним показателем по всему штату с помощью AVG() OVER()

SELECT 
    g.Area_Name AS County_Name,
    d.[Year],
    d.Time_Period,
    SUM(f.Total_Wages_All_Workers) AS County_Total_Wages,
    AVG(SUM(f.Total_Wages_All_Workers)) OVER (
        PARTITION BY d.[Year], d.Time_Period
    ) AS Avg_County_Wages_Statewide
FROM dbo.Fact_Employment_Wages f
JOIN dbo.Dim_Geography g ON f.Geography_ID = g.Geography_ID
JOIN dbo.Dim_Date d ON f.Date_ID = d.Date_ID
GROUP BY g.Area_Name, d.[Year], d.Time_Period
ORDER BY d.[Year] DESC, d.Time_Period, County_Total_Wages DESC;

