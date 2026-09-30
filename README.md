# Netflix Weekly Top 10 - SQL Data Analytics Project

## Overview

A SQL portfolio project analyzing Netflix's officially published weekly Top
10 charts — both per-country and global — covering 29 weeks of data from
**2021-07-04 to 2022-01-16**. The project moves from basic `SELECT`
statements through filtering, aggregation, `CASE` segmentation, joins and
subqueries, with each section building on the last.

> **Disclaimer:** This is an independent educational portfolio project. It
> is not affiliated with or endorsed by Netflix.

## Tools and data

- **Database:** MySQL 8.0+
- **Database tool:** MySQL Workbench
- **Language:** SQL
- **Data source:** Netflix's official weekly Top 10 report ([netflix.com/tudum/top10](https://www.netflix.com/tudum/top10))
- **Dataset period:** 4 July 2021 to 16 January 2022 (29 weekly snapshots)

## Tables used

| Table                     | Grain                                         | Row count |
| -------------------------- | ----------------------------------------------- | --------- |
| `netflix_countries`  | One row per country + week + category + rank   | 54,520    |
| `global_rankings`          | One row per week + category + rank (worldwide) | 1,160     |

`netflix_countries.category` uses a 2-way split (`Films` / `TV`).
`global_rankings.category` uses a 4-way split by language (`Films
(English)`, `Films (Non-English)`, `TV (English)`, `TV (Non-English)`).
**The two tables share no foreign key** — they are two separate Netflix
publications, linked only by `show_title` and `week`. Every JOIN query in
this project collapses the global table's category down to Films/TV before
joining, and that choice is called out directly in the SQL comments.

## Business questions

- Which titles and categories generate the most viewing hours?
- How does viewing activity change week to week?
- Which countries chart the most diverse range of titles?
- Which titles hold the #1 spot most often, locally and globally?
- How does a title's global performance compare to its country-level popularity?

## Skills demonstrated

`SELECT`, `DISTINCT`, `WHERE`, `IN`, `BETWEEN`, `LIKE`, `ORDER BY`,
`GROUP BY`, `SUM`, `AVG`, `COUNT`, `MAX`, `MIN`, `HAVING`, `CASE`,
`INNER JOIN`, `LEFT JOIN`, `NULLIF`, and subqueries (including nested
and correlated forms).

## Question structure (easy → hard)

| Section                  | Questions | What it covers                                            |
| -------------------------- | --------- | ------------------------------------------------------------ |
| A. SELECT & DISTINCT        | Q01–Q05   | Basic column selection, distinct values                     |
| B. WHERE & filtering        | Q06–Q16   | Filtering by date, country, category, rank, IN/BETWEEN/LIKE |
| C. ORDER BY                 | Q17–Q20   | Sorting by hours viewed, streak length, date                |
| D. GROUP BY & aggregation   | Q21–Q30   | SUM/AVG/COUNT by country, category, week, title             |
| E. HAVING                   | Q31–Q35   | Filtering aggregated groups against thresholds               |
| F. CASE statements          | Q36–Q40   | Segmenting titles and countries into categories/tiers         |
| G. JOINS                    | Q41–Q45   | Linking country-level and global data (with the no-key caveat) |
| H. SUBQUERIES               | Q46–Q50   | Nested, non-correlated and grouped-average comparisons        |

## How to run

1. Run `CREATE DATABASE netflix_sql_project;` and `USE netflix_sql_project;`.
2. Run the two `CREATE TABLE` statements at the top of the SQL file.
3. Import `all-weeks-countries.csv` into `netflix_country_ranking` and
   `all-weeks-global.csv` into `global_rankings` using MySQL Workbench's
   Table Data Import Wizard.
4. Open `netflix_top10_sql_analytics_project.sql` in MySQL Workbench and run
   the questions in order — each section assumes the basics from the
   sections before it.

## Key insights

- Netflix's global Top 10 lists recorded a combined **23.0 billion** hours
  viewed across the 29 weeks.
- **TV titles drove ~71.6%** of total hours viewed versus **~28.4%** for
  Films.
- **Squid Game** is the standout hit: **~2.27 billion** total hours viewed
  and the longest global streak at **18 weeks**, plus **491 country-weeks**
  at #1 — more than any other title.
- Every one of the **94 countries** has complete 29-week coverage across
  both categories, with no missing weeks.
- **2,006** distinct titles reached a country's Top 10, but only **401**
  ever reached the global Top 10 — most local hits never break out globally.
- Weekly global viewing swung more than 2x across the dataset, from a low
  of **516.8M hours** (week of 2021-08-29) to a peak of **1.27B hours**
  (week of 2021-10-03).

## Limitations

- Netflix does not publish per-country hours viewed — only rank and streak
  length are available at country level.
- The two source tables share no key; every cross-table JOIN in this
  project matches on `show_title` + `week` with category collapsed to
  Films/TV, which is disclosed rather than treated as a guaranteed match.
- The 29-week window right-censors any title still charting in the final
  week — its true total run may extend beyond the dataset.

## Data source

[Netflix Top 10 — official weekly engagement reports](https://www.netflix.com/tudum/top10)
