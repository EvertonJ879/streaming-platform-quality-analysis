-- Measures the "Prestige Premium" of A24 films distributed across standard networks
-- Uses CTEs to isolate A24 titles from staging tables and calculate rating variance against each platform's baseline

WITH Platform_Total_Movies AS (
    SELECT 
        p.platform,
        ROUND(SUM(r.vote_average * r.vote_count) / SUM(r.vote_count), 2) AS overall_movie_avg
    FROM content_platforms p
    INNER JOIN ratings r 
        ON p.tmdb_id = r.tmdb_id 
        AND p.content_type = r.content_type
    WHERE p.content_type = 'movie' AND r.vote_count >= 100
    GROUP BY p.platform
),
A24_Movies AS (
    SELECT DISTINCT TRY_CAST(tmdb_id AS INT) AS tmdb_id
    FROM stg_movies
    WHERE production_companies LIKE '%A24%'
),
Platform_A24_Movies AS (
    SELECT 
        p.platform,
        COUNT(DISTINCT p.tmdb_id) AS a24_title_count,
        ROUND(SUM(r.vote_average * r.vote_count) / SUM(r.vote_count), 2) AS a24_movie_avg
    FROM content_platforms p
    INNER JOIN ratings r 
        ON p.tmdb_id = r.tmdb_id 
        AND p.content_type = r.content_type
    INNER JOIN A24_Movies a 
        ON p.tmdb_id = a.tmdb_id
    WHERE p.content_type = 'movie' AND r.vote_count >= 100
    GROUP BY p.platform
)
SELECT 
    a.platform,
    a.a24_title_count,
    a.a24_movie_avg,
    t.overall_movie_avg,
    ROUND(a.a24_movie_avg - t.overall_movie_avg, 2) AS a24_premium_variance
FROM Platform_A24_Movies a
INNER JOIN Platform_Total_Movies t 
    ON a.platform = t.platform
ORDER BY a24_premium_variance DESC;