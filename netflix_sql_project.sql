/* ============================================================
   NETFLIX WEEKLY TOP 10 DATA ANALYTICS PROJECT
   ============================================================
   Database : netflix_sql_project
   Tool     : MySQL 8.0+
   Dataset  : Netflix Weekly Top 10 (Official Engagement Report)
   Period   : 2021-07-04 to 2022-01-16 (29 weeks)
   Source   : Netflix Tudum (netflix.com/tudum/top10)

   Tables Used:
   1. netflix_country_ranking → Per-country weekly Top 10 (Films/TV)
   2. global_rankings          → Global weekly Top 10 (with hours viewed)

   Purpose:
   Import and analyze Netflix's published Top 10 chart data using SQL,
   from basic selection through joins and subqueries.
   ============================================================ */


/* ============================================================
   SECTION 1: CREATE DATABASE
  

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- Create the database for the Netflix SQL project;
CREATE DATABASE netflix_project;

-- Select the database
USE netflix_project;

-- Create the per-country weekly ranking table
CREATE TABLE netflix_countries (
    country_name                VARCHAR(100)  NOT NULL,
    country_iso2                CHAR(2)       NOT NULL,
    week                         DATE          NOT NULL,
    category                     VARCHAR(50)   NOT NULL,
    weekly_rank                  TINYINT       NOT NULL,
    show_title                   VARCHAR(255)  NOT NULL,
    season_title                 VARCHAR(255)  NULL,
    cumulative_weeks_in_top_10   INT           NOT NULL,
    PRIMARY KEY (country_iso2, week, category, weekly_rank)
);

DROP TABLE IF EXISTS netflix_country_ranking;

SHOW TABLES;


-- Create the global weekly ranking table
CREATE TABLE global_rankings (
    week                         DATE          NOT NULL,
    category                     VARCHAR(25)   NOT NULL,
    weekly_rank                  INT       NOT NULL,
    show_title                   VARCHAR(255)  NOT NULL,
    season_title                 VARCHAR(255)  NULL,
    weekly_hours_viewed          BIGINT        NOT NULL,
    cumulative_weeks_in_top_10   INT           NOT NULL,
    PRIMARY KEY (week, category, weekly_rank)
);


-- After creating both tables, import the two CSV files using the
-- MySQL Workbench Table Data Import Wizard:
--   all-weeks-countries.csv  →  netflix_countries
--   all-weeks-global.csv     →  global_rankings

LOAD DATA LOCAL INFILE "C:/Users/hp/Downloads/netflix_sql/all-weeks-global.csv"
INTO TABLE global_rankings
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(week, category, weekly_rank, show_title, season_title, weekly_hours_viewed, cumulative_weeks_in_top_10);



LOAD DATA LOCAL INFILE "C:/Users/hp/Downloads/netflix_sql/all-weeks-countries.csv"
INTO TABLE netflix_countries
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(country_name, country_iso2, week, category, weekly_rank, show_title, season_title, cumulative_weeks_in_top_10);

 ============================================================ */
/* =====================================================================
   1. PROJECT OVERVIEW
   =====================================================================

   Project Title:
   Netflix Weekly Top 10 - SQL Data Analytics Project

   Objective:
   Analyze Netflix's published weekly Top 10 chart data, at both the
   per-country and global level, using MySQL.

   Business Questions:
   - Which titles and categories generate the most viewing hours?
   - How does viewing activity change week to week?
   - Which countries chart the most diverse range of titles?
   - Which titles hold the #1 spot most often, locally and globally?
   - How does a title's global performance compare to its country-level
     popularity?
   - What additional business insights can be extracted using SQL?

   Skills Demonstrated:
   SELECT, DISTINCT, WHERE, IN, BETWEEN, LIKE, ORDER BY,
   GROUP BY, SUM, AVG, COUNT, MAX, MIN, HAVING, CASE,
   INNER JOIN, LEFT JOIN, NULLIF, and SUBQUERIES.

   ===================================================================== */


