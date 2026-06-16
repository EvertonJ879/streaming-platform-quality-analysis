-- Shows catalog tier distribution by calculating the exact percentage footprint of Elite, Good, and Poor content
-- Applies explicit conditional logic (CASE WHEN) alongside standard engagement filters to capture catalog depth


SELECT 
    p.platform AS platform,
    COUNT(*) AS qualified_titles,
    ROUND(100.0 * COUNT(CASE WHEN r.vote_average >= 8.0 THEN 1 END) / COUNT(*), 2) AS pct_elite_above_8,
    ROUND(100.0 * COUNT(CASE WHEN r.vote_average >= 7.0 THEN 1 END) / COUNT(*), 2) AS pct_good_above_7,
    ROUND(100.0 * COUNT(CASE WHEN r.vote_average < 5.0 THEN 1 END) / COUNT(*), 2) AS pct_poor_below_5
FROM content_platforms p
INNER JOIN ratings r 
    ON p.tmdb_id = r.tmdb_id 
    AND p.content_type = r.content_type
WHERE 
    (p.content_type = 'movie' AND r.vote_count >= 100)
    OR 
    (p.content_type = 'tvshow' AND r.vote_count >= 50)
GROUP BY p.platform

UNION ALL

SELECT 
    'A24 (Prestige Benchmark)' AS platform,
    COUNT(*) AS qualified_titles,
    ROUND(100.0 * COUNT(CASE WHEN r.vote_average >= 8.0 THEN 1 END) / COUNT(*), 2) AS pct_elite_above_8,
    ROUND(100.0 * COUNT(CASE WHEN r.vote_average >= 7.0 THEN 1 END) / COUNT(*), 2) AS pct_good_above_7,
    ROUND(100.0 * COUNT(CASE WHEN r.vote_average < 5.0 THEN 1 END) / COUNT(*), 2) AS pct_poor_below_5
FROM ratings r
WHERE r.tmdb_id IN (
    SELECT TRY_CAST(tmdb_id AS INT) FROM stg_movies WHERE production_companies LIKE '%A24%'
    UNION
    SELECT TRY_CAST(tmdb_id AS INT) FROM stg_tv_shows WHERE production_companies LIKE '%A24%'
)
AND (
    (r.content_type = 'movie' AND r.vote_count >= 100)
    OR 
    (r.content_type = 'tvshow' AND r.vote_count >= 50)
)
ORDER BY pct_good_above_7 DESC;