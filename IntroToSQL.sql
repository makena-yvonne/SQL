----------SIMPLE SQL QUERIES----------
---Shortcut Keys
--CRTL + C = Copy
--CRTL + x = Cut
--CRTL + v = Paste
--CRTL + z = undo/back
--F5 in SQL = Run

----------DATA TYPES----------
--VARCHAR(25) - For characters. You cannot apply aggregated functions to this
--NVARCHAR(25) - For characters. You cannot apply aggregated functions to this
--FLOAT - Numbers with decimal values, so you can aggregate the data SUM/AVG/MAX/MIN
--INT - Numbers with no decimal places
--Date - for dates

----------SELECT QUERY----------
-- *means ALL
SELECT * FROM public.revenue_raw_data
SELECT month_id,revenue FROM public.revenue_raw_data

--Example 1 - 1 Condition =
SELECT * FROM public.revenue_raw_data WHERE product_category='Services'

--Example 2 - 1 Condition <>
SELECT * FROM public.revenue_raw_data WHERE product_category <> 'Services' 

--Example 3 - 1 Condition IN
SELECT * FROM public.revenue_raw_data WHERE product_category IN ('Services', 'Online Products') 

--Example 4 - 1 Condition NOT IN
SELECT * FROM public.revenue_raw_data WHERE product_category NOT IN ('Services', 'Online Products') 

--Example 5 - 1 Condition LIKE
SELECT * FROM public.ipi_account_lookup WHERE accountsegment LIKE '%Priority%'
SELECT * FROM public.ipi_account_lookup WHERE accountsegment NOT LIKE '%Priority%'

--Example 6 - 2 Conditions AND
SELECT * FROM public.ipi_account_lookup WHERE accountsegment = 'Priority Commercial' AND sector = 'Banking'

--Example 7 - 2 Conditions OR
SELECT * FROM public.ipi_account_lookup WHERE accountsegment = 'Priority Commercial' OR sector = 'Banking'

--Example 8 - 2 Conditions AND/OR
SELECT * FROM public.ipi_account_lookup WHERE (accountsegment = 'Priority Commercial' AND sector = 'Banking') OR industry = 'Retailers'

--Example 9 - 1 Condition >
SELECT * FROM public.revenue_raw_data WHERE revenue > 1500000

--Example 10 - 1 Condition <
SELECT * FROM public.revenue_raw_data WHERE revenue < 1500000

--Example 11 - 1 Condition BETWEEN
SELECT * FROM public.revenue_raw_data WHERE revenue BETWEEN 1300000 AND 1500000

----------WHERE CLAUSE WITH SUBQUERY----------
SELECT * FROM public.revenue_raw_data
SELECT * FROM public.ipi_calendar_lookup

--Example 1 - 1 Condition from another table
SELECT * FROM public.revenue_raw_data WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21')

--Example 2 - 1 Condition from another table FY21 and 1 condition
SELECT * FROM public.revenue_raw_data WHERE month_id IN (SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_year = 'FY21') AND revenue > 1700000

----------IF & CASE STATEMENTS IN SQL----------
SELECT * FROM public.revenue_raw_data
SELECT * FROM public.ipi_opportunities_data

--Example 1 - 1 IIF Condition -same column names
SELECT account_no, month_id, IF (product_category = 'Services', 'ServicesMarketing', product_category) AS product_category, revenue  FROM public.revenue_raw_data
--The above returns an error. I need to debug

--Example 2 - Multiple IIF statements with a new column
SELECT * FROM
    (
	IF(new_opportunity_name LIKE '%Phase-1%', 'Phase-1',
	IF(new_opportunity_name LIKE '%Phase-2%', 'Phase-2',
	IF(new_opportunity_name LIKE '%Phase-3%', 'Phase-3',
	IF(new_opportunity_name LIKE '%Phase-4%', 'Phase-4',
	IF(new_opportunity_name LIKE '%Phase-5%', 'Phase-5','Need Mapping'))))) AS Opp_Phase
	FROM public.ipi_opportunities_data
	)a
WHERE Opp_Phase = 'Need Mapping'
--The above returns an error. I need to debug 

--Example 1 - CASE
SELECT account_no, month_id, 
CASE 
	WHEN product_category = 'Services' THEN 'Services & Marketing'
	ELSE product_category
	END AS product_category, 
revenue  FROM public.revenue_raw_data

