# Global Space Exploration Analysis

## Project Overview

**Objective:** Analyze 30 years of global space missions to identify trends in exploration strategy, budget efficiency, and mission success rates across countries and mission types."]

**Dataset:** Global Space Exploration Dataset (3,000+ mission records across multiple countries and decades)

**Tools & Technologies:** SQL, Python, Data Visualization

**Repository:** [https://github.com/DavinAnalytics/global-space-exploration-analysis]

---

## Table of Contents
- [Problem Statement](#problem-statement)
- [Data Source](#data-source)
- [Data Cleaning & Preparation](#data-cleaning--preparation)
- [Analysis & Insights](#analysis--insights)
- [Visualizations](#visualizations)
- [Skills Demonstrated](#skills-demonstrated)
- [How to Reproduce](#how-to-reproduce)
- [Next Steps](#next-steps)

---

## Problem Statement

**What question are we answering?**

1. Which countries lead in space missions, and what's their efficiency?
2. Year-over-Year Performance Trends (Advanced: CTEs + Window functions — LAG for YoY changes)
3. Which technology delivers the best success rate + cost efficiency?
4. Mission type (Manned vs Unmanned) and their success rate and budget
5. How do international collaborations impact success and duration?
6. Environmental Impact by Mission Type/Satellite Type?
7. Most expensive missions and their results?
8. Ranking Analysis: Top 10 missions by cost-effectiveness (Success Rate per Billion $ spent) (Window functions — RANK)

**Why does this matter?**

[1-2 sentences on relevance - who cares about this answer and why]

---

## Data Source

**Dataset Name:** Global Space Exploration Dataset (2000-2025) by Atharva Soundankar

**Size:** 3,000 records, 12 columns

**Time Period:** 2000 - 2025

**Geographic Coverage:** China, France, Germany, India, Israel, Japan, Russia, UAE, UK, USA

**Source:** Kaggle - https://www.kaggle.com/datasets/atharvasoundankar/global-space-exploration-dataset-2000-2025

**Columns Included:**
- Country
- Year
- Mission Name
- Mission Type
- Launch Site
- Satellite Type
- Budget (in Billion $)
- Success Rate (%)
- Technology Used
- Environmental Impact
- Collaborating Countries
- Total_Countries_Involved
- Duration (in Days)


---

## Data Cleaning & Preparation

**Status: Completed**

### Overview
I performed comprehensive data cleaning on the Global Space Exploration Dataset to ensure data quality and usability for analysis. 
This step was critical as the raw dataset contained several real-world inconsistencies typical of messy operational data.

### Key Issues Identified & Resolved

| Issue | Description | Resolution |
|-------|-------------|----------|
| Inconsistent `Collaborating Countries` | Main launching country was sometimes included, sometimes missing from the list | Developed custom `CASE` logic to **always include the launching `Country`** at the beginning of the list |
| Missing / Invalid Values | Empty cells imported as string `'nan'`, empty strings, and `NULL` values | Handled all variations using `IS NULL`, `TRIM()`, and string comparison |
| Extra Whitespace | Inconsistent formatting in text columns | Applied `TRIM()` across all text-based columns |
| Lack of Derived Metrics | No easy way to analyze level of international collaboration | Added new column `Total_Countries_Involved` using string functions |

### Cleaning Steps Performed

- Verified total row count and checked for duplicate records
- Conducted null/missing value analysis across all key columns
- Standardized text data using `TRIM()`
- Fixed `Collaborating Countries` logic using conditional `CASE` statements, `CONCAT()`, and `LIKE` operators
- Created calculated column `Total_Countries_Involved` (number of countries per mission)
- Added detailed documentation and comments in the SQL script

### Tools & Techniques Used
- **MySQL** 
- SQL functions: `TRIM()`, `CONCAT()`, `CASE`, `LENGTH()`, `REPLACE()`
- Conditional logic for real-world data cleaning

**Full Cleaning Script:** [`sql/01_data_cleaning.sql`](sql/01_data_cleaning.sql)
```
---

## Analysis & Insights

### Key Findings

**1. Leading countries in space missions and their efficiency**

**Insight:**  
China and the UK lead significantly in mission volume with 322 missions each. However, the UK shows slightly better cost-efficiency.

**Supporting Data:**
- China: 322 missions, 74.99% avg success rate, $25.66B avg budget
- UK: 322 missions, 75.04% avg success rate, **$24.93B** avg budget (most efficient among top countries)

**Implication for Aerospace Industry:**  
This highlights strong competition from international players. 
Companies like SpaceX, NASA, and Blue Origin should focus on cost-efficiency strategies to maintain competitive advantage in the global market.

---

**2. Year-over-Year Performance Trends**

**Insight:**  
Mission volume and success rates have remained relatively stable over 25 years with moderate year-to-year fluctuations.

**Supporting Data:**
- Average missions per year: ~115
- Average success rate: ~75% (stable range: 72–78%)
- No strong long-term upward trend in success rate despite increasing budgets.

**Implication:**  
Technological maturity appears more important than simply increasing spending. This supports sustained R&D investment rather than short-term budget spikes.

---

**3. Technology Efficiency Comparison**

**Insight:**  
Reusable Rocket technology has the highest success rate, while Nuclear Propulsion offers the best cost-efficiency.

**Supporting Data:**
| Technology Used     | Avg Success Rate | Success per Billion | Cost-efficiency Rank |
|---------------------|------------------|---------------------|----------------------|
| Reusable Rocket     | **76.23%**       | 2.99                | 2                    |
| Nuclear Propulsion  | 74.60%           | **3.05**            | 1                    |
| Solar Propulsion    | 74.63%           | 2.94                | 3                    |

**Implication:**  
Hybrid approaches combining reusable systems with nuclear propulsion could deliver optimal results for future missions.

---

### 4. Mission type (Manned vs Unmanned) and their success rate and budget

**Insight:**  
Manned missions have a slightly higher success rate than Unmanned missions, while cost-efficiency remains nearly identical.

**Supporting Data:**
- Manned: 1,528 missions, **75.23%** success rate, $25.46B avg budget
- Unmanned: 1,472 missions, 74.73% success rate, $25.40B avg budget

**Implication for Aerospace:**  
The additional complexity and cost of manned missions is justified by improved outcomes. This validates continued investment in crewed spaceflight programs.

---

### 5. How do international collaborations impact success and duration?

**Insight:**  
Collaborations involving 3 countries represent the clear sweet spot, delivering the highest average success rate and shortest mission duration. 
Solo missions performed the worst across nearly all metrics, including significantly higher costs, though they represent a smaller sample size.

**Supporting Data:**
| Countries Involved  | Total Missions   | Average Success Rate | Average Duration (days)| Average Budget($B) | Success Rank | Duration Rank
|---------------------|------------------|----------------------|------------------------|-----------------
| 1 (Solo)            | **92**           | 73.03%               | **186**                | **26.28**          | 4            | 4
| 2                   | 1,146            | 74.83%               | 181                    | 25.33              | 3            | 2
| 3                   | 1,071            | **75.36%**           | 180                    | 25.49              | **1**        | **1**
| 4                   | 691              | 74.92%               | 183                    | 25.39              | 2            | 3

**Implication for Aerospace:**   
This analysis strongly supports forming strategic partnerships.
Collaborating with reliable partners can meaningfully improve mission success probability, reduce development timelines, and lower overall costs. 
This is especially valuable for complex, high-stakes programs such as lunar landings, Mars missions, or defense-related space projects.

---

### 6. Environmental Impact on mission success rate and budget

**Insight:**  
The environmental impact level has minimal overall effect on the mission success rate. 
Missions with medium environmental impact show slightly higher success rates, while high impact missions actually have the lowest success rate.

**Supporting Data:**
| Environmental Impact | Avg Success Rate | Avg Budget ($B)  | Total Missions | 
|----------------------|------------------|------------------|----------------|
| High                 | 74.50%           | 25.44            | 958            |
| Medium               | **75.33%**       | 25.68            | 1032           |
| Low                  | 75.09%           | **25.17**        | 1010           | 


**Implication for Aerospace:**  
The environmental impact from the dataset does not appear to be a major driver of mission success or cost. 
This suggests that companies like SpaceX, NASA, and Blue Origin can puruse more sustainable missions without significantly sacrificing performance or increasing budgets.
Sustainability and mission reliability can be optimized in parallel rather than as a trade-off.

---

### 7. Most expensive missions and their results?

**Insight:**  
Even at the highest budget tier (~$50B), success rates vary dramatically (from 50% to 100%). This suggests that technology choice and execution matter more than raw budget.

**Supporting Data:**
| Mission Name                          | Country   | Mission Type | Technology Used    | Budget ($B) | Success Rate | success_per_billion |
|---------------------------------------|-----------|--------------|--------------------|-------------|--------------|---------------------| 
| Automated uniform forecast            | France    | Manned       | AI Navigation      | **49.97**   | 83%          | 1.66                |
| Implemented global time-frame         | China     | Manned       | Traditional Rocket | **49.97**   | 55%          | 1.1                 |
| De-engineered coherent infrastructure | Japan     | Manned       | Solar Propulsion   | 49.93       | 50%          | 1                   |
| Centralized 5thgeneration core        | Israel    | Manned       | Reusable Rocket    | 49.92       | **97%**      | **1.94**            |
| Multi-layered 24hour adapter          | USA       | **Unmanned** | Solar Propulsion   | 49.92       | 67%          | 1.34                |               

**Implication for Aerospace:**  
This highlights the risk of massive budget overruns without corresponding success guarantees. 
Focusing on proven technologies (like Reusable Rockets) and strong project management may deliver better outcomes than simply increasing spending.

---

### 8. Ranking Analysis: Top 10 missions by cost-effectiveness (Success Rate per Billion $)

**Insight:**  
[Write insight after running the query]

**Supporting Data:**
- Top 3–5 missions with highest success-per-billion

**Implication for Aerospace:**  
[What high-efficiency missions teach us about future design]

**Queries & Methods:**
- Aggregations, groupings, and window functions in SQL
- Custom calculated columns (e.g., `Total_Countries_Involved`)
- Comparative analysis between countries and mission types

**Full analysis available in:** [`sql/02_exploratory_analysis.sql`](sql/02_exploratory_analysis.sql)

---

## Visualizations

### Chart 1: [Title]
**What it shows:** [Brief description]
**Key takeaway:** [One sentence insight]
![Chart 1](./visualizations/chart_1.png)

### Chart 2: [Title]
**What it shows:** [Brief description]
**Key takeaway:** [One sentence insight]
![Chart 2](./visualizations/chart_2.png)

### Chart 3: [Title]
**What it shows:** [Brief description]
**Key takeaway:** [One sentence insight]
![Chart 3](./visualizations/chart_3.png)

---

## Skills Demonstrated

**SQL Proficiency**
- Data cleaning and validation
- Aggregate functions (COUNT, SUM, AVG, MAX, MIN)
- JOIN operations
- Window functions (RANK, ROW_NUMBER, LAG, LEAD)
- Common Table Expressions (CTEs)
- Subqueries and complex filtering

**Data Cleaning & Preparation**
- Conducted full data quality checks (duplicates, nulls, and `'nan'` values)
- Standardized text columns using `TRIM()`
- Resolved inconsistent `Collaborating Countries` field using conditional logic (`CASE`, `CONCAT`, `LIKE`)
- Added derived column `Total_Countries_Involved` for better collaboration analysis
- Documented all steps in `sql/01_data_cleaning.sql`

**Analytical Thinking**
- Formulating business questions
- Breaking down complex problems
- Data-driven insights
- Pattern recognition

**Visualization & Communication**
- Creating clear, actionable charts
- Telling a data story
- Documenting findings for stakeholders

**Tools**
- MySQL/SQL Database
- [Python/Pandas if used]
- [Excel/Tableau/Power BI if used]
- Git & GitHub
- [Other tools]

---

## How to Reproduce

### Prerequisites
- MySQL or [database system]
- Python 3.8+ (if applicable)
- Libraries: pandas, matplotlib, seaborn (if applicable)

### Steps to Run

**1. Load the data into database:**
```bash
# Import raw CSV into MySQL
mysql -u [username] -p [database_name] < data/raw_data.sql
```

**2. Run the data cleaning script:**
```bash
# Execute cleaning operations
mysql -u [username] -p [database_name] < sql/01_data_cleaning.sql
```

**3. Run exploratory analysis:**
```bash
# Analyze cleaned data
mysql -u [username] -p [database_name] < sql/02_exploratory_analysis.sql
```

**4. Generate visualizations (if using Python):**
```bash
python visualizations/generate_plots.py
```

**5. Review results:**
- Check output in `/visualizations/`
- Review findings in this README

---

## Project Structure

```
global-space-exploration-analysis/
├── README.md                          # This file
├── data/
│   ├── raw_data_sample.csv           # Sample of original data (for reference)
│   └── cleaned_data_sample.csv       # Sample of cleaned data (for reference)
├── sql/
│   ├── 01_data_cleaning.sql          # Data cleaning queries with documentation
│   ├── 02_exploratory_analysis.sql   # EDA queries
│   └── 03_key_insights.sql           # Advanced analysis queries
├── visualizations/
│   ├── chart_1.png
│   ├── chart_2.png
│   ├── chart_3.png
│   └── generate_plots.py             # Python script to create visualizations (if used)
└── .gitignore                        # Git configuration
```

---

## Next Steps

**Future Enhancements:**
- [ ] Add predictive modeling (e.g., predict mission success)
- [ ] Expand to include real-time data updates
- [ ] Create interactive dashboard (Tableau/Power BI)
- [ ] Perform statistical testing on findings
- [ ] [Add your own ideas]

**Learnings for Future Projects:**
- [What worked well in this project?]
- [What would you do differently next time?]
- [Skills to develop further?]

---

## Contact & Questions

**Author:** [Davin Kim]
**Date Completed:** [MM/YYYY]
**GitHub:** [https://github.com/DavinAnalytics]
**LinkedIn:** [Your LinkedIn profile link - helpful for job search!]

If you have questions about the analysis or data methodology, feel free to reach out!

---


## Acknowledgments

- Dataset source: [Global Space Exploration Dataset (2000-2025) by Atharva Soundankar. https://www.kaggle.com/datasets/atharvasoundankar/global-space-exploration-dataset-2000-2025]


