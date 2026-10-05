
             


                                        -- Data cleansing and Transformation 

CREATE VIEW vw_Fact_BLS_Cleaned AS
SELECT 
    -- Временные измерения
    CAST(Year AS INT) AS [Year],
    Time_Period,
    
    -- География
    Area_Type,
    Area_Name,
    
    -- Отрасль и собственность
    Ownership,
    NAICS_Level,
    NAICS_Code,
    Industry_Name,
    
    -- Метрики
    Establishments,
    Average_Monthly_Employment,
    _1st_Month_Emp,
    _2nd_Month_Emp,
    _3rd_Month_Emp,
    Total_Wages_All_Workers,
    Average_Weekly_Wages
FROM dbo.[qcew 2023-2025]
WHERE 
    -- 1. Исключаем годовые итоговые строки, оставляем только кварталы
    Time_Period IN ('1st Qtr', '2nd Qtr', '3rd Qtr', '4th Qtr')
    
    -- 2. Исключаем дублирующие итоговые строки по формам собственности
    AND Ownership NOT IN ('Total Covered', 'Total Government', 'Total U.I. Covered')
    
    -- 3. Фильтруем пустые/невалидные записи (при необходимости)
    AND Average_Monthly_Employment IS NOT NULL;



    SELECT 
    COUNT(*) AS Clean_Rows_Count
FROM dbo.[qcew 2023-2025]
WHERE 
    -- 1. Оставляем только кварталы (без Annual)
    Time_Period IN ('1st Qtr', '2nd Qtr', '3rd Qtr', '4th Qtr')
    
    -- 2. Оставляем только чистые формы собственности
    AND Ownership NOT IN ('Total Covered', 'Total Government', 'Total U.I. Covered')
    
    -- 3. Оставляем только самый подробный уровень отраслей
    AND NAICS_Level = 6;

    CREATE VIEW dbo.vw_Fact_BLS_County_Level AS
SELECT 
    [Year],
    [Time_Period],
    [Area_Type],
    [Area_Name],
    [Ownership],
    [NAICS_Level],
    [NAICS_Code],
    [Industry_Name],
    [Establishments],
    [Average_Monthly_Employment],
    [_1st_Month_Emp],
    [_2nd_Month_Emp],
    [_3rd_Month_Emp],
    [Total_Wages_All_Workers],
    [Average_Weekly_Wages]
FROM dbo.[qcew 2023-2025]
WHERE 
    -- 1. Только кварталы
    Time_Period IN ('1st Qtr', '2nd Qtr', '3rd Qtr', '4th Qtr')
    
    -- 2. Чистая форма собственности
    AND Ownership NOT IN ('Total Covered', 'Total Government', 'Total U.I. Covered')
    
    -- 3. Атомарный уровень отраслей
    AND NAICS_Level = 6
    
    -- 4. Атомарный уровень географии (только округа, без итогов по штату/стране)
    AND Area_Type = 'County';




    SELECT  top 500 *
    FROM vw_Fact_BLS_Cleaned;

    SELECT top 500 *
    FROM dbo.vw_Fact_BLS_County_Level;