-- Calculates the baseline quality score per platform using a true weighted average
-- Enforces minimum audience engagement thresholds (100 votes for movies, 50 votes for TV) to filter out low sample data noise
-- Stacks standalone A24 production performance as a "pseudo" platform row to establish a visual quality anchor

SELECT 
    p.platform AS platform,
    COUNT(DISTINCT p.tmdb_id) AS qualified_titles,
    ROUND(SUM(r.vote_average * r.vote_count) / SUM(r.vote_count), 2) AS weighted_avg_rating
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
    COUNT(DISTINCT r.tmdb_id) AS qualified_titles,
    ROUND(SUM(r.vote_average * r.vote_count) / SUM(r.vote_count), 2) AS weighted_avg_rating
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
ORDER BY weighted_avg_rating DESC;