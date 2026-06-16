# Streaming Platform Quality Analysis

## Project Overview
This analysis examines whether larger streaming libraries deliver 
higher quality content, or whether smaller curated platforms 
outperform on quality metrics. Built as a portfolio piece 
demonstrating SQL data engineering and Tableau visualization skills.

## Data Sources
- TMDB (The Movie Database) — via Kaggle — 37,955 titles across movies and TV shows
- Dataset includes Platform availability, Genre classifications, User ratings, and Vote Counts 
- Analysis period: 2021–2025
- Quality metric: TMDB weighted average rating (minimum 100 votes 
  for movies, 50 for TV shows)
- Note: Data represents a snapshot of platform availability and 
  does not reflect real time library changes

  ## Key Findings
1. Library size alone doesn't determine quality. Criterion Channel 
   outperforms Netflix on weighted average rating with under 10% 
   of its catalog size.

2. Genre influences ratings more than platform does. Horror scores 
   structurally lower than Drama or Sci-Fi across every platform 
   in the dataset — Shudder's below average overall rating reflects 
   this genre ceiling, not poor curation.

3. A24's impact varies by platform and is limited by small sample 
   sizes outside of HBO Max, which carries 21 qualified A24 titles. 
   On Amazon, A24 titles rate 0.22 points above the platform baseline. 
   Results on Netflix and Hulu are directional only given fewer 
   than 5 qualified titles each.

4. Platform library sizes contracted meaningfully after 2022 across 
   Netflix, Disney Plus, and Hulu. Average quality scores did not 
   improve proportionally over the same period.

  ## Technical Stack
- SQL Server 2025 Express — data storage and querying
- SQL Server Management Studio 22 — query development
- Tableau Public — visualization and dashboard
- GitHub — version control and portfolio hosting

## Repository Contents
- /queries — six SQL query files
- /data — cleaned CSV exports used in Tableau
