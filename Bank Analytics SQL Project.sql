create database Internship_project;
use internship_project;

LOAD DATA INFILE 'Bank Analytics SQL Project.csv'
INTO TABLE bank_analytics_project
CHARACTER SET utf8
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

SELECT * FROM BANK_ANALYTICS_PROJECT;
-----------------------------------------------------------------------------------------------------------------------------------
-- YEAR WISE LOAN AMOUNT STATS
select *, concat(format(loan_amount/1000000,2), 'M')
from (select ISSUED_YEAR, sum(LOAN_AMNT) as Loan_amount
FROM BANK_ANALYTICS_PROJECT
GROUP BY 1
ORDER  BY 1) as X;
------------------------------------------------------------------------------------------------------------------------------------
-- Grade and sub grade wise revol_bal
SELECT *, concat(format(sum(SUB_GRADE_TOTAL) OVER(PARTITION BY GRADE order by GRADE, SUB_GRADE),2),'M') AS GRADE_TOTAL
FROM ( SELECT GRADE, SUB_GRADE, concat(format(SUM(REVOL_BAL)/1000000,2), 'M') AS SUB_GRADE_TOTAL
FROM BANK_ANALYTICS_PROJECT
group by 1,2
ORDER BY 1,2) AS X ;
------------------------------------------------------------------------------------------------------------------------------------
-- Total Payment for Verified Status Vs Total Payment for Non Verified Status
select *, concat(round(cnt_pymnt/sum(cnt_pymnt) OVER ()* 100,0), '%') AS PERCENTAGE
from (SELECT VERIFICATION_STATUS, COUNT(TOTAL_PYMNT) AS CNT_PYMNT
FROM BANK_ANALYTICS_PROJECT 
group by 1) as X;

WITH CTE AS (
  SELECT VERIFICATION_STATUS, COUNT(TOTAL_PYMNT) AS CNT_PYMNT
  FROM BANK_ANALYTICS_PROJECT
  GROUP BY VERIFICATION_STATUS
)
SELECT VERIFICATION_STATUS, CNT_PYMNT,
  ROUND(CNT_PYMNT / SUM(CNT_PYMNT) OVER() * 100, 0) AS PERCENTAGE
FROM CTE;

------------------------------------------------------------------------------------------------------------------------------------
-- State wise and last_credit_pull_d wise loan status
select *, SUM(COUNT_LOANSTATUS) OVER(PARTITION BY YEAR, LOAN_STATUS ORDER BY YEAR) AS TOTAL_COUNT 
FROM (SELECT YEAR(LAST_CREDIT_PULL_D) AS YEAR, LOAN_STATUS, ADDR_STATE, COUNT(LOAN_STATUS) AS COUNT_LOANSTATUS
FROM BANK_ANALYTICS_PROJECT
GROUP BY 1,2,3
ORDER BY 1) AS X;
-------------------------------------------------------------------------------------------------------------------------------------
-- Home ownership Vs last payment date stats 
SELECT *, concat(round(CNT_HOME_OWNERSHIP/sum(CNT_HOME_OWNERSHIP) OVER(partition bY YEAR ) * 100,0), '%') AS PERCENTAGE
FROM( SELECT YEAR(LAST_PYMNT_D) AS YEAR , HOME_OWNERSHIP, COUNT(HOME_OWNERSHIP) AS CNT_HOME_OWNERSHIP
FROM BANK_ANALYTICS_PROJECT
GROUP BY 2,1 
ORDER BY 1 ) AS X;
--------------------------------------------------------------------------------------------------------------------------------------
-- RECOVERY RATE 
SELECT concat(Round(sum(RECOVERIES)/sum(LOAN_AMNT) * 100,1), '%') as Recovery_percentage
FROM bank_analytics_project
WHERE loan_status = "Charged Off" ;
--------------------------------------------------------------------------------------------------------------------------------------
-- DEFAULT RATE
SELECT concat(round(( SELECT count(LOAN_STATUS) FROM bank_analytics_project where loan_status = "Charged Off")
	   / count(loan_status) * 100,1), '%') as DEFAULT_PERCENTAGE
from bank_analytics_project ;
--------------------------------------------------------------------------------------------------------------------------------------
-- TOP 5 PURPOSES OF LOAN
select purpose, concat(format(total_loanamnt/1000000,2), 'M')
from(select PURPOSE,sum(loan_amnt) AS TOTAL_LOANAMNT
FROM bank_analytics_project
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5) as x ; 
--------------------------------------------------------------------------------------------------------------------------------------

