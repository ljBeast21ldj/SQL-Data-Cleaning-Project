# US Household Income Data Cleaning Project
SELECT * 
FROM us_household_income
;

SELECT *
FROM us_household_income_statistics;

# Checking the id COUNT on each dataset to see if all the rows came in from the import

SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;

# Checking for duplicates in us_household_income
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

# Identifying the row numbers and ids that have duplicates if any

SELECT *
FROM (
	SELECT
    row_id,
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income
) duplicates
WHERE row_num > 1;

# Deleting duplicate rows

DELETE FROM us_household_income
WHERE row_id IN
(	SELECT row_id
	FROM (
		SELECT
		row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income
	) duplicates
WHERE row_num > 1);

# Checking for duplicates in us_household_income_statistics
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

# Identifying the row numbers and ids that have duplicates if any
SELECT *
FROM (
	SELECT
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income_statistics
) duplicates
WHERE row_num > 1;

# Deleting duplicate rows

DELETE FROM us_household_income_statistics
WHERE id IN
(	SELECT id
	FROM (
		SELECT
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income_statistics
	) duplicates
WHERE row_num > 1);

SELECT *
FROM us_household_income;

# Counting how many times each state name has been entered in the table and also check for misspellings 
SELECT State_Name, COUNT(State_Name) state_count
FROM us_household_income
GROUP BY State_Name;

SELECT *
FROM us_household_income_statistics;

# I found a misspelling so I updated the table to spell the state name correctly
-- UPDATE us_household_income
-- SET State_Name = 'Georgia'
-- WHERE State_Name = 'georgia'; 

# checking to see if the area of land and water has 0s, blanks, or NULLs in the rows
SELECT ALand, AWater
FROM us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL);
