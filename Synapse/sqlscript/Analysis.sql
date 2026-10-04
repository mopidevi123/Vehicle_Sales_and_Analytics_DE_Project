-----1. Automaker sales performance

CREATE VIEW dbo.vw_automaker_sales
AS
SELECT
    a.Automaker_ID,
    a.Automaker,
    SUM(s.Units_Sold) AS Total_Units_Sold
FROM dbo.fact_sales s
JOIN dbo.dim_genmodel g
    ON s.Genmodel_ID = g.Genmodel_ID
JOIN dbo.dim_automaker a
    ON g.Automaker_ID = a.Automaker_ID
GROUP BY
    a.Automaker_ID,
    a.Automaker;

SELECT *
FROM dbo.vw_automaker_sales
ORDER BY Total_Units_Sold DESC;


-------Vehicle model sales performance

CREATE VIEW dbo.vw_genmodel_sales
AS
SELECT
    g.Genmodel_ID,
    g.Genmodel,
    a.Automaker,
    SUM(s.Units_Sold) AS Total_Units_Sold
FROM dbo.fact_sales s
JOIN dbo.dim_genmodel g
    ON s.Genmodel_ID = g.Genmodel_ID
JOIN dbo.dim_automaker a
    ON g.Automaker_ID = a.Automaker_ID
GROUP BY
    g.Genmodel_ID,
    g.Genmodel,
    a.Automaker;

SELECT *
FROM dbo.vw_genmodel_sales
ORDER BY Total_Units_Sold DESC;



-------3. Yearly sales analysis

CREATE VIEW dbo.vw_yearly_sales
AS
SELECT
    d.year,
    SUM(s.Units_Sold) AS Total_Units_Sold
FROM dbo.fact_sales s
JOIN dbo.dimension_date d
    ON s.date_key = d.date_key
GROUP BY
    d.year;


SELECT *
FROM dbo.vw_yearly_sales
ORDER BY year;


-------------4. Monthly sales analysis

CREATE VIEW dbo.vw_monthly_sales
AS
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(s.Units_Sold) AS Total_Units_Sold
FROM dbo.fact_sales s
JOIN dbo.dimension_date d
    ON s.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name;


SELECT *
FROM dbo.vw_monthly_sales
ORDER BY
    year,
    month;


--------5. Sales by vehicle model and year

CREATE VIEW dbo.vw_model_year_sales
AS
SELECT
    d.year,
    g.Genmodel_ID,
    g.Genmodel,
    a.Automaker,
    SUM(s.Units_Sold) AS Total_Units_Sold
FROM dbo.fact_sales s
JOIN dbo.dimension_date d
    ON s.date_key = d.date_key
JOIN dbo.dim_genmodel g
    ON s.Genmodel_ID = g.Genmodel_ID
JOIN dbo.dim_automaker a
    ON g.Automaker_ID = a.Automaker_ID
GROUP BY
    d.year,
    g.Genmodel_ID,
    g.Genmodel,
    a.Automaker;


-----------6. Price history analysis

CREATE VIEW dbo.vw_price_history_analysis
AS
SELECT
    p.Genmodel_ID,
    g.Genmodel,
    a.Automaker,
    d.year,
    p.Entry_price
FROM dbo.fact_price_history p
JOIN dbo.dim_genmodel g
    ON p.Genmodel_ID = g.Genmodel_ID
JOIN dbo.dim_automaker a
    ON g.Automaker_ID = a.Automaker_ID
JOIN dbo.dimension_date d
    ON p.date_key = d.date_key;


SELECT *
FROM dbo.vw_price_history_analysis;



----------7. Average price by automaker

CREATE VIEW dbo.vw_automaker_average_price
AS
SELECT
    a.Automaker,
    AVG(CAST(p.Entry_price AS DECIMAL(18,2))) AS Average_Entry_Price
FROM dbo.fact_price_history p
JOIN dbo.dim_genmodel g
    ON p.Genmodel_ID = g.Genmodel_ID
JOIN dbo.dim_automaker a
    ON g.Automaker_ID = a.Automaker_ID
GROUP BY
    a.Automaker;


SELECT *
FROM dbo.vw_automaker_average_price
ORDER BY Average_Entry_Price DESC;


-----------8. Ad listing analysis

CREATE VIEW dbo.vw_ad_listing_analysis
AS
SELECT
    g.Genmodel_ID,
    g.Genmodel,
    a.Automaker,
    COUNT(al.Adv_ID) AS Total_Advertisements,
    AVG(CAST(al.Price AS DECIMAL(18,2))) AS Average_Advertised_Price,
    AVG(CAST(al.Runned_Miles AS DECIMAL(18,2))) AS Average_Runned_Miles
FROM dbo.fact_ad_listing al
JOIN dbo.dim_genmodel g
    ON al.Genmodel_ID = g.Genmodel_ID
JOIN dbo.dim_automaker a
    ON g.Automaker_ID = a.Automaker_ID
GROUP BY
    g.Genmodel_ID,
    g.Genmodel,
    a.Automaker;


----------9. Fuel-type analysis

CREATE VIEW dbo.vw_fuel_type_analysis
AS
SELECT
    Fuel_type,
    COUNT(*) AS Total_Advertisements,
    AVG(CAST(Price AS DECIMAL(18,2))) AS Average_Price,
    AVG(CAST(Runned_Miles AS DECIMAL(18,2))) AS Average_Runned_Miles
FROM dbo.fact_ad_listing
GROUP BY
    Fuel_type;


SELECT *
FROM dbo.vw_fuel_type_analysis
ORDER BY Total_Advertisements DESC;



----------10. Body-type analysis

CREATE VIEW dbo.vw_bodytype_analysis
AS
SELECT
    Bodytype,
    COUNT(*) AS Total_Advertisements,
    AVG(CAST(Price AS DECIMAL(18,2))) AS Average_Price,
    AVG(CAST(Runned_Miles AS DECIMAL(18,2))) AS Average_Runned_Miles
FROM dbo.fact_ad_listing
GROUP BY
    Bodytype;


----------11. Top 10 vehicle models

CREATE VIEW dbo.vw_top_vehicle_models
AS
WITH model_sales AS
(
    SELECT
        g.Genmodel_ID,
        g.Genmodel,
        a.Automaker,
        SUM(s.Units_Sold) AS Total_Units_Sold
    FROM dbo.fact_sales s
    JOIN dbo.dim_genmodel g
        ON s.Genmodel_ID = g.Genmodel_ID
    JOIN dbo.dim_automaker a
        ON g.Automaker_ID = a.Automaker_ID
    GROUP BY
        g.Genmodel_ID,
        g.Genmodel,
        a.Automaker
),
ranked_models AS
(
    SELECT
        *,
        RANK() OVER (
            ORDER BY Total_Units_Sold DESC
        ) AS sales_rank
    FROM model_sales
)
SELECT
    Genmodel_ID,
    Genmodel,
    Automaker,
    Total_Units_Sold,
    sales_rank
FROM ranked_models
WHERE sales_rank <= 10;



SELECT *
FROM dbo.vw_top_vehicle_models
ORDER BY sales_rank;



