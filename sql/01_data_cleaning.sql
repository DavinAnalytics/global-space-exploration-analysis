# 01_data_cleaning.sql

-- 1. Created a clean back up table via Table Data Import Wizard
-- 2. Check row count
SELECT COUNT(*) AS total_rows
FROM space_exploration;

-- 3. Check for duplicates
SELECT Country, Year, `Mission Name`, COUNT(*) as duplicate_count
FROM space_exploration
GROUP BY Country, Year, `Mission Name`
HAVING COUNT(*) > 1;
-- No duplicates found

-- 4. Check for Nulls in important columns
 SELECT 
	COUNT(*) AS total_rows,
    COUNT(CASE WHEN Country IS NULL THEN 1 END) AS null_country,
    COUNT(CASE WHEN Year IS NULL THEN 1 END) AS null_year,
    COUNT(CASE WHEN `Mission Name` IS NULL THEN 1 END) AS null_mission_name,
    COUNT(CASE WHEN `Mission Type` IS NULL THEN 1 END) AS null_mission_type,
    COUNT(CASE WHEN `Budget (in Billion $)` IS NULL THEN 1 END) AS null_budget,
    COUNT(CASE WHEN `Success Rate (%)` IS NULL THEN 1 END) AS null_success_rate,
    COUNT(CASE WHEN `Technology Used` IS NULL THEN 1 END) AS null_technology,
    COUNT(CASE WHEN `Duration (in Days)` IS NULL THEN 1 END) AS null_duration,
    COUNT(CASE WHEN `Collaborating Countries` IS NULL THEN 1 END) AS null_collaborators
FROM space_exploration;
-- No nulls found

-- 5. Standardize text columns (trim extra spaces)
UPDATE space_exploration
SET 
    `Collaborating Countries` = TRIM(`Collaborating Countries`),
    `Technology Used` = TRIM(`Technology Used`),
    `Environmental Impact` = TRIM(`Environmental Impact`),
    `Mission Type` = TRIM(`Mission Type`),
    `Country` = TRIM(`Country`),
    `Satellite Type` = TRIM(`Satellite Type`),
    `Launch Site` = TRIM(`Launch Site`);
	
-- 6. Add Total Countries Involved column for more possible insight later on
ALTER TABLE space_exploration
ADD COLUMN Total_Countries_Involved INT;

UPDATE space_exploration
SET Total_Countries_Involved =
	(LENGTH(`Collaborating Countries`) - LENGTH(REPLACE(`Collaborating Countries`, ',', '')) + 1);
-- Counts commas then adding 1 to count countries since number of countries = number of commas + 1


-- Noticed `Collaborating Countries` column is inconsistent. `Collaborating Countries` sometimes has main country launching included, sometimes not.
-- Select statement to see the columns before updating it
SELECT 
    Country,
    `Collaborating Countries` AS Original,
CASE
        WHEN `Collaborating Countries` IS NULL 
          OR TRIM(`Collaborating Countries`) = '' 
          OR TRIM(`Collaborating Countries`) = 'nan'
        THEN `Country`
        WHEN TRIM(`Collaborating Countries`) LIKE CONCAT('%', TRIM(`Country`), '%')
        THEN `Collaborating Countries`
        ELSE CONCAT(TRIM(`Country`), ', ', TRIM(`Collaborating Countries`))
    END AS New_Collaborating_Countries
FROM space_exploration;

-- 7. Fix Collaborating Countries (include main country)
UPDATE space_exploration
SET `Collaborating Countries` = 
CASE
	WHEN `Collaborating Countries` IS NULL 
		OR TRIM(`Collaborating Countries`) = '' 
        OR TRIM(`Collaborating Countries`) = 'nan'
		THEN `Country`
    
    WHEN TRIM(`Collaborating Countries`) LIKE CONCAT('%', TRIM(`Country`), '%')
		THEN `Collaborating Countries` -- Already contains country
	ELSE CONCAT(`Country`, ', ' , TRIM(`Collaborating Countries`)) -- If not, add country
END;


    