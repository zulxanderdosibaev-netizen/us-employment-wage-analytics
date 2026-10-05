
				-- Создание таблиц (Fact_Employment_Wages, Dim_*)

				
    -- 1. Справочник Географии
IF OBJECT_ID('dbo.Dim_Geography', 'U') IS NOT NULL DROP TABLE dbo.Dim_Geography;

CREATE TABLE dbo.Dim_Geography (
    Geography_ID INT IDENTITY(1,1) PRIMARY KEY,
    Area_Type VARCHAR(100),
    Area_Name VARCHAR(250)
);

INSERT INTO dbo.Dim_Geography (Area_Type, Area_Name)
SELECT DISTINCT 
    Area_Type, 
    Area_Name
FROM dbo.vw_Fact_BLS_County_Level;


-- 2. Справочник Отраслей
IF OBJECT_ID('dbo.Dim_Industry', 'U') IS NOT NULL DROP TABLE dbo.Dim_Industry;

CREATE TABLE dbo.Dim_Industry (
    Industry_ID INT IDENTITY(1,1) PRIMARY KEY,
    NAICS_Code VARCHAR(20),
    Industry_Name VARCHAR(300),
    NAICS_Level INT
);

INSERT INTO dbo.Dim_Industry (NAICS_Code, Industry_Name, NAICS_Level)
SELECT DISTINCT 
    NAICS_Code, 
    Industry_Name, 
    NAICS_Level
FROM dbo.vw_Fact_BLS_County_Level;

-- 3. Справочник Периодов
IF OBJECT_ID('dbo.Dim_Date', 'U') IS NOT NULL DROP TABLE dbo.Dim_Date;

CREATE TABLE dbo.Dim_Date (
    Date_ID INT IDENTITY(1,1) PRIMARY KEY,
    [Year] INT,
    Time_Period VARCHAR(20)
);

INSERT INTO dbo.Dim_Date ([Year], Time_Period)
SELECT DISTINCT 
    [Year], 
    Time_Period
FROM dbo.vw_Fact_BLS_County_Level;


-- 4. Таблица Фактов
IF OBJECT_ID('dbo.Fact_Employment_Wages', 'U') IS NOT NULL DROP TABLE dbo.Fact_Employment_Wages;

CREATE TABLE dbo.Fact_Employment_Wages (
    Fact_ID INT IDENTITY(1,1) PRIMARY KEY,
    Date_ID INT FOREIGN KEY REFERENCES dbo.Dim_Date(Date_ID),
    Geography_ID INT FOREIGN KEY REFERENCES dbo.Dim_Geography(Geography_ID),
    Industry_ID INT FOREIGN KEY REFERENCES dbo.Dim_Industry(Industry_ID),
    Ownership VARCHAR(100),
    Establishments INT,
    Average_Monthly_Employment INT,
    Total_Wages_All_Workers BIGINT,
    Average_Weekly_Wages INT
);



select top 500 *
from Dim_Geography;

select top 500 *
from Dim_Industry;

select top 500 *
from Dim_Date;

select top 500 *
from Fact_Employment_Wages;