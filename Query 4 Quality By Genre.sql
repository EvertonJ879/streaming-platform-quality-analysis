-- Measures genre level quality variance across platforms to identify structural rating biases
SELECT 
    p.platform,
    g.genre,
    COUNT(DISTINCT p.tmdb_id) AS title_count,
    ROUND(SUM(r.vote_average * r.vote_count) / SUM(r.vote_count), 2) AS weighted_avg_rating
FROM content_platforms p
INNER JOIN content_genres g 
    ON p.tmdb_id = g.tmdb_id 
    AND p.content_type = g.content_type
INNER JOIN ratings r 
    ON p.tmdb_id = r.tmdb_id 
    AND p.content_type = r.content_type
WHERE 
    (p.content_type = 'movie' AND r.vote_count >= 100)
    OR 
    (p.content_type = 'tvshow' AND r.vote_count >= 50)
GROUP BY p.platform, g.genre
ORDER BY p.platform, weighted_avg_rating DESC;