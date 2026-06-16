-- Aggregates raw catalog volume to establish total library footprints per platform
-- Counts unique titles to account for any cross-platform distribution duplication

SELECT 
    platform,
    COUNT(DISTINCT tmdb_id) AS total_library_size
FROM content_platforms
GROUP BY platform
ORDER BY total_library_size DESC;