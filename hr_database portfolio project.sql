create database hr_database;
use hr_database ;

create table hrdata ( 
		emp_no int primary key,
		gender varchar(20),
		marital_status varchar(30),
		age_band varchar(30),
		age int,
		department varchar(30),
		education varchar(30),
		education_field varchar(30),
		job_role varchar(30),
		business_travel varchar(30),
		employee_count int ,
		attrition varchar(30),
		attrition_label varchar(30),
		job_satisfaction int ,
		active_employee int 
);

select * from hrdata;
----------------------------------------------------------------------------------------------------------------------------
-- KPI employee count
select sum(employee_count) as employee_count from hrdata
-- where education = 'high school' 
-- where department = 'r&d' ;
where education_field = 'medical' ;
-------------------------------------------------------------------------------------------------------------
-- KPI attrition count
select count(attrition) from hrdata
where attrition = 'yes' and education = 'doctoral degree' ;

select count(attrition) from hrdata
where attrition = 'yes' and department = 'r&d' and education_field = 'medical' 
and education = 'high school';

-----------------------------------------------------------------------------------------------------------
-- KPI attrition rate
select round((( select count(attrition) from hrdata where attrition = 'yes') / sum(employee_count)) * 100, 2) as attirtion_percentage 
from hrdata ;

select round((( select count(attrition) from hrdata where attrition = 'yes'and department = 'sales') / 
sum(employee_count)) * 100, 2) as attirtion_percentage 
from hrdata 
where department = 'sales';

--------------------------------------------------------------------------------------------------------------------------
-- KPI active employee
select sum(employee_count) - (select count(attrition) from hrdata where attrition = 'yes'
							  and gender = 'male') as active_employee
from hrdata where gender = 'male';

--------------------------------------------------------------------------------------------------------------------------
-- KPI average age
select round(avg(age),0) as avg_age from hrdata;

--------------------------------------------------------------------------------------------------------------------------
-- attrition by gender

select gender, count(attrition) as attrition_count
from hrdata 
where attrition = 'yes'
group by gender
order by 2 desc;

select gender, count(attrition) as attrition_count
from hrdata 
where attrition = 'yes' and education = 'high school'
group by gender
order by 2 desc;

------------------------------------------------------------------------------------------------------------------------
-- department wise attrition

select department, count(attrition) as attrition_count, 
round(((count(attrition) / (select count(attrition) from hrdata where attrition = 'yes')) * 100),2) as attrition_percentage
from hrdata 
where attrition = 'yes'
group by 1
order by 2 desc;

select department, count(attrition) as attrition_count, 
round(((count(attrition) / (select count(attrition) from hrdata 
                              where attrition = 'yes' and gender = 'female')) * 100),2) as attrition_percentage
from hrdata 
where attrition = 'yes' and gender = 'female'
group by 1
order by 2 desc;

------------------------------------------------------------------------------------------------------------------------
-- employee count by age group
select age, sum(employee_count) 
from hrdata
where department = 'r&d'
group by 1
order by 1 ;

-- attrition count by education field
select education_field, count(attrition) 
from hrdata
where attrition = 'yes' and department = 'sales'
group by 1
order by 2 desc;

-----------------------------------------------------------------------------------------------------------------------

-- attrition rate by gender for different age groups 
select age_band, gender, count(attrition),
round(((count(attrition)/ (select count(attrition) from hrdata where attrition = 'yes')) * 100),2) as attrition_rate
from hrdata
where attrition = 'yes'
group by 1,2
order by 1,2;

--------------------------------------------------------------------------------------------------------------------------------
-- job satisfaction rating
select job_role, job_satisfaction, sum(employee_count)
from hrdata
group by 1,2
order by 1,2 ;

---------------------------------------------------------------------------------------------------------------------------------

-- number of employees by different age group
select age_band, gender, sum(employee_COUNT)
from hrdata
group by 1,2
order by 1,2 desc;