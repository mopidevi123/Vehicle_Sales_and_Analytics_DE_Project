CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''


------------------------
------CREATE CREDENTIAL
--------------------------

CREATE DATABASE SCOPED CREDENTIAL pravcreds
WITH 
    IDENTITY = 'Managed Identity'


------------------------
----CREATE EXT DATA SOURCE
-------------------------

CREATE EXTERNAL DATA SOURCE vehicle_sales
WITH
(
    LOCATION = 'https://pravdatalake.dfs.core.windows.net/gold',
    CREDENTIAL = pravcreds
)


------------------------
----OPENROWSET FUNCTION
-------------------------

SELECT 
    *
FROM 
    OPENROWSET(
        BULK 'dim_automaker/',
        DATA_SOURCE = 'raw_ext_source',
        FORMAT = 'DELTA'
    ) as data



------------------------
----CREATE VIEWS
-------------------------

CREATE VIEW dim_automaker
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'dim_automaker/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS automaker


SELECT * FROM dim_automaker

--------------------
CREATE VIEW dim_genmodel
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'dim_genmodel/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS genmodel


SELECT * FROM dim_genmodel

--------------
CREATE VIEW dim_trim
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'dim_trim/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS trim


SELECT * FROM dim_trim

--------------
CREATE VIEW dimension_date
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'dimension_date/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS date

SELECT * FROM dimension_date

--------------
CREATE VIEW fact_ad_listing
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'fact_ad_listing/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS ad_listing


SELECT * FROM fact_ad_listing


---------------------
CREATE VIEW fact_price_history
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'fact_price_history/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS price_history


SELECT * FROM fact_price_history


--------------------------
CREATE VIEW fact_sales
AS 
SELECT
     * 
FROM 
    OPENROWSET(
        BULK 'fact_sales/',
        DATA_SOURCE = 'vehicle_sales',
        FORMAT = 'DELTA'
    ) AS sales


SELECT * FROM fact_sales


i have created all the views 

can you give me all the code ?