--Example 2 - CASE with mutiple conditions
SELECT *, 
CASE
	WHEN new_opportunity_name LIKE '%Phase - 1%' THEN 'Phase-1'
	WHEN new_opportunity_name LIKE '%Phase - 2%' THEN 'Phase-2'
	WHEN new_opportunity_name LIKE '%Phase - 3%' THEN 'Phase-3'
	WHEN new_opportunity_name LIKE '%Phase - 4%' THEN 'Phase-4'
	WHEN new_opportunity_name LIKE '%Phase - 5%' THEN 'Phase-5'
	ELSE 'Need Mapping'
	END AS Opp_Phase
FROM public.ipi_opportunities_data

----------UPDATE/REPLACE/INSERT INTO/DELETE----------
SELECT * FROM public.revenue_raw_data
SELECT * FROM public.ipi_opportunities_data

--Example 1 - Renaming a column
SELECT *, IF (product_category = 'Services', 'ServicesMarketing', product_category) AS product_category2 FROM public.revenue_raw_data
--The above returns an error. I need to debug 

SELECT *,
CASE
	WHEN product_category = 'Services' THEN 'Services & Marketing'
	ELSE product_category
	END AS product_category2 
FROM public.revenue_raw_data

UPDATE revenue_raw_data
SET product_category = 
CASE 
	WHEN product_category = 'Services' 
	THEN 'Services & Marketing' 
	ELSE product_category
	END
	
UPDATE revenue_raw_data
SET product_category = 
CASE 
	WHEN product_category = 'Services & Marketing' 
	THEN 'Services' 
	ELSE product_category
	END

--Example 2 - Replace
SELECT *,
CASE
	WHEN product_category = 'Services' THEN 'Services & Marketing'
	ELSE product_category
	END AS product_category2,
REPLACE (account_no = 22525115, 900, account_no) AS account_no2 
FROM public.revenue_raw_data
--The above returns an error. I need to debug 
   
UPDATE revenue_raw_data
SET account_no = REPLACE (account_no = 22525115, 900, account_no) 

--Example 2 - INSERT INTO

SELECT * FROM revenue_raw_data

INSERT INTO revenue_raw_data
SELECT 10000, NULL, 'sale', NULL

SELECT * FROM revenue_raw_data WHERE account_no = 10000

--Example 3 - Deleting data
DELETE FROM revenue_raw_data WHERE account_no = 10000

SELECT * FROM revenue_raw_data WHERE account_no = 10000

----------MAIN AGGREGATE FUNCTIONS IN SQL----------
SELECT * FROM public.revenue_raw_data

--Example 1 - SUM
SELECT product_category,month_id, SUM(revenue) AS sum_revenue FROM public.revenue_raw_data
WHERE month_id=137
GROUP BY product_category,month_id

--Example 2 - SUM
SELECT product_category,month_id, SUM(revenue) AS sum_revenue FROM public.revenue_raw_data
--WHERE month_id=137
GROUP BY product_category,month_id
ORDER BY month_id

--Example 3 - SUM Order by value
SELECT product_category,month_id, SUM(revenue) AS sum_revenue FROM public.revenue_raw_data
--WHERE month_id=137
GROUP BY product_category,month_id
ORDER BY SUM(revenue) DESC

--Example 4 - COUNT 1 column
SELECT product_category,month_id, COUNT(month_id) AS count_month_id FROM public.revenue_raw_data
GROUP BY product_category,month_id
ORDER BY COUNT(month_id) DESC

--Example 5 - MIN
SELECT product_category, MIN(revenue) AS min_revenue FROM public.revenue_raw_data
GROUP BY product_category

--Example 6 - MAX
SELECT product_category, MAX(revenue) AS max_revenue FROM public.revenue_raw_data
GROUP BY product_category

----------LEFT/FULL/CROSS JOIN STATEMENTS IN SQL----------
SELECT * FROM public.ipi_opportunities_data
SELECT * FROM public.ipi_account_lookup

--EXAMPLE 1 - LEFT JOIN
--RULES
--1. Select columns you need from the two or more tables you want to join
--2. Identify identical columns in each table so that we can join them
--3. Need to specify on top which columns we need from each table 

--We want all columns from public.ipi_opportunities_data
--We want newaccountname and industry columns from public.ipi_account_lookup
--Our identical column in both tables is newaccountno from public.ipi_account_lookup 
--and new_account_no from public.ipi_opportunities_data
SELECT a.*,b.newaccountname, b.industry
FROM
	(
	SELECT new_account_no, opportunity_id, new_opportunity_name,est_completion_month_id,product_category, opportunity_stage, est_opportunity_value  FROM public.ipi_opportunities_data
	--4,133 rows
	)a
	LEFT JOIN
	(
	SELECT newaccountno, newaccountname,industry FROM public.ipi_account_lookup --1,145 rows
	)b
