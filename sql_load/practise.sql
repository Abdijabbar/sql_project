SELECT 
    jobs.job_title_short,
    jobs.job_location,
    jobs.job_posted_date :: DATE AS DATE_TIME
FROM 
    job_postings_fact as jobs
LIMIT 5;

SELECT 
    jobs.job_title_short,
    jobs.job_location,
    jobs.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST',
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM 
    job_postings_fact as jobs
LIMIT 5;

CREATE TABLE Jan_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    LIMIT 10;

SELECT 
    COUNT(job_id) as number_of_jobs,
    -- job_title_short,
    -- job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
from job_postings_fact
GROUP BY 
    location_category;

SELECT 
    company_id,
    name as company_name
from company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact 
    WHERE job_no_degree_mention = true
);
WITH company_job_count AS (
    SELECT company_id, count(*) as total_jobs
    from job_postings_fact
    GROUP BY company_id
)

select company_dim.name as company_name, company_job_count.total_jobs
from company_dim
left join company_job_count on company_job_count.company_id =company_dim.company_id
ORDER BY total_jobs DESC;
