SELECT * FROM public.revenue_raw_data
SELECT * FROM public.targets_raw_data
SELECT * FROM public.marketing_raw_data
SELECT * FROM public.ipi_opportunities_data
SELECT * FROM public.ipi_calendar_lookup
SELECT * FROM public.ipi_account_lookup

--Changing the revenue column data type from INT to FLOAT
ALTER TABLE public.revenue_raw_data
ALTER COLUMN revenue TYPE FLOAT;

--1 - What is the total Revenue of the company this year?
SELECT --month_id, 
SUM(revenue) AS Total_Revenue21 
FROM public.revenue_raw_data WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')
--GROUP BY month_id

--2 - What is the total Revenue Performance YoY?
--FY21
SELECT a.Total_Revenue21, b.Total_Revenue20, a.Total_Revenue21 - b.Total_Revenue20 AS Dollar_Dif_YOY, a.Total_Revenue21 / b.Total_Revenue20 -1 AS Perc_Dif_YOY
	FROM
	(
	SELECT --month_id, 
	SUM(revenue) AS Total_Revenue21 
	FROM public.revenue_raw_data WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')
	--GROUP BY month_id
	)a,

--FY20
--SELECT month_id, 
--SUM(revenue) AS Total_Revenue20 
--FROM public.revenue_raw_data WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY20')
--GROUP BY month_id
--The above selected 12 months, we want it to select 6 months so that the comparison can be even with 6 monthd for fy21
	(
	SELECT --month_id, 
	SUM(revenue) AS Total_Revenue20 
	FROM public.revenue_raw_data WHERE month_id IN (SELECT DISTINCT month_id-12 FROM public.revenue_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21'))
	--GROUP BY month_id
	)b

--3 - What is the MoM Revenue Performance?
SELECT a.Total_RevenueTM , b.Total_RevenueLM, a.Total_RevenueTM - b.Total_RevenueLM AS MOM_Dollar_Dif, a.Total_RevenueTM / b.Total_RevenueLM - 1 AS MOM_Perc_Dif
FROM
--This month
	(
	SELECT --month_id, 
	SUM(revenue) AS Total_RevenueTM 
	FROM public.revenue_raw_data 
	WHERE month_id IN (SELECT MAX(month_id) FROM public.revenue_raw_data)
	--GROUP BY month_id
	)a,

--Last month
	(
	SELECT --month_id, 
	SUM(revenue) AS Total_RevenueLM 
	FROM public.revenue_raw_data 
	WHERE month_id IN (SELECT MAX(month_id)-1 FROM public.revenue_raw_data)
	)b
	--GROUP BY month_id
	
--4 - What is the Total Revenue Vs Target performance for the Year?
SELECT a.Total_Revenue, b.Target_Performance, a.Total_Revenue - b.Target_Performance AS Dollar_DifF, a.Total_Revenue / b.Target_Performance - 1 AS Perc_Dif
FROM
	(
	SELECT --month_id,
	SUM(revenue) AS Total_Revenue FROM public.revenue_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')
	--GROUP BY month_id
	)a,
	
	(
	SELECT --month_id,
	SUM(target) AS Target_Performance FROM public.targets_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.revenue_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21'))
	--GROUP BY month_id
	)b
	
--5 - What is the Revenue Vs Target performance Per Month?

SELECT c.fiscal_month, a.Total_Revenue, b.Target_Performance, a.Total_Revenue - b.Target_Performance AS Dollar_DifF, a.Total_Revenue / b.Target_Performance - 1 AS Perc_Dif
FROM
	(
	SELECT month_id,
	SUM(revenue) AS Total_Revenue FROM public.revenue_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')
	GROUP BY month_id
	)a
	
	LEFT JOIN
	(
	SELECT month_id,
	SUM(target) AS Target_Performance FROM public.targets_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.revenue_raw_data WHERE month_id IN
	(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21'))
	GROUP BY month_id
	)b
	ON a.month_id = b.month_id
	
	LEFT JOIN
	(SELECT DISTINCT month_id,fiscal_month FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21') c
	ON a.month_id = c.month_id
	
ORDER BY a.month_id

--6 - What is the best performing product in terms of revenue this year?
SELECT * FROM public.revenue_raw_data
SELECT * FROM public.targets_raw_data
SELECT * FROM public.marketing_raw_data
SELECT * FROM public.ipi_opportunities_data
SELECT * FROM public.ipi_calendar_lookup
SELECT * FROM public.ipi_account_lookup

SELECT product_category, SUM(revenue) AS Revenue FROM public.revenue_raw_data
WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')
GROUP BY product_category
ORDER BY Revenue DESC

--7 - What is the product performance Vs Target for the month?
SELECT a.product_category, a.month_id, Revenue, Target, Revenue / Target - 1 AS Rev_vs_Target
FROM
	(
	SELECT product_category,month_id, SUM(revenue) AS Revenue FROM public.revenue_raw_data
	WHERE month_id IN (SELECT MAX(month_id) FROM public.revenue_raw_data)
	GROUP BY product_category, month_id
	)a
	
	LEFT JOIN
	(
	SELECT product_category, month_id, SUM(target) AS Target FROM public.targets_raw_data 
	WHERE month_id IN (SELECT MAX(month_id)-5 FROM public.targets_raw_data)
	GROUP BY product_category,month_id
	)b
	ON a.month_id = b.month_id AND a.product_category = b.product_category

--8 - Which account is performing the best in terms of revenue?
SELECT a.account_no, b.newaccountname, Revenue
FROM
	(
	SELECT account_no, SUM(revenue) AS Revenue FROM public.revenue_raw_data
	WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')
	GROUP BY account_no
	)a
	
	LEFT JOIN
	(
	SELECT * FROM public.ipi_account_lookup
	)b
	ON a.account_no = b.newaccountno


