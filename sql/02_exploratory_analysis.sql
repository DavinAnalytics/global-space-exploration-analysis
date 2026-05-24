# 02_data_analysis.sql

SELECT *
from space_exploration;
-- 1. Which countries lead in space missions, and what's their efficiency?
SELECT 
	Country,
    COUNT(*) AS total_missions,
    ROUND(AVG(`Success Rate (%)`),2) AS average_success_rate,
    ROUND(AVG(`Budget (in Billion $)`),2) AS average_budget_in_billions,
    ROUND(AVG(`Success Rate (%)`)/AVG(`Budget (in Billion $)`), 2) AS success_per_billion_spent,
    ROUND(SUM(`Budget (in Billion $)`), 2) AS total_budget_in_billions,
    ROUND(SUM(`Budget (in Billion $)`)/COUNT(*), 2) AS budget_per_mission_in_billions,
    ROUND(AVG(`Duration (in Days)`)) AS average_duration_days
FROM space_exploration
GROUP BY Country
ORDER BY total_missions desc
;
-- China and UK are both leaders in number of space missions, but UK is more efficient (success per $billion spent)

-- 2. Year-over-Year Performance Trends
WITH yearly_stats AS (
	SELECT
        Year,
		COUNT(*) AS total_missions,
		ROUND(AVG(`Success Rate (%)`), 2) AS average_success_rate,
		ROUND(SUM(`Budget (in Billion $)`), 2) AS total_budget_in_billions,
		ROUND(AVG(`Duration (in Days)`)) AS average_duration_days
	FROM space_exploration
    GROUP BY Year
)

SELECT
    Year,
    total_missions,
    LAG(total_missions) OVER(ORDER BY Year) AS prev_year_missions,
    ROUND(total_missions - LAG(total_missions) OVER(ORDER BY Year), 2) AS yoy_missions_change,
    
    average_success_rate,
    LAG(average_success_rate) OVER(ORDER BY Year) as prev_year_success_rate,
    ROUND(average_success_rate - LAG(average_success_rate) OVER(ORDER BY Year), 2) AS yoy_success_change,
    
    total_budget_in_billions,
    LAG(total_budget_in_billions) OVER(ORDER BY Year) as prev_year_budget,
    ROUND(total_budget_in_billions - LAG(total_budget_in_billions) OVER(ORDER BY Year), 2) AS yoy_budget_change,
    
    average_duration_days
    
FROM yearly_stats
ORDER BY Year
;
    

-- 3. Which technology delivers the best success rate + cost efficiency?
WITH tech_efficiency AS (
	SELECT 
		`Technology Used`,
        COUNT(*) AS total_missions,
		ROUND(AVG(`Success Rate (%)`), 2) AS average_success_rate,
		ROUND(AVG(`Budget (in Billion $)`), 2) AS average_budget_in_billions,
        ROUND(AVG(`Duration (in Days)`), 0) AS average_duration_days,
		ROUND(AVG(`Success Rate (%)`)/AVG(`Budget (in Billion $)`), 2) AS success_per_billion_spent
	FROM space_exploration
	GROUP BY `Technology Used`
)
SELECT 
	`Technology Used`,
    total_missions,
	average_success_rate,
	average_budget_in_billions,
	success_per_billion_spent,
    average_duration_days,
    RANK() OVER(ORDER BY success_per_billion_spent DESC) AS cost_efficiency_rank,
    RANK() OVER (ORDER BY average_success_rate DESC) AS success_rate_rank
FROM tech_efficiency
ORDER BY success_per_billion_spent DESC
;
-- Resuable Rocket Tech has the best average chance of success (76.23%), but Nuclear propulsion is more cost-efficient (more success rate per billion spent)
-- While Reusable Rocket technology provides the highest mission success probability, 
-- Nuclear Propulsion offers superior cost-efficiency. 
-- A hybrid approach combining reusable systems with nuclear propulsion could deliver both high reliability and better budget optimization for future deep-space or long-duration missions.


-- 4. Mission type (Manned vs Unmanned) and their success rate and budget
SELECT 
	`Mission Type`,
	COUNT(*) AS total_missions,
	ROUND(AVG(`Success Rate (%)`), 2) AS average_success_rate,
	ROUND(AVG(`Budget (in Billion $)`), 2) AS average_budget_in_billions,
	ROUND(AVG(`Duration (in Days)`), 0) AS average_duration_days,
	ROUND(AVG(`Success Rate (%)`)/AVG(`Budget (in Billion $)`), 2) AS success_per_billion_spent
FROM space_exploration
GROUP BY `Mission Type`
ORDER BY average_success_rate DESC
;
-- Manned mission average success rate is higher, but cost-efficiency is about the same.

-- 5. How do international collaborations impact success and duration?
WITH collab_impact AS (
	SELECT 
		Total_Countries_Involved,
		COUNT(*) AS total_missions,
		ROUND(AVG(`Success Rate (%)`), 2) AS average_success_rate,
		ROUND(AVG(`Duration (in Days)`), 0) AS average_duration_days,
        ROUND(AVG(`Budget (in Billion $)`), 2) AS average_budget_in_billions
	FROM space_exploration
	GROUP BY Total_Countries_Involved
)
SELECT 
	Total_Countries_Involved,
    total_missions,
    average_success_rate,
    average_duration_days,
    average_budget_in_billions,
    RANK() OVER(ORDER BY average_success_rate DESC) AS success_rate_rank,
    RANK() OVER(ORDER BY average_duration_days ASC) AS duration_rank
FROM collab_impact
ORDER BY Total_Countries_Involved
;
-- The sweet spot number of countries collaborating was 3, in both average success rate and average duration length.
-- Solo launching had the worst average success rate and longest duration of the project
-- and solo launching cost about $1 billion more on average.

-- 6. Does Environmental Impact affect mission success rate and budget?
SELECT 
    `Environmental Impact`,
    ROUND(AVG(`Success Rate (%)`), 2) AS average_success_rate,
    ROUND(AVG(`Budget (in Billion $)`), 2) AS average_budget_in_billions,
    COUNT(*) AS total_missions
FROM space_exploration
GROUP BY `Environmental Impact`
ORDER BY `average_success_rate` DESC
;
-- Environmental impact level has very little effect on mission success rate or budget


-- 7. Most expensive missions and their results?
SELECT 
	`Mission Name`,
    Country,
    `Mission Type`,
    `Technology Used`,
	`Budget (in Billion $)`,
    `Success Rate (%)`,
    ROUND(`Success Rate (%)` / `Budget (in Billion $)`, 2) AS success_per_billion
FROM space_exploration
ORDER BY `Budget (in Billion $)` DESC
LIMIT 10
;

-- 8. Ranking Analysis: Top 10 missions by cost-effectiveness
SELECT 
	`Mission Name`,
	Country,
	`Technology Used`,
	`Budget (in Billion $)` AS budget_in_billions,
	`Success Rate (%)`,
	ROUND(`Success Rate (%)` / `Budget (in Billion $)`, 2) AS success_per_billion,
	RANK() OVER(ORDER BY `Success Rate (%)` / `Budget (in Billion $)` DESC) AS cost_effective_rank
FROM space_exploration
ORDER BY cost_effective_rank
LIMIT 10
;
-- The highest cost-efficiency comes from **low-budget missions** that still achieve solid success rates.