/* =====================================================================
   2. DATABASE & TABLE OVERVIEW
   =====================================================================

   1. netflix_country_ranking
      Country, week, category (Films/TV), weekly rank, show title,
      season title and cumulative weeks in the Top 10 — one row per
      country + week + category + rank. 54,520 rows, 94 countries.

   2. global_rankings
      Week, category (Films/TV split by English and Non-English),
      weekly rank, show title, season title, weekly hours viewed and
      cumulative weeks in the Top 10 — one row per week + category +
      rank, worldwide. 1,160 rows.

   NOTE: the two tables share no foreign key. They are two separate
   Netflix publications, linked only by show_title, week, and a
   collapsed category (Films/TV). This is addressed directly in the
   JOIN section below.

   ===================================================================== */


/* =====================================================================
   3. SQL ANALYSIS
   ===================================================================== */


/* =====================================================================
   A. SELECT & DISTINCT
   ===================================================================== */


/* Q01. Display all columns from the country ranking table. */

SELECT *
FROM netflix_countries;


/* Q02. Display only country, week, category and show title. */

SELECT
    country_name,
    week,
    category,
    show_title
FROM netflix_countries;


/* Q03. Display all unique countries available in the dataset. */

SELECT DISTINCT country_name
FROM netflix_countries
ORDER BY country_name;


/* Q04. Display all unique categories in the country ranking table. */

SELECT DISTINCT category
FROM netflix_countries
ORDER BY category;


/* Q05. Display all unique categories in the global ranking table. */

SELECT DISTINCT category
FROM global_rankings
ORDER BY category;


/* =====================================================================
   B. WHERE & FILTERING
   ===================================================================== */


/* Q06. Display all country-level records for the week 2021-07-04
       (the first week in the dataset). */

SELECT *
FROM netflix_countries
WHERE week = '2021-07-04';


/* Q07. Display all records for India. */

SELECT *
FROM netflix_countries
WHERE country_name = 'India';


/* Q08. Display all Films category records at country level. */

SELECT *
FROM netflix_countries
WHERE category = 'Films';


/* Q09. Display all records where a title held the #1 rank. */

SELECT *
FROM netflix_countries
WHERE weekly_rank = 1;


/* Q10. Display all global records for TV (English). */

SELECT *
FROM global_rankings
WHERE category = 'TV (English)';


/* Q11. Display all country-level records for the United States. */

SELECT *
FROM netflix_countries
WHERE country_iso2 = 'US';


/* Q12. Display only the top 3 ranked titles (rank 1 to 3) at
       country level. */

SELECT *
FROM netflix_countries
WHERE weekly_rank BETWEEN 1 AND 3;


/* Q13. Display global Films records (English or Non-English) ranked
       in the top 5. */

SELECT *
FROM global_rankings
WHERE category IN ('Films (English)', 'Films (Non-English)')
  AND weekly_rank <= 5;


/* Q14. Display country-level records for the United States, United
       Kingdom or India. */

SELECT *
FROM netflix_countries
WHERE country_iso2 IN ('US', 'GB', 'IN');


/* Q15. Display records where a title has been in the country Top 10
       for more than 10 cumulative weeks. */

SELECT *
FROM netflix_countries
WHERE cumulative_weeks_in_top_10 > 10;


/* Q16. Display show titles that start with the letter S. */

SELECT DISTINCT show_title
FROM netflix_countries
WHERE show_title LIKE 'S%'
ORDER BY show_title;


/* =====================================================================
   C. ORDER BY
   ===================================================================== */


/* Q17. Display the 20 global records with the highest weekly hours
       viewed. */

SELECT
    show_title,
    category,
    week,
    weekly_hours_viewed
FROM global_rankings
ORDER BY weekly_hours_viewed DESC
LIMIT 20;


/* Q18. Display the 20 country-level records with the longest
       cumulative streak in the Top 10. */

SELECT
    country_name,
    show_title,
    category,
    cumulative_weeks_in_top_10
FROM netflix_countries
ORDER BY cumulative_weeks_in_top_10 DESC
LIMIT 20;


/* Q19. Display country-level records with countries alphabetical and
       weeks newest to oldest. */

SELECT
    country_name,
    week,
    category,
    show_title
FROM netflix_countries
ORDER BY country_name ASC, week DESC;


/* Q20. Display global records with the lowest weekly hours viewed
       first. */

SELECT
    show_title,
    category,
    week,
    weekly_hours_viewed
FROM global_rankings
ORDER BY weekly_hours_viewed ASC
LIMIT 20;


