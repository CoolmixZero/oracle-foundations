-- TASK 1
SELECT 
    e.*, 
    d.department_name
FROM HR.employees e
JOIN HR.departments d 
    ON e.department_id = d.department_id
ORDER BY e.salary DESC
FETCH FIRST 5 ROWS ONLY;

-- TASK 2
SELECT ROUND(AVG(e.salary)) AS average_salary, d.department_name 
FROM HR.employees e
JOIN HR.departments d
    ON e.department_id = d.department_id
GROUP BY department_name
HAVING AVG(salary) > 5000
ORDER BY average_salary DESC;

-- TASK 3
SELECT 
    e.first_name || ' ' || e.last_name,
	m.first_name || ' ' || m.last_name
FROM HR.employees e
JOIN HR.employees m
	ON e.employee_id = (
    	SELECT manager.manager_id 
    	FROM HR.employees manager
    	WHERE manager.first_name = 'John' AND manager.last_name = 'Russel'
    );

-- TASK 4
SELECT DISTINCT
    j.job_id,
	j.job_title,
	SUM(e.salary) salary_expenses
FROM HR.jobs j
JOIN HR.employees e
	ON j.job_id = e.job_id
GROUP BY j.job_id, j.job_title
ORDER BY salary_expenses DESC;

-- TASK 5
SELECT 
    d.department_id,
    d.department_name,
    ROUND(AVG(e.salary)) average_salary
FROM HR.employees e
JOIN HR.departments d
	ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY average_salary DESC
FETCH FIRST 1 ROW ONLY;

-- TASK 6
SELECT 
    d.department_id,
    d.department_name,
    COUNT(*) number_of_employees
FROM HR.employees e
JOIN HR.departments d
    ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY number_of_employees DESC
FETCH FIRST 3 ROWS ONLY;

-- TASK 7
SELECT
	e.employee_id,
	(e.first_name || ' ' || e.last_name) full_name,
	giga_employees.max_salary
FROM HR.employees e
JOIN (
    SELECT 
    	e1.department_id,
    	MAX(e1.salary) max_salary
    FROM HR.employees e1
    WHERE EXTRACT(YEAR FROM e1.hire_date) = 2005 AND e1.department_id IS NOT NULL
    GROUP BY e1.department_id
) giga_employees
	ON e.department_id = giga_employees.department_id AND e.salary = giga_employees.max_salary
ORDER BY giga_employees.max_salary DESC;

-- TASK 8
SELECT 
    employee_id,
    (first_name || ' ' || last_name) full_name,
	ROUND(AVG(salary)) average_salary,
    ROUND((MONTHS_BETWEEN(SYSDATE, hire_date) / 12), 2) years_in_company
FROM HR.employees
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) >= 20*12 AND job_id != 'AD_PRES'
GROUP BY employee_id, (first_name || ' ' || last_name), (MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
ORDER BY years_in_company DESC;

-- TASK 9
SELECT
	d.department_id,
	d.department_name,
	AVG(e.salary) average_salary
FROM HR.departments d
JOIN HR.employees e
	ON d.department_id = e.employee_id
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) > (
    SELECT 
    	AVG(e1.salary)
    FROM HR.employees e1
    WHERE e1.department_id = (
    	SELECT 
    		d1.department_id
    	FROM HR.departments d1
		WHERE department_name = 'Sales'
    )
)
ORDER BY average_salary DESC;

-- TASK 10
SELECT
	(e.first_name || ' ' || e.last_name) full_name,
    -- (e1.first_name || ' ' || e1.last_name) full_name_other,
	COUNT(*) joined_same_year,
    e.hire_date
FROM HR.employees e
JOIN HR.employees e1
	ON EXTRACT(YEAR FROM e.hire_date) = EXTRACT(YEAR FROM e1.hire_date)
-- GROUP BY (e.first_name || ' ' || e.last_name), (e1.first_name || ' ' || e1.last_name), e.hire_date
GROUP BY (e.first_name || ' ' || e.last_name), e.hire_date
ORDER BY joined_same_year DESC;
