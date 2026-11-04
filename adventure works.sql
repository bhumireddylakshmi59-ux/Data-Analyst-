create database adventure_works;
select*from dimcustomer;
select*from fact_internet_sales_new;
select*from factinternetsales;
#combined the two facts tables 
create table fact_sales_new as
select* from fact_internet_sales_new
union 
select*from factinternetsales;
select * from fact_sales_new;

#Join the dmproduct and dmsubcategory & dmcategory
 CREATE TABLE product_three_dimensions AS
SELECT
    p.*,
    s.ProductSubcategoryKey AS Subcategory_ProductSubcategoryKey,
    s.ProductSubcategoryAlternateKey,
    s.EnglishProductSubcategoryName,
    s.ProductCategoryKey AS Subcategory_ProductCategoryKey,
    c.ProductCategoryKey AS Category_ProductCategoryKey,
    c.ProductCategoryAlternateKey,
    c.EnglishProductCategoryName
FROM dimproduct p
LEFT JOIN dimproductsubcategory s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
LEFT JOIN dimproductcategory c
    ON s.ProductCategoryKey = c.ProductCategoryKey;
    select*from product_three_dimensions;
  
   ##########Q ####1 questions
select
 s.salesordernumber,
 s.orderdate,
 s.productkey,
p.EnglishProductName as ProductName
from fact_sales_new s
inner join dimproduct p
on s.productkey = p.productkey
order by s.orderdate ASC;

  ######2222
SELECT
    s.*,
    c.CustomerName,
    p.UnitPrice
FROM fact_sales_new s
LEFT JOIN dimcustomer c
    ON s.CustomerKey = c.ï»¿CustomerKey
LEFT JOIN dimproduct p
    ON s.ProductKey = p.ProductKey;
    
####33333#####

  SELECT 
    f.*,
    d.FullDateAlternateKey AS OrderDate,
    d.CalendarYear as year,
    d.MonthNumberOfYear as monthnumber,
    d.EnglishMonthName as Monthname,
    d.CalendarQuarter as quarter,
    d.DayNumberOfWeek as weekdayno,
    d.EnglishDayNameOfWeek as weekdayname,
    d.FiscalYear as financialyear,
    d.FiscalQuarter as financialquarter
FROM fact_sales_new f
JOIN dimdate d 
    ON f.OrderDateKey = d.ï»¿DateKey;
    
    
####44444
SELECT 
    *,
    (UnitPrice * (1 - UnitPriceDiscountPct) * OrderQuantity) AS SalesAmount
FROM fact_sales_new;

######55
SELECT 
    *,
    (ProductStandardCost * OrderQuantity) AS ProductionCost
FROM fact_sales_new;

  ######6
  SELECT 
    *,
    ((UnitPrice * (1 - UnitPriceDiscountPct) * OrderQuantity) - (ProductStandardCost * OrderQuantity)) AS Profit
FROM fact_sales_new;


#####8
SELECT 
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    SUM(SalesAmount) AS Total_Sales
FROM fact_sales_new
GROUP BY Year
ORDER BY Year;
######9
SELECT 
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Month,
    SUM(SalesAmount) AS Total_Sales
FROM fact_sales_new
GROUP BY Month
ORDER BY Month;  
####10
SELECT 
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Quarter,
    SUM(SalesAmount) AS Total_Sales
FROM fact_sales_new
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

######11 sum of sales
SELECT SUM(SalesAmount) AS Total_Sales
FROM fact_sales_new;
#### region wise sales
SELECT 
    t.SalesTerritoryRegion,
    SUM(f.SalesAmount) AS Total_Sales
FROM fact_sales_new f
LEFT JOIN dimsalesterritory t
    ON f.SalesTerritoryKey = t.ï»¿SalesTerritoryKey
GROUP BY t.SalesTerritoryRegion
ORDER BY Total_Sales DESC;
############# country wise sales
SELECT 
    t.SalesTerritoryCountry,
    SUM(f.SalesAmount) AS Total_Sales
FROM fact_sales_new f
LEFT JOIN dimsalesterritory t
    ON f.SalesTerritoryKey = t.ï»¿SalesTerritoryKey
GROUP BY t.SalesTerritoryCountry
ORDER BY Total_Sales DESC;
#######
CREATE TABLE sales_calculated AS
SELECT 
    *,
    (UnitPrice * (1 - UnitPriceDiscountPct) * OrderQuantity) AS totalsales,
    (ProductStandardCost * OrderQuantity) AS ProductionCost,
    ((UnitPrice * (1 - UnitPriceDiscountPct) * OrderQuantity) 
        - (ProductStandardCost * OrderQuantity)) AS Profit
FROM fact_sales_new;
select*from sales_calculated;
######
SELECT SUM(profit) AS total_profit
FROM sales_calculated;
######max sales
SELECT max(totalsales) AS max_Sales
FROM sales_calculated;
######## avg sales
SELECT avg(totalsales) AS avg_sales
FROM sales_calculated;
####### order count
SELECT count(OrderQuantity) AS orders_count
FROM fact_sales_new;
#####max profit
SELECT max(Profit) AS avg_sales
FROM sales_calculated;