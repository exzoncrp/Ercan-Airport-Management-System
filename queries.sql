--------------------------------------------------------------------------------
-- Queries 1: Which aircraft model received how many test scores on average?
SELECT a.model_no, AVG(te.score) AS average_score
FROM airplane a
JOIN testing_event te ON a.plane_no = te.plane_no
GROUP BY a.model_no;

--------------------------------------------------------------------------------
-- Queries 2: How many planes do airline companies have in their fleets?
SELECT al.airline_name, COUNT(a.plane_no) AS total_airplanes
FROM airline al
LEFT JOIN airplane a ON al.airline_id = a.airline_id
GROUP BY al.airline_name;

--------------------------------------------------------------------------------
-- Queries 3: Which aircraft are currently under maintenance in the hangar?
SELECT plane_no, model_no 
FROM airplane 
WHERE plane_no IN (
    SELECT plane_no 
    FROM airplane_hangar 
    WHERE date_out IS NULL
);

--------------------------------------------------------------------------------
-- Queries 4: How many hours of testing did each technician do in total?
SELECT e.name AS technician_name, SUM(te.hours_spent) AS total_hours
FROM employee e
JOIN technician t ON e.ssn = t.ssn
JOIN testing_event te ON t.ssn = te.tech_ssn
GROUP BY e.name;

--------------------------------------------------------------------------------
-- Queries 5: Detailed list of tests performed in May 2026
SELECT a.model_no, t.test_name, DATE_FORMAT(te.event_date, '%M %Y') AS test_month, te.score
FROM testing_event te
JOIN airplane a ON te.plane_no = a.plane_no
JOIN test t ON te.test_id = t.test_id
WHERE DATE_FORMAT(te.event_date, '%Y-%m') = '2026-05';

--------------------------------------------------------------------------------
-- Queries 6: Which technicians have not performed any tests yet?
SELECT e.name AS technician_name, e.ssn
FROM technician t
JOIN employee e ON t.ssn = e.ssn
LEFT JOIN testing_event te ON t.ssn = te.tech_ssn
WHERE te.event_id IS NULL;

--------------------------------------------------------------------------------
-- Queries 7: Which airplanes have a capacity greater than the average capacity of all airplanes?
SELECT plane_no, model_no, capacity
FROM airplane
WHERE capacity > (SELECT AVG(capacity) FROM airplane);

--------------------------------------------------------------------------------
-- Queries 8: Which traffic controllers had their medical examination before 2026?
SELECT e.name AS controller_name, tc.last_exam_date
FROM traffic_controller tc
JOIN employee e ON tc.ssn = e.ssn
WHERE YEAR(tc.last_exam_date) < 2026;

--------------------------------------------------------------------------------
-- Queries 9: How many times has each test type been performed? (Ordered descending)
SELECT t.test_name, COUNT(te.event_id) AS total_tests_done
FROM test t
LEFT JOIN testing_event te ON t.test_id = te.test_id
GROUP BY t.test_name
ORDER BY total_tests_done DESC;

--------------------------------------------------------------------------------
-- Queries 10: What is the average test score of airplanes belonging to each airline?
SELECT al.airline_name, AVG(te.score) AS airline_avg_score
FROM airline al
JOIN airplane a ON al.airline_id = a.airline_id
JOIN testing_event te ON a.plane_no = te.plane_no
GROUP BY al.airline_name;

--------------------------------------------------------------------------------
-- Queries 11: Which airplanes are currently stationed in 'North Terminal'?
SELECT a.plane_no, a.model_no, h.location
FROM airplane a
JOIN airplane_hangar ah ON a.plane_no = ah.plane_no
JOIN hangar h ON ah.hangar_no = h.hangar_no
WHERE h.location = 'North Terminal' AND ah.date_out IS NULL;

--------------------------------------------------------------------------------
-- Queries 12: List the technicians who are experts on the 'Boeing 737' model.
SELECT e.name AS expert_technician, tex.model_no
FROM employee e
JOIN technician t ON e.ssn = t.ssn
JOIN technician_expertise tex ON t.ssn = tex.tech_ssn
WHERE tex.model_no = 'Boeing 737';

--------------------------------------------------------------------------------
-- Queries 13: What is the total capacity of airplanes currently owned by 'Turkish Airlines'?
SELECT al.airline_name, SUM(a.capacity) AS total_fleet_capacity
FROM airline al
JOIN airplane a ON al.airline_id = a.airline_id
WHERE al.airline_name = 'Turkish Airlines'
GROUP BY al.airline_name;

--------------------------------------------------------------------------------
-- Queries 14: Which testing events resulted in a score below 85?
SELECT te.event_id, a.model_no, t.test_name, te.score, te.event_date
FROM testing_event te
JOIN airplane a ON te.plane_no = a.plane_no
JOIN test t ON te.test_id = t.test_id
WHERE te.score < 85;

--------------------------------------------------------------------------------
-- Queries 15: Find the airplane that has spent the most total hours in testing.
SELECT a.plane_no, a.model_no, SUM(te.hours_spent) AS total_test_hours
FROM airplane a
JOIN testing_event te ON a.plane_no = te.plane_no
GROUP BY a.plane_no, a.model_no
ORDER BY total_test_hours DESC
LIMIT 1;