ON a.new_account_no = b.newaccountno
--4,133 rows

------ Short but not so good method
SELECT public.ipi_opportunities_data.* , public.ipi_account_lookup.newaccountname,public.ipi_account_lookup.industry FROM public.ipi_opportunities_data
LEFT JOIN public.ipi_account_lookup
ON public.ipi_opportunities_data.new_account_no = public.ipi_account_lookup.newaccountno
------

--EXAMPLE 2 - FULL JOIN
SELECT a.*,b.newaccountname, b.industry
FROM
	(
	SELECT new_account_no, opportunity_id, new_opportunity_name,est_completion_month_id,product_category, opportunity_stage, est_opportunity_value  FROM public.ipi_opportunities_data
	--4,133 rows
	)a
	FULL JOIN
	(
	SELECT newaccountno, newaccountname,industry FROM public.ipi_account_lookup --1,145 rows
	)b
ON a.new_account_no = b.newaccountno
--4,133 rows on left join
--4,591 current rows

------------Here there is an error wit ISNULL that needs to be fixed
SELECT ISNULL (a.new_account_no,b.newaccountname) AS new_account_no,
ISNULL(a.opportunity_id, 'No_Opportunity') AS opportunity_id,
a.new_opportunity_name, a.est_completion_month_id, 
a.product_category, a.opportunity_stage, a.est_opportunity_value,b.newaccountname, b.industry
FROM
	(
	SELECT new_account_no, opportunity_id, new_opportunity_name,est_completion_month_id,product_category, opportunity_stage, est_opportunity_value  FROM public.ipi_opportunities_data
	--4,133 rows
	)a
	FULL JOIN
	(
	SELECT newaccountno, newaccountname,industry FROM public.ipi_account_lookup --1,145 rows
	)b
ON a.new_account_no = b.newaccountno
--4,133 rows on left join
--4,591 current rows


--EXAMPLE 3 - CROSS JOIN
SELECT * FROM public.ipi_opportunities_data
SELECT * FROM public.ipi_calendar_lookup

--Need to work on this so that I can change date column data type to date and have the below query work
ALTER TABLE public.ipi_calendar_lookup ALTER COLUMN date TYPE DATE

SELECT a.*, b.*
FROM
	(
	SELECT product_category, SUM(est_opportunity_value) FROM public.ipi_opportunities_data
	WHERE est_completion_month_id = (SELECT MAX(est_completion_month_id)-2 FROM public.ipi_opportunities_data)
	GROUP BY product_category
	)a
	CROSS JOIN
	(
	SELECT DISTINCT fiscal_month FROM public.ipi_calendar_lookup 
	WHERE fiscal_year='FY21' AND [date] > (SELECT GETDATE()+30)
	)b
	
----------UNION ALL STATEMENTS IN SQL----------
SELECT * FROM public.ipi_opportunities_data
SELECT * FROM public.ipi_calendar_lookup

--Example 1
SELECT product_category, SUM(est_opportunity_value) AS sum_opportunity_value FROM public.ipi_opportunities_data
GROUP BY product_category

UNION ALL
SELECT 'Totals:' as tempt_title, SUM(est_opportunity_value) AS sum_opportunity_value FROM public.ipi_opportunities_data

--Example 2
SELECT 'FY21-Q1' AS Quarter_Period, SUM(est_opportunity_value) AS sum_opportunity_value FROM public.ipi_opportunities_data
WHERE est_completion_month_id IN 
(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_quarter = 'FY21-Q1')

UNION ALL
SELECT 'FY21-Q2' AS Quarter_Period, SUM(est_opportunity_value) AS sum_opportunity_value FROM public.ipi_opportunities_data
WHERE est_completion_month_id IN 
(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_quarter = 'FY21-Q2')

UNION ALL
SELECT 'FY21-Q3' AS Quarter_Period, SUM(est_opportunity_value) AS sum_opportunity_value FROM public.ipi_opportunities_data
WHERE est_completion_month_id IN 
(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_quarter = 'FY21-Q3')

UNION ALL
SELECT 'FY21-Q4' AS Quarter_Period, SUM(est_opportunity_value) AS sum_opportunity_value FROM public.ipi_opportunities_data
WHERE est_completion_month_id IN 
(SELECT DISTINCT month_id FROM public.ipi_calendar_lookup WHERE fiscal_quarter = 'FY21-Q4')