/* =====================================================================
   D. GROUP BY & AGGREGATION
   ===================================================================== */


/* Q21. Find the total number of Top 10 slot-appearances for each
       country. */

SELECT
    country_name,
    COUNT(*) AS total_slot_rows
FROM netflix_countries
GROUP BY country_name
ORDER BY total_slot_rows DESC;


/* Q22. Find total hours viewed for each global category. */

SELECT
    category,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY category
ORDER BY total_hours_viewed DESC;


/* Q23. Find total hours viewed for each week. */

SELECT
    week,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY week
ORDER BY week;


/* Q24. Find the average weekly hours viewed for each global
       category. */

SELECT
    category,
    ROUND(AVG(weekly_hours_viewed), 0) AS avg_hours_per_title_week
FROM global_rankings
GROUP BY category
ORDER BY avg_hours_per_title_week DESC;


/* Q25. Find the number of distinct titles that charted in each
       country. */

SELECT
    country_name,
    COUNT(DISTINCT show_title) AS distinct_titles
FROM netflix_countries
GROUP BY country_name
ORDER BY distinct_titles DESC;


/* Q26. Find how many weeks each title appeared in the global Top 10. */

SELECT
    show_title,
    COUNT(*) AS weeks_in_global_top_10
FROM global_rankings
GROUP BY show_title
ORDER BY weeks_in_global_top_10 DESC;


/* Q27. Find the total hours viewed for each title across the entire
       dataset. */

SELECT
    show_title,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY show_title
ORDER BY total_hours_viewed DESC
LIMIT 20;


/* Q28. Find the total number of times each title held the #1 spot in
       the global chart. */

SELECT
    show_title,
    COUNT(*) AS weeks_at_rank_1
FROM global_rankings
WHERE weekly_rank = 1
GROUP BY show_title
ORDER BY weeks_at_rank_1 DESC;


/* Q29. Find total hours viewed by content type (Films vs TV,
       collapsing the English/Non-English split). */

SELECT
    CASE WHEN category LIKE 'Films%' THEN 'Films' ELSE 'TV' END AS content_type,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY CASE WHEN category LIKE 'Films%' THEN 'Films' ELSE 'TV' END
ORDER BY total_hours_viewed DESC;


/* Q30. Find the total number of times each title held the #1 spot in
       any country's Top 10. */

SELECT
    show_title,
    COUNT(*) AS country_weeks_at_rank_1,
    COUNT(DISTINCT country_name) AS distinct_countries_at_rank_1
FROM netflix_countries
WHERE weekly_rank = 1
GROUP BY show_title
ORDER BY country_weeks_at_rank_1 DESC;


/* =====================================================================
   E. HAVING
   ===================================================================== */


/* Q31. Find countries whose charted titles show above-average content
       diversity (more than 200 distinct titles across the dataset). */

SELECT
    country_name,
    COUNT(DISTINCT show_title) AS distinct_titles
FROM netflix_countries
GROUP BY country_name
HAVING COUNT(DISTINCT show_title) > 200
ORDER BY distinct_titles DESC;


/* Q32. Find titles with total global hours viewed above 500 million. */

SELECT
    show_title,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY show_title
HAVING SUM(weekly_hours_viewed) > 500000000
ORDER BY total_hours_viewed DESC;


/* Q33. Find titles that appeared in the global Top 10 more than
       10 times. */

SELECT
    show_title,
    COUNT(*) AS weeks_in_global_top_10
FROM global_rankings
GROUP BY show_title
HAVING COUNT(*) > 10
ORDER BY weeks_in_global_top_10 DESC;


/* Q34. Find titles that held the #1 spot in more than 100 distinct
       country-weeks. */

SELECT
    show_title,
    COUNT(*) AS country_weeks_at_rank_1
FROM netflix_countries
WHERE weekly_rank = 1
GROUP BY show_title
HAVING COUNT(*) > 100
ORDER BY country_weeks_at_rank_1 DESC;


/* Q35. Find global categories whose total hours viewed exceed
       5 billion. */

SELECT
    category,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY category
HAVING SUM(weekly_hours_viewed) > 5000000000
ORDER BY total_hours_viewed DESC;


