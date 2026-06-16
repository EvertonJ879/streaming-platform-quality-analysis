-- Content quality baseline scores from 2021 to 2025

SELECT 
    p.platform,
    c.release_year,
    COUNT(DISTINCT p.tmdb_id) AS title_count,
    ROUND(SUM(r.vote_average * r.vote_count) / SUM(r.vote_count), 2) AS weighted_avg_rating
FROM content_platforms p
INNER JOIN content c
    ON p.tmdb_id = c.tmdb_id
    AND p.content_type = c.content_type
INNER JOIN ratings r 
    ON p.tmdb_id = r.tmdb_id 
    AND p.content_type = r.content_type
WHERE 
    c.release_year BETWEEN 2021 AND 2025
    AND (
        (p.content_type = 'movie' AND r.vote_count >= 100)
        OR 
        (p.content_type = 'tvshow' AND r.vote_count >= 50)
    )
GROUP BY p.platform, c.release_year
ORDER BY p.platform, c.release_year DESC;