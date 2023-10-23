select * from hr
use projects;
describe hr

select birthdate
from hr;

alter table hr
change column ï»¿id emp_id varchar(20) null

update hr
set birthdate = case
  when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
  when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
  else null
end;

select birthdate
from hr;
describe hr;

alter table hr
modify column birthdate date;

describe hr;

update hr
set hire_date = case
  when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
  when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
  else null
end;

select hire_date
from hr;

alter table hr
modify column hire_date date;

describe hr;
select termdate from hr

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

describe hr

alter table hr
add column age int;
select * from hr

update hr 
set age = timestampdiff(YEAR, birthdate, CURDATE());
select age, birthdate from hr

select
	min(age) as youngest,
    max(age) as oldest
from hr;

select count(*) from hr
where age<18;

-- 1. genderbreakdown
SELECT gender, COUNT(*) AS gender_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2 RACE BREAKDOWN
select race, count(*) as race_count
from hr 
WHERE age >= 18 AND termdate = '0000-00-00'
group by race
order by count(*) desc;

-- 3 age distributiom
select
	min(age) as youngest,
    max(age) as oldest
from hr
WHERE age >= 18 AND termdate = '0000-00-00'


select
	case
		when age>=18 and age<=24 then '18-24'
        when age>=25 and age<=34 then '25-34'
        when age>=35 and age<=44 then '35-44'
        when age>=45 and age<=54 then '45-54'
        when age>=55 and age<=64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as age_count
from hr 
WHERE age >= 18 AND termdate = '0000-00-00'
group by age_group
order by age_group;

-- age dsirtribution between the genders for that
select
	case
		when age>=18 and age<=24 then '18-24'
        when age>=25 and age<=34 then '25-34'
        when age>=35 and age<=44 then '35-44'
        when age>=45 and age<=54 then '45-54'
        when age>=55 and age<=64 then '55-64'
        else '65+'
	end as age_group,gender,
    count(*) as age_count
from hr 
WHERE age >= 18 AND termdate = '0000-00-00'
group by age_group,gender
order by age_group,gender;


-- how many employee work at headquater vs remote?
select * from hr

select location, count(*) as location_count
from hr
WHERE age >= 18 AND termdate = '0000-00-00'
group by location; 


-- avg length of employer who have been terminated
select
	round(avg(datediff(termdate,hire_date))/365,0) as avg_length_emp
from hr
where termdate<=curdate() and termdate<>'0000-00-00' and age>=18;

-- gender distirbbution across diff. department and job title
select department,gender,count(*) as count
from hr
where age>=18 and termdate= '0000-00-00'
group by department,gender
order by department;

-- distribuion of job titles across company

select * from hr
select jobtitle, count(*) as count
from hr
WHERE age >= 18 AND termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

--  which department has highest turnover/termination rate?

SELECT department, total_count, terminated_count, terminated_count / total_count AS termination_rate
FROM (
    SELECT department, count(*) AS total_count,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- distribution of employee across location by city and state?
select * from hr

select location_state, count(*) as count
from hr
WHERE age >= 18 AND termdate = '0000-00-00'
group by location_state
order by count desc;

-- how has the companys employee count changed over time based on  hire and term dates?

SELECT 
    YEAR(hire_date) AS year,
    COUNT(*) AS hires,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations,
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100, 2) AS net_change_percent
FROM hr
WHERE age >= 18
GROUP BY YEAR(hire_date)
ORDER BY YEAR(hire_date) ASC;



--  tenure distribuiton for each 	dept?
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate<=curdate() and termdate<>'0000-00-00' and age>=18
group by department;
        
        
	






