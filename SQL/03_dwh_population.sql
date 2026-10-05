
-- Заполнение Таблицы Фактов через JOIN со справочниками
INSERT INTO dbo.Fact_Employment_Wages (
    Date_ID,
    Geography_ID,
    Industry_ID,
    Ownership,
    Establishments,
    Average_Monthly_Employment,
    Total_Wages_All_Workers,
    Average_Weekly_Wages
)
SELECT 
    d.Date_ID,
    g.Geography_ID,
    i.Industry_ID,
    src.Ownership,
    src.Establishments,
    src.Average_Monthly_Employment,
    src.Total_Wages_All_Workers,
    src.Average_Weekly_Wages
FROM dbo.vw_Fact_BLS_County_Level src
JOIN dbo.Dim_Date d 
    ON src.[Year] = d.[Year] AND src.Time_Period = d.Time_Period
JOIN dbo.Dim_Geography g 
    ON src.Area_Type = g.Area_Type AND src.Area_Name = g.Area_Name
JOIN dbo.Dim_Industry i 
    ON src.NAICS_Code = i.NAICS_Code AND src.Industry_Name = i.Industry_Name;

    select *
    from dbo.Fact_Employment_Wages