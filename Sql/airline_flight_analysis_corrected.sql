-- Airline Flight Delay Intelligence & Operational Performance Analytics
-- Phase 7: MySQL / SQL
-- Deliverable: airline_flight_analysis.sql

SET SESSION net_read_timeout      = 600;
SET SESSION net_write_timeout     = 600;
SET SESSION wait_timeout          = 600;
SET SESSION interactive_timeout   = 600;

CREATE DATABASE IF NOT EXISTS airline_flight_delay;
USE airline_flight_delay;
show databases;

-- ============================================================
-- 01. DATABASE DESIGN
-- ============================================================

CREATE TABLE IF NOT EXISTS flight_fact (
    flight_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    FL_DATE DATE,
    AIRLINE VARCHAR(100),
    AIRLINE_DOT VARCHAR(150),
    AIRLINE_CODE VARCHAR(20),
    DOT_CODE INT,
    FL_NUMBER INT,
    ORIGIN VARCHAR(10),
    ORIGIN_CITY VARCHAR(100),
    DEST VARCHAR(10),
    DEST_CITY VARCHAR(100),
    CRS_DEP_TIME INT,
    DEP_TIME INT,
    DEP_DELAY DECIMAL(10,2),
    TAXI_OUT DECIMAL(10,2),
    WHEELS_OFF INT,
    WHEELS_ON INT,
    TAXI_IN DECIMAL(10,2),
    CRS_ARR_TIME INT,
    ARR_TIME INT,
    ARR_DELAY DECIMAL(10,2),
    CANCELLED TINYINT,
    CANCELLATION_CODE VARCHAR(10),
    DIVERTED TINYINT,
    CRS_ELAPSED_TIME DECIMAL(10,2),
    ELAPSED_TIME DECIMAL(10,2),
    AIR_TIME DECIMAL(10,2),
    DISTANCE DECIMAL(10,2),
    DELAY_DUE_CARRIER DECIMAL(10,2),
    DELAY_DUE_WEATHER DECIMAL(10,2),
    DELAY_DUE_NAS DECIMAL(10,2),
    DELAY_DUE_SECURITY DECIMAL(10,2),
    DELAY_DUE_LATE_AIRCRAFT DECIMAL(10,2),
    TOTAL_DELAY_CAUSE_MINUTES DECIMAL(10,2),
    DELAY_SEVERITY VARCHAR(30),
    YEAR INT,
    MONTH INT,
    DAY INT,
    DAY_OF_WEEK VARCHAR(15),
    ROUTE VARCHAR(20),
    INDEX idx_airline (AIRLINE),
    INDEX idx_origin (ORIGIN),
    INDEX idx_dest (DEST),
    INDEX idx_route (ROUTE),
    INDEX idx_date (FL_DATE),
    INDEX idx_month (YEAR, MONTH)
);

CREATE TABLE IF NOT EXISTS airline_summary (
    AIRLINE VARCHAR(100) PRIMARY KEY,
    TOTAL_FLIGHTS BIGINT,
    AVG_DEP_DELAY DECIMAL(10,2),
    AVG_ARR_DELAY DECIMAL(10,2),
    CANCELLED_FLIGHTS BIGINT,
    DIVERTED_FLIGHTS BIGINT,
    CANCELLATION_RATE DECIMAL(10,4),
    DIVERSION_RATE DECIMAL(10,4)
);

CREATE TABLE IF NOT EXISTS airport_summary (
    AIRPORT VARCHAR(10) PRIMARY KEY,
    TOTAL_FLIGHTS BIGINT,
    AVG_DEP_DELAY DECIMAL(10,2),
    AVG_ARR_DELAY DECIMAL(10,2),
    CANCELLED_FLIGHTS BIGINT,
    DIVERTED_FLIGHTS BIGINT
);

CREATE TABLE IF NOT EXISTS route_summary (
    ROUTE VARCHAR(20) PRIMARY KEY,
    TOTAL_FLIGHTS BIGINT,
    AVG_DEP_DELAY DECIMAL(10,2),
    AVG_ARR_DELAY DECIMAL(10,2),
    CANCELLED_FLIGHTS BIGINT,
    DIVERTED_FLIGHTS BIGINT
);

CREATE TABLE IF NOT EXISTS monthly_summary (
    YEAR INT,
    MONTH INT,
    TOTAL_FLIGHTS BIGINT,
    AVG_DEP_DELAY DECIMAL(10,2),
    AVG_ARR_DELAY DECIMAL(10,2),
    CANCELLED_FLIGHTS BIGINT,
    DIVERTED_FLIGHTS BIGINT,
    PRIMARY KEY (YEAR, MONTH)
);