/* =====================================================================
   F. CASE STATEMENTS
   ===================================================================== */


/* Q36. Categorize global title-weeks by hours viewed. */

SELECT
    show_title,
    week,
    weekly_hours_viewed,
    CASE
        WHEN weekly_hours_viewed > 100000000 THEN 'High'
        WHEN weekly_hours_viewed >= 30000000 THEN 'Medium'
        ELSE 'Low'
    END AS hours_category
FROM global_rankings;


/* Q37. Categorize country-level titles by how long they have stayed
       in the Top 10. */

SELECT
    country_name,
    show_title,
    cumulative_weeks_in_top_10,
    CASE
        WHEN cumulative_weeks_in_top_10 >= 15 THEN 'Long-Runner'
        WHEN cumulative_weeks_in_top_10 >= 5  THEN 'Established'
        ELSE 'New / Short-Lived'
    END AS longevity_category
FROM netflix_countries;


/* Q38. Classify countries by their content diversity level. */

SELECT
    country_name,
    COUNT(DISTINCT show_title) AS distinct_titles,
    CASE
        WHEN COUNT(DISTINCT show_title) >= 220 THEN 'High Diversity'
        WHEN COUNT(DISTINCT show_title) >= 150 THEN 'Medium Diversity'
        ELSE 'Lower Diversity'
    END AS diversity_category
FROM netflix_countries
GROUP BY country_name
ORDER BY distinct_titles DESC;


/* Q39. Classify global categories by total hours-viewed value tier. */

SELECT
    category,
    SUM(weekly_hours_viewed) AS total_hours_viewed,
    CASE
        WHEN SUM(weekly_hours_viewed) > 8000000000 THEN 'Very High Value'
        WHEN SUM(weekly_hours_viewed) > 4000000000 THEN 'High Value'
        ELSE 'Lower Value'
    END AS value_category
FROM global_rankings
GROUP BY category
ORDER BY total_hours_viewed DESC;


/* Q40. Classify each global title by whether it debuted at #1 in its
       first charting week or climbed the chart over time. */

WITH first_appearance AS (
    SELECT show_title, MIN(week) AS first_week
    FROM global_rankings
    GROUP BY show_title
)
SELECT
    g.show_title,
    g.week AS debut_week,
    g.weekly_rank AS debut_rank,
    CASE
        WHEN g.weekly_rank = 1 THEN 'Debuted at #1'
        ELSE 'Climbed to the chart'
    END AS debut_category
FROM global_rankings AS g
JOIN first_appearance AS f
  ON g.show_title = f.show_title AND g.week = f.first_week
ORDER BY g.week;


/* =====================================================================
   G. JOINS
   ===================================================================== */

/* NOTE: netflix_countries and global_rankings share no key.
   Every join below matches on show_title and week, with the global
   table's 4-way category (English/Non-English) collapsed to Films/TV
   so it lines up with the country table's 2-way category. */


/* Q41. Join country-level and global data to compare a title's local
       country rank with its global rank in the same week. */

SELECT
    ncr.country_name,
    ncr.show_title,
    ncr.week,
    ncr.weekly_rank AS country_rank,
    g.weekly_rank AS global_rank
FROM netflix_countries AS ncr
INNER JOIN global_rankings AS g
    ON ncr.show_title = g.show_title
   AND ncr.week = g.week
   AND ncr.category = CASE WHEN g.category LIKE 'Films%' THEN 'Films' ELSE 'TV' END
ORDER BY ncr.week, g.weekly_rank
LIMIT 50;


/* Q42. For each title-week present in both tables, compare how many
       countries carried it against its global hours viewed. */

SELECT
    g.show_title,
    g.week,
    g.weekly_hours_viewed,
    COUNT(DISTINCT ncr.country_name) AS countries_charting
FROM global_rankings AS g
INNER JOIN netflix_countries AS ncr
    ON g.show_title = ncr.show_title
   AND g.week = ncr.week
   AND ncr.category = CASE WHEN g.category LIKE 'Films%' THEN 'Films' ELSE 'TV' END
GROUP BY g.show_title, g.week, g.weekly_hours_viewed
ORDER BY g.weekly_hours_viewed DESC
LIMIT 20;


/* Q43. Find country-level titles that never appeared in the global
       Top 10 in the same week they charted locally. */

SELECT
    ncr.country_name,
    ncr.show_title,
    ncr.week
FROM netflix_countries AS ncr
LEFT JOIN global_rankings AS g
    ON ncr.show_title = g.show_title
   AND ncr.week = g.week
   AND ncr.category = CASE WHEN g.category LIKE 'Films%' THEN 'Films' ELSE 'TV' END
WHERE g.show_title IS NULL
LIMIT 50;


/* Q44. Find global Top 10 titles that were not charting in ANY
       country's Top 10 in that same week. */

SELECT
    g.show_title,
    g.week,
    g.category,
    g.weekly_hours_viewed
FROM global_rankings AS g
LEFT JOIN netflix_countries AS ncr
    ON g.show_title = ncr.show_title
   AND g.week = ncr.week
   AND ncr.category = CASE WHEN g.category LIKE 'Films%' THEN 'Films' ELSE 'TV' END
WHERE ncr.show_title IS NULL;
-- An empty result here would mean every globally charting title was also
-- charting in at least one country that same week -- worth stating either way.


/* Q45. Calculate hours viewed per charting country, for every
       title-week present in both tables. */

SELECT
    g.show_title,
    g.week,
    g.weekly_hours_viewed,
    COUNT(DISTINCT ncr.country_name) AS countries_charting,
    g.weekly_hours_viewed / NULLIF(COUNT(DISTINCT ncr.country_name), 0)
        AS hours_per_charting_country
FROM global_rankings AS g
INNER JOIN netflix_countries AS ncr
    ON g.show_title = ncr.show_title
   AND g.week = ncr.week
   AND ncr.category = CASE WHEN g.category LIKE 'Films%' THEN 'Films' ELSE 'TV' END
GROUP BY g.show_title, g.week, g.weekly_hours_viewed
ORDER BY hours_per_charting_country DESC
LIMIT 20;


/* =====================================================================
   H. SUBQUERIES
   ===================================================================== */


/* Q46. Find global records whose hours viewed is above the overall
       average hours viewed. */

SELECT
    show_title,
    category,
    week,
    weekly_hours_viewed
FROM global_rankings
WHERE weekly_hours_viewed >
(
    SELECT AVG(weekly_hours_viewed)
    FROM global_rankings
);


/* Q47. Find weeks whose total hours viewed is above the average
       weekly total across the dataset. */

SELECT
    week,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY week
HAVING SUM(weekly_hours_viewed) >
(
    SELECT AVG(weekly_total)
    FROM
    (
        SELECT week, SUM(weekly_hours_viewed) AS weekly_total
        FROM global_rankings
        GROUP BY week
    ) AS weekly_summary
)
ORDER BY total_hours_viewed DESC;


/* Q48. Find the title with the single highest total hours viewed in
       the entire dataset. */

SELECT
    show_title,
    SUM(weekly_hours_viewed) AS total_hours_viewed
FROM global_rankings
GROUP BY show_title
HAVING SUM(weekly_hours_viewed) =
(
    SELECT MAX(title_total)
    FROM
    (
        SELECT show_title, SUM(weekly_hours_viewed) AS title_total
        FROM global_rankings
        GROUP BY show_title
    ) AS title_summary
);


/* Q49. Find countries whose distinct-title count is above the average
       distinct-title count across all countries. */

SELECT
    country_name,
    COUNT(DISTINCT show_title) AS distinct_titles
FROM netflix_countries
GROUP BY country_name
HAVING COUNT(DISTINCT show_title) >
(
    SELECT AVG(country_titles)
    FROM
    (
        SELECT country_name, COUNT(DISTINCT show_title) AS country_titles
        FROM netflix_countries
        GROUP BY country_name
    ) AS country_summary
)
ORDER BY distinct_titles DESC;


/* Q50. Find titles whose global cumulative Top 10 streak is above the
       average streak across all titles that ever charted globally
       (correlated by title, non-correlated subquery for the average). */

SELECT
    show_title,
    MAX(cumulative_weeks_in_top_10) AS longest_global_streak
FROM global_rankings
GROUP BY show_title
HAVING MAX(cumulative_weeks_in_top_10) >
(
    SELECT AVG(title_max_streak)
    FROM
    (
        SELECT show_title, MAX(cumulative_weeks_in_top_10) AS title_max_streak
        FROM global_rankings
        GROUP BY show_title
    ) AS streak_summary
)
ORDER BY longest_global_streak DESC;


/* =====================================================================
   4. KEY INSIGHTS
   =====================================================================

   ---------------------------------------------------------------------
   BUSINESS & DATA ANALYSIS INSIGHTS
   ---------------------------------------------------------------------

   1. Across all 29 weeks, Netflix's global Top 10 lists recorded a
      combined 23,006,520,000 hours viewed.

   2. TV titles accounted for approximately 71.6% of total hours
      viewed (16.48B hours), compared to 28.4% for Films (6.53B
      hours) -- TV dominates global engagement by a wide margin.

   3. Squid Game is the single biggest hit in the dataset: ~2.27
      billion total hours viewed and the longest global streak at
      18 cumulative weeks in the Top 10.

   4. Money Heist (~1.15B hours) and You (~777M hours) round out the
      top 3 titles by total global hours viewed.

   5. Every one of the 94 countries recorded exactly 580 Top 10 rows
      (29 weeks x 10 ranks x 2 categories), confirming complete data
      coverage with no missing weeks or categories for any country.

   6. New Zealand (266), Canada (257) and Trinidad and Tobago (256)
      charted the widest range of distinct titles, indicating the
      most turnover in their Top 10 lists.

   7. Several titles -- including Red Notice, The Unforgivable, The
      Guilty, Army of Thieves and Love Hard -- reached the Top 10 in
      all 94 countries, the maximum possible reach in this dataset.

   8. Multiple titles (e.g. Pasion de Gavilanes, Yo soy Betty, la fea)
      held a Top 10 spot in individual countries for the full 29-week
      window -- the maximum possible country-level streak.

   9. Squid Game held the #1 spot in 491 country-weeks -- more than
      any other title -- followed by Money Heist (298) and Red Notice
      (245).

   10. 44 distinct titles debuted directly at #1 in the global chart,
       rather than climbing up from a lower rank in their first
       charting week.

   11. On average, a title stayed in the global Top 10 for about 2.67
       weeks -- most global hits are short-lived compared to the
       small number of multi-month sustained hits like Squid Game.

   12. Global weekly viewing peaked in the week of 2021-10-03 at
       1,269,750,000 total hours viewed, and was lowest in the week
       of 2021-08-29 at 516,800,000 hours -- more than a 2x swing.

   13. Total global hours viewed grew approximately 16.2% from the
       first week of the dataset (2021-07-04) to the last
       (2022-01-16).

   14. 2,006 distinct titles appeared across all countries' Top 10
       lists, but only 401 of those titles ever reached the global
       Top 10 -- most country-level hits never break out globally.

   ---------------------------------------------------------------------
   OVERALL PROJECT INSIGHT
   ---------------------------------------------------------------------

   The analysis shows that Netflix's engagement is heavily
   concentrated: a small number of titles (led by Squid Game) drive a
   disproportionate share of total viewing hours and country reach,
   while most titles that reach a country's Top 10 never make the
   much smaller global Top 10. TV content outperforms Films by a wide
   margin in total hours viewed, and weekly totals show meaningful
   swings across the 29-week window rather than a flat trend.

   =====================================================================
*/

/* =====================================================================
   PROJECT CONCLUSION
   =====================================================================

   This project demonstrates how MySQL can be used to move from raw
   Netflix Top 10 chart data to structured content-performance
   analysis.

   The analysis covers:
   - Data selection and filtering
   - Aggregation and ranking
   - Business segmentation using CASE
   - Multi-table analysis using JOINs (with a disclosed no-shared-key
     caveat between the two source tables)
   - Benchmarking using subqueries
   - Content-diversity and country-reach analysis

   Final workflow:

       DATASET
          |
       DATABASE
          |
       TABLES
          |
       SQL QUESTIONS
          |
       QUERY RESULTS
          |
       BUSINESS INSIGHTS
          |
       DASHBOARD / DECISION SUPPORT

   =====================================================================
   END OF NETFLIX WEEKLY TOP 10 SQL ANALYTICS PROJECT
   =====================================================================
*/


