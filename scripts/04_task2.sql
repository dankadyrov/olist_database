SELECT 
    EXTRACT(EPOCH FROM (review_answer_timestamp - review_creation_date)) / 3600 AS review_delay_hours
FROM 
    order_reviews
WHERE 
    review_answer_timestamp IS NOT NULL;


WITH review_times AS (
    SELECT 
        EXTRACT(EPOCH FROM (review_answer_timestamp - review_creation_date)) / 3600 AS review_delay_hours
    FROM 
        order_reviews
    WHERE 
        review_answer_timestamp IS NOT NULL
)
SELECT 
    'Review Response Time Analysis' AS metric,
    COUNT(review_delay_hours) AS total_reviews,
    ROUND(AVG(review_delay_hours)::numeric, 2) AS avg_hours,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY review_delay_hours)::numeric, 2) AS percentile_25_hours,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY review_delay_hours)::numeric, 2) AS percentile_75_hours,
    ROUND(MIN(review_delay_hours)::numeric, 2) AS min_hours,
    ROUND(MAX(review_delay_hours)::numeric, 2) AS max_hours
FROM 
    review_times;

-- Смотрим поля самого долгого отзыва
WITH max_timestamp AS (
    SELECT MAX(review_answer_timestamp) AS max_review_answer_timestamp
    FROM order_reviews
),
review_delays AS (
    SELECT 
        review_id,
        review_comment_message,
        review_score,
        review_creation_date,
        review_answer_timestamp,
        EXTRACT(EPOCH FROM (review_answer_timestamp - review_creation_date)) / 3600 AS review_delay_hours
    FROM 
        order_reviews
    WHERE 
        review_answer_timestamp IS NOT NULL
)

SELECT 
    rd.review_id,
    rd.review_comment_message,
    rd.review_score,
    rd.review_creation_date,
    rd.review_answer_timestamp,
    rd.review_delay_hours
FROM 
    review_delays AS rd
CROSS JOIN 
    max_timestamp AS mt
WHERE 
    rd.review_delay_hours > 12448;