-- ============================================================
-- 02. DATA LOADING
-- The cleaned project CSV contains 3,000,000 rows and 39 columns.
-- flight_id is AUTO_INCREMENT, so it is intentionally excluded from the CSV mapping.
-- IMPORTANT: Replace the path below with the actual location of the cleaned CSV on your computer.
-- ============================================================

LOAD DATA LOCAL INFILE 'F:/Data science/intern all file/project/Airlines project final intern/data/cleaned_data/cleaned_flight_delay.csv'
INTO TABLE flight_fact
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    FL_DATE,
    AIRLINE,
    AIRLINE_DOT,
    AIRLINE_CODE,
    DOT_CODE,
    FL_NUMBER,
    ORIGIN,
    ORIGIN_CITY,
    DEST,
    DEST_CITY,
    CRS_DEP_TIME,
    DEP_TIME,
    DEP_DELAY,
    TAXI_OUT,
    WHEELS_OFF,
    WHEELS_ON,
    TAXI_IN,
    CRS_ARR_TIME,
    ARR_TIME,
    ARR_DELAY,
    CANCELLED,
    CANCELLATION_CODE,
    DIVERTED,
    CRS_ELAPSED_TIME,
    ELAPSED_TIME,
    AIR_TIME,
    DISTANCE,
    DELAY_DUE_CARRIER,
    DELAY_DUE_WEATHER,
    DELAY_DUE_NAS,
    DELAY_DUE_SECURITY,
    DELAY_DUE_LATE_AIRCRAFT,
    TOTAL_DELAY_CAUSE_MINUTES,
    DELAY_SEVERITY,
    `YEAR`,
    `MONTH`,
    `DAY`,
    DAY_OF_WEEK,
    ROUTE
);
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- Loading validation
SELECT COUNT(*) AS loaded_rows FROM flight_fact;
SELECT COUNT(DISTINCT AIRLINE) AS airline_count FROM flight_fact;
SELECT COUNT(DISTINCT ROUTE) AS route_count FROM flight_fact;
SELECT MIN(FL_DATE) AS min_date, MAX(FL_DATE) AS max_date FROM flight_fact;
TRUNCATE TABLE flight_fact;

-- ============================================================
-- 03. BASIC SQL
-- ============================================================

-- Q1. Total flight records
SELECT COUNT(*) AS total_flights
FROM flight_fact;

-- Q2. Sample records
SELECT flight_id, FL_DATE, AIRLINE, ORIGIN, DEST, DEP_DELAY, ARR_DELAY
FROM flight_fact
LIMIT 20;

-- Q3. Unique airlines
SELECT COUNT(DISTINCT AIRLINE) AS unique_airlines
FROM flight_fact;

-- Q4. Flights with arrival delay > 30 minutes
SELECT flight_id, FL_DATE, AIRLINE, ORIGIN, DEST, ARR_DELAY
FROM flight_fact
WHERE ARR_DELAY > 30
ORDER BY ARR_DELAY DESC
LIMIT 20;

-- Q5. Airline flight volume
SELECT AIRLINE, COUNT(*) AS total_flights
FROM flight_fact
GROUP BY AIRLINE
ORDER BY total_flights DESC;

-- Q6. Airline delay KPIs
SELECT
    AIRLINE,
    COUNT(*) AS total_flights,
    ROUND(AVG(DEP_DELAY), 2) AS avg_dep_delay,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arr_delay
FROM flight_fact
GROUP BY AIRLINE
ORDER BY avg_arr_delay DESC;

-- Q7. Airport flight volume
SELECT ORIGIN, COUNT(*) AS total_departures
FROM flight_fact
GROUP BY ORIGIN
ORDER BY total_departures DESC;

-- Q8. Route delay KPI

SELECT
    ROUTE,
    COUNT(*) AS total_flights,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arr_delay
FROM flight_fact
GROUP BY ROUTE
ORDER BY avg_arr_delay DESC
LIMIT 20;


-- Q9. Cancellation analysis
SELECT
    AIRLINE,
    COUNT(*) AS total_flights,
    SUM(CANCELLED) AS cancelled_flights,
    ROUND(100 * SUM(CANCELLED) / COUNT(*), 2) AS cancellation_rate_pct
FROM flight_fact
GROUP BY AIRLINE
ORDER BY cancellation_rate_pct DESC;



-- Q10. Diversion analysis
SELECT
    AIRLINE,
    COUNT(*) AS total_flights,
    SUM(DIVERTED) AS diverted_flights,
    ROUND(100 * SUM(DIVERTED) / COUNT(*), 2) AS diversion_rate_pct
FROM flight_fact
GROUP BY AIRLINE
ORDER BY diversion_rate_pct DESC;

-- Q11. HAVING: airlines with average arrival delay > 10 minutes
SELECT
    AIRLINE,
    COUNT(*) AS total_flights,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arr_delay
FROM flight_fact
GROUP BY AIRLINE
HAVING AVG(ARR_DELAY) > 10
ORDER BY avg_arr_delay DESC;

-- ============================================================
-- 04. INTERMEDIATE SQL
-- ============================================================

-- Q12. CASE: delay classification
SELECT
    flight_id,
    AIRLINE,
    ARR_DELAY,
    CASE
        WHEN ARR_DELAY IS NULL THEN 'NO_ARRIVAL_DATA'
        WHEN ARR_DELAY <= 0 THEN 'ON_TIME_OR_EARLY'
        WHEN ARR_DELAY <= 30 THEN 'MINOR_DELAY'
        WHEN ARR_DELAY <= 60 THEN 'MODERATE_DELAY'
        WHEN ARR_DELAY <= 120 THEN 'SEVERE_DELAY'
        ELSE 'EXTREME_DELAY'
    END AS delay_class
FROM flight_fact
LIMIT 20;

-- Q13. Airline-wise delay severity distribution
SELECT
    AIRLINE,
    CASE
        WHEN ARR_DELAY <= 0 THEN 'ON_TIME_OR_EARLY'
        WHEN ARR_DELAY <= 30 THEN 'MINOR_DELAY'
        WHEN ARR_DELAY <= 60 THEN 'MODERATE_DELAY'
        WHEN ARR_DELAY <= 120 THEN 'SEVERE_DELAY'
        ELSE 'EXTREME_DELAY'
    END AS delay_class,
    COUNT(*) AS flight_count
FROM flight_fact
WHERE ARR_DELAY IS NOT NULL
GROUP BY AIRLINE, delay_class
ORDER BY AIRLINE, flight_count DESC;

-- Q14. Populate airline summary
INSERT INTO airline_summary
SELECT
    AIRLINE,
    COUNT(*),
    ROUND(AVG(DEP_DELAY), 2),
    ROUND(AVG(ARR_DELAY), 2),
    SUM(CANCELLED),
    SUM(DIVERTED),
    ROUND(100 * SUM(CANCELLED) / COUNT(*), 4),
    ROUND(100 * SUM(DIVERTED) / COUNT(*), 4)
FROM flight_fact
GROUP BY AIRLINE;

-- Q15. Populate airport summary
INSERT INTO airport_summary
SELECT
    ORIGIN,
    COUNT(*),
    ROUND(AVG(DEP_DELAY), 2),
    ROUND(AVG(ARR_DELAY), 2),
    SUM(CANCELLED),
    SUM(DIVERTED)
FROM flight_fact
GROUP BY ORIGIN;

-- Q16. Populate route summary
INSERT INTO route_summary
SELECT
    ROUTE,
    COUNT(*),
    ROUND(AVG(DEP_DELAY), 2),
    ROUND(AVG(ARR_DELAY), 2),
    SUM(CANCELLED),
    SUM(DIVERTED)
FROM flight_fact
GROUP BY ROUTE;

-- Q17. Populate monthly summary
INSERT INTO monthly_summary
SELECT
    YEAR,
    MONTH,
    COUNT(*),
    ROUND(AVG(DEP_DELAY), 2),
    ROUND(AVG(ARR_DELAY), 2),
    SUM(CANCELLED),
    SUM(DIVERTED)
FROM flight_fact
GROUP BY YEAR, MONTH;

-- Q18. INNER JOIN + CTE
WITH airline_monthly AS (
    SELECT AIRLINE, YEAR, MONTH, COUNT(*) AS total_flights,
           AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY AIRLINE, YEAR, MONTH
)
SELECT
    a.AIRLINE,
    a.TOTAL_FLIGHTS AS total_airline_flights,
    m.YEAR,
    m.MONTH,
    m.total_flights AS monthly_flights,
    ROUND(m.avg_arr_delay, 2) AS monthly_avg_arr_delay
FROM airline_summary a
INNER JOIN airline_monthly m ON a.AIRLINE = m.AIRLINE
ORDER BY a.AIRLINE, m.YEAR, m.MONTH;

-- Q19. LEFT JOIN
SELECT
    r.ROUTE,
    r.TOTAL_FLIGHTS,
    r.AVG_ARR_DELAY,
    a.AIRPORT,
    a.AVG_DEP_DELAY
FROM route_summary r
LEFT JOIN airport_summary a
    ON SUBSTRING_INDEX(r.ROUTE, '-', 1) = a.AIRPORT
ORDER BY r.AVG_ARR_DELAY DESC;

-- Q20. Subquery: above overall average delay
SELECT
    AIRLINE,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arr_delay
FROM flight_fact
GROUP BY AIRLINE
HAVING AVG(ARR_DELAY) > (SELECT AVG(ARR_DELAY) FROM flight_fact);

-- Q21. Highest average-delay airline
SELECT AIRLINE, ROUND(AVG(ARR_DELAY), 2) AS avg_arr_delay
FROM flight_fact
GROUP BY AIRLINE
ORDER BY avg_arr_delay DESC
LIMIT 1;

-- Q22. UNION: unique airports
SELECT ORIGIN AS AIRPORT FROM flight_fact
UNION
SELECT DEST AS AIRPORT FROM flight_fact;

-- Q23. UNION ALL: origin + destination activity
SELECT ORIGIN AS AIRPORT FROM flight_fact
UNION ALL
SELECT DEST AS AIRPORT FROM flight_fact;

-- Q24. CTE: delayed flights
WITH delayed_flights AS (
    SELECT AIRLINE, ORIGIN, DEST, ARR_DELAY
    FROM flight_fact
    WHERE ARR_DELAY > 30
)
SELECT
    AIRLINE,
    COUNT(*) AS delayed_flights,
    ROUND(AVG(ARR_DELAY), 2) AS avg_delay
FROM delayed_flights
GROUP BY AIRLINE
ORDER BY delayed_flights DESC;

-- ============================================================
-- 05. ADVANCED SQL
-- ============================================================

-- Q25. ROW_NUMBER: routes ranked within each airline
SELECT
    AIRLINE,
    ROUTE,
    AVG(ARR_DELAY) AS avg_arr_delay,
    ROW_NUMBER() OVER (
        PARTITION BY AIRLINE
        ORDER BY AVG(ARR_DELAY) DESC
    ) AS delay_row_number
FROM flight_fact
GROUP BY AIRLINE, ROUTE;

-- Q26. RANK: airlines by average arrival delay
WITH airline_kpi AS (
    SELECT AIRLINE, AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY AIRLINE
)
SELECT
    AIRLINE,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay,
    RANK() OVER (ORDER BY avg_arr_delay DESC) AS delay_rank
FROM airline_kpi;

-- Q27. DENSE_RANK
WITH airline_kpi AS (
    SELECT AIRLINE, AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY AIRLINE
)
SELECT
    AIRLINE,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay,
    DENSE_RANK() OVER (ORDER BY avg_arr_delay DESC) AS delay_dense_rank
FROM airline_kpi;

-- Q28. Top 3 highest-delay routes per airline
WITH route_kpi AS (
    SELECT AIRLINE, ROUTE, COUNT(*) AS total_flights,
           AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY AIRLINE, ROUTE
),
ranked_routes AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY AIRLINE
               ORDER BY avg_arr_delay DESC
           ) AS route_rank
    FROM route_kpi
)
SELECT
    AIRLINE, ROUTE, total_flights,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay,
    route_rank
FROM ranked_routes
WHERE route_rank <= 3
ORDER BY AIRLINE, route_rank;

-- Q29. LAG: month-over-month flight volume
WITH monthly_flights AS (
    SELECT YEAR, MONTH, COUNT(*) AS total_flights
    FROM flight_fact
    GROUP BY YEAR, MONTH
)
SELECT
    YEAR,
    MONTH,
    total_flights,
    LAG(total_flights) OVER (ORDER BY YEAR, MONTH) AS previous_month_flights,
    total_flights -
        LAG(total_flights) OVER (ORDER BY YEAR, MONTH)
        AS flight_volume_change
FROM monthly_flights
ORDER BY YEAR, MONTH;

-- Q30. LAG: month-over-month arrival delay
WITH monthly_delay AS (
    SELECT YEAR, MONTH, AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY YEAR, MONTH
)
SELECT
    YEAR,
    MONTH,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay,
    ROUND(LAG(avg_arr_delay) OVER (ORDER BY YEAR, MONTH), 2)
        AS previous_month_delay,
    ROUND(
        avg_arr_delay -
        LAG(avg_arr_delay) OVER (ORDER BY YEAR, MONTH),
        2
    ) AS mom_delay_change
FROM monthly_delay
ORDER BY YEAR, MONTH;

-- Q31. LEAD: next-month comparison
WITH monthly_delay AS (
    SELECT YEAR, MONTH, AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY YEAR, MONTH
)
SELECT
    YEAR,
    MONTH,
    ROUND(avg_arr_delay, 2) AS current_month_delay,
    ROUND(LEAD(avg_arr_delay) OVER (ORDER BY YEAR, MONTH), 2)
        AS next_month_delay
FROM monthly_delay
ORDER BY YEAR, MONTH;

-- Q32. Cumulative flight volume
WITH monthly_flights AS (
    SELECT YEAR, MONTH, COUNT(*) AS total_flights
    FROM flight_fact
    GROUP BY YEAR, MONTH
)
SELECT
    YEAR,
    MONTH,
    total_flights,
    SUM(total_flights) OVER (
        ORDER BY YEAR, MONTH
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_flights
FROM monthly_flights
ORDER BY YEAR, MONTH;

-- Q33. Airline-specific month-over-month delay
WITH airline_monthly AS (
    SELECT
        AIRLINE, YEAR, MONTH,
        COUNT(*) AS total_flights,
        AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY AIRLINE, YEAR, MONTH
)
SELECT
    AIRLINE,
    YEAR,
    MONTH,
    total_flights,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay,
    ROUND(
        LAG(avg_arr_delay) OVER (
            PARTITION BY AIRLINE
            ORDER BY YEAR, MONTH
        ),
        2
    ) AS previous_month_delay
FROM airline_monthly
ORDER BY AIRLINE, YEAR, MONTH;

-- Q34. Highest-delay month for each airline
WITH monthly_airline AS (
    SELECT AIRLINE, YEAR, MONTH, AVG(ARR_DELAY) AS avg_arr_delay
    FROM flight_fact
    GROUP BY AIRLINE, YEAR, MONTH
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY AIRLINE
               ORDER BY avg_arr_delay DESC
           ) AS rn
    FROM monthly_airline
)
SELECT
    AIRLINE,
    YEAR,
    MONTH,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay
FROM ranked
WHERE rn = 1
ORDER BY avg_arr_delay DESC;

-- Q35. Delay causes
SELECT
    SUM(DELAY_DUE_CARRIER) AS carrier_delay,
    SUM(DELAY_DUE_WEATHER) AS weather_delay,
    SUM(DELAY_DUE_NAS) AS nas_delay,
    SUM(DELAY_DUE_SECURITY) AS security_delay,
    SUM(DELAY_DUE_LATE_AIRCRAFT) AS late_aircraft_delay
FROM flight_fact;

-- Q36. Extreme delays > 180 minutes by airline
SELECT AIRLINE, COUNT(*) AS extreme_delay_flights
FROM flight_fact
WHERE ARR_DELAY > 180
GROUP BY AIRLINE
ORDER BY extreme_delay_flights DESC;

-- Q37. Extreme-delay rate
SELECT
    AIRLINE,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN ARR_DELAY > 180 THEN 1 ELSE 0 END)
        AS extreme_delay_flights,
    ROUND(
        100 * SUM(CASE WHEN ARR_DELAY > 180 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS extreme_delay_rate_pct
FROM flight_fact
GROUP BY AIRLINE
ORDER BY extreme_delay_rate_pct DESC;

-- ============================================================
-- 06. HIGH-RISK ANALYSIS
-- ============================================================

-- Q38. High-risk airlines
-- Rule: >=1000 flights, avg arrival delay >10, cancellation rate >2%
SELECT
    AIRLINE,
    TOTAL_FLIGHTS,
    AVG_ARR_DELAY,
    CANCELLATION_RATE
FROM airline_summary
WHERE TOTAL_FLIGHTS >= 1000
  AND AVG_ARR_DELAY > 10
  AND CANCELLATION_RATE > 2
ORDER BY AVG_ARR_DELAY DESC;

-- Q39. High-risk airports
-- Rule: >=1000 flights and avg departure delay >10
SELECT
    AIRPORT,
    TOTAL_FLIGHTS,
    AVG_DEP_DELAY,
    AVG_ARR_DELAY
FROM airport_summary
WHERE TOTAL_FLIGHTS >= 1000
  AND AVG_DEP_DELAY > 10
ORDER BY AVG_DEP_DELAY DESC;

-- Q40. High-risk routes
-- Rule: >=500 flights and avg arrival delay >15
SELECT
    ROUTE,
    TOTAL_FLIGHTS,
    AVG_DEP_DELAY,
    AVG_ARR_DELAY
FROM route_summary
WHERE TOTAL_FLIGHTS >= 500
  AND AVG_ARR_DELAY > 15
ORDER BY AVG_ARR_DELAY DESC;

-- ============================================================
-- 07. FINAL BUSINESS KPI DATASETS
-- ============================================================

-- Q41. Airline operational KPI dataset
SELECT
    AIRLINE,
    COUNT(*) AS total_flights,
    ROUND(AVG(DEP_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arrival_delay,
    SUM(CANCELLED) AS cancelled_flights,
    ROUND(100 * SUM(CANCELLED) / COUNT(*), 2)
        AS cancellation_rate_pct,
    SUM(DIVERTED) AS diverted_flights,
    ROUND(100 * SUM(DIVERTED) / COUNT(*), 2)
        AS diversion_rate_pct,
    SUM(CASE WHEN ARR_DELAY > 60 THEN 1 ELSE 0 END)
        AS severe_delay_flights
FROM flight_fact
GROUP BY AIRLINE
ORDER BY avg_arrival_delay DESC;

-- Q42. Airport operational KPI dataset
SELECT
    ORIGIN AS AIRPORT,
    COUNT(*) AS total_departures,
    ROUND(AVG(DEP_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arrival_delay,
    ROUND(100 * SUM(CANCELLED) / COUNT(*), 2)
        AS cancellation_rate_pct,
    ROUND(100 * SUM(DIVERTED) / COUNT(*), 2)
        AS diversion_rate_pct
FROM flight_fact
GROUP BY ORIGIN
ORDER BY avg_departure_delay DESC;

-- Q43. Route operational KPI dataset
SELECT
    ROUTE,
    COUNT(*) AS total_flights,
    ROUND(AVG(DEP_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arrival_delay,
    SUM(CASE WHEN ARR_DELAY > 60 THEN 1 ELSE 0 END)
        AS severe_delay_flights
FROM flight_fact
GROUP BY ROUTE
HAVING COUNT(*) >= 500
ORDER BY avg_arrival_delay DESC;

-- Q44. Final rule-based operational risk classification
WITH airline_metrics AS (
    SELECT
        AIRLINE,
        COUNT(*) AS total_flights,
        AVG(ARR_DELAY) AS avg_arr_delay,
        100 * SUM(CANCELLED) / COUNT(*) AS cancellation_rate,
        100 * SUM(
            CASE WHEN ARR_DELAY > 60 THEN 1 ELSE 0 END
        ) / COUNT(*) AS severe_delay_rate
    FROM flight_fact
    GROUP BY AIRLINE
)
SELECT
    AIRLINE,
    total_flights,
    ROUND(avg_arr_delay, 2) AS avg_arr_delay,
    ROUND(cancellation_rate, 2) AS cancellation_rate,
    ROUND(severe_delay_rate, 2) AS severe_delay_rate,
    CASE
        WHEN avg_arr_delay > 15 AND cancellation_rate > 2
            THEN 'HIGH_OPERATIONAL_RISK'
        WHEN avg_arr_delay > 10 OR cancellation_rate > 2
            THEN 'MODERATE_OPERATIONAL_RISK'
        ELSE 'LOWER_OPERATIONAL_RISK'
    END AS operational_risk
FROM airline_metrics
WHERE total_flights >= 1000
ORDER BY avg_arr_delay DESC;

-- ============================================================
-- 08. FINAL VALIDATION
-- ============================================================

SELECT COUNT(*) AS total_flight_records
FROM flight_fact;

SELECT COUNT(DISTINCT AIRLINE) AS airline_count
FROM flight_fact;

SELECT COUNT(DISTINCT ORIGIN) AS origin_airport_count
FROM flight_fact;

SELECT COUNT(DISTINCT ROUTE) AS route_count
FROM flight_fact;

SELECT DISTINCT CANCELLED
FROM flight_fact
ORDER BY CANCELLED;

SELECT DISTINCT DIVERTED
FROM flight_fact
ORDER BY DIVERTED;

SELECT
    MIN(FL_DATE) AS earliest_flight_date,
    MAX(FL_DATE) AS latest_flight_date
FROM flight_fact;

-- ============================================================
-- END OF airline_flight_analysis.sql
-- ============================================================
