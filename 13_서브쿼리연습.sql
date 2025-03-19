



-- 1번
SELECT DEPT_TITLE  FROM EMPLOYEE e JOIN DEPARTMENT ON (e.DEPT_CODE  = DEPARTMENT.DEPT_ID ) WHERE e.EMP_NAME ='전지연' ;

SELECT emp_id, emp_name, phone, hire_date , DEPT_TITLE 

FROM EMPLOYEE e JOIN DEPARTMENT d ON (d.DEPT_id = e.DEPT_CODE ) 

WHERE dept_title = (SELECT DEPT_TITLE   FROM EMPLOYEE e JOIN DEPARTMENT ON (e.DEPT_CODE  = DEPARTMENT.DEPT_ID ) WHERE e.EMP_NAME ='전지연') AND emp_name <>'전지연' ; 













--2번

SELECT dept_code, emp_name, phone, JOB_NAME   FROM employee LEFT JOIN job ON  EMPLOYEE.JOB_CODE  = job.JOB_CODE 

WHERE SALARY = (SELECT max(salary)  FROM employee WHERE EXTRACT(YEAR FROM hire_date) >2000)   ;




SELECT e.DEPT_CODE  FROM EMPLOYEE e WHERE e.EMP_NAME ='노옹철';
SELECT e.JOB_CODE   FROM EMPLOYEE e WHERE e.EMP_NAME ='노옹철';


-- 3번
SELECT EMPLOYEE.EMP_ID, EMPLOYEE.EMP_NAME , dept_code, dept_title, job_name  FROM employee JOIN job ON ( EMPLOYEE.JOB_CODE  = JOB.JOB_CODE ) JOIN DEPARTMENT d ON (EMPLOYEE.DEPT_CODE  = d.DEPT_ID ) 
WHERE EMPLOYEE.DEPT_CODE  =  (SELECT e.DEPT_CODE  FROM EMPLOYEE e WHERE e.EMP_NAME ='노옹철')  AND JOB.JOB_CODE = (SELECT e.JOB_CODE   FROM EMPLOYEE e WHERE e.EMP_NAME ='노옹철') AND EMPLOYEE.EMP_NAME <> '노옹철'
;




-- 4번

SELECT dept_code FROM EMPLOYEE e  WHERE EXTRACT (YEAR FROM HIRE_DATE ) =2000 ;
SELECT job_code FROM EMPLOYEE e  WHERE EXTRACT (YEAR FROM HIRE_DATE ) =2000 ;


SELECT emp_id, emp_name, dept_code, job_code, hire_date FROM EMPLOYEE e WHERE dept_code = (SELECT dept_code FROM EMPLOYEE e  
WHERE EXTRACT (YEAR FROM HIRE_DATE ) =2000  ) AND job_code = (SELECT job_code FROM EMPLOYEE e  WHERE EXTRACT (YEAR FROM HIRE_DATE ) =2000) ;



-- 5번

SELECT e.dept_code  FROM EMPLOYEE e WHERE substr (emp_no,1,2) = '77' AND (substr(EMP_NO,8,1)=2)  ;
SELECT MANAGER_ID   FROM EMPLOYEE e WHERE substr (emp_no,1,2) = '77' AND (substr(EMP_NO,8,1)=2) ;

SELECT emp_id, EMP_NAME, dept_code, MANAGER_ID, EMP_NO , HIRE_DATE     
FROM EMPLOYEE 
WHERE dept_code in (SELECT e.dept_code  FROM EMPLOYEE e WHERE substr (emp_no,1,2) = '77' AND (substr(EMP_NO,8,1)=2)) AND 
manager_id IN (SELECT MANAGER_ID   FROM EMPLOYEE e WHERE substr (emp_no,1,2) = '77' AND (substr(EMP_NO,8,1)=2))
;


-- 6번





SELECT Min(HIRE_DATE ) FROM EMPLOYEE e GROUP BY e.DEPT_CODE  ;


SELECT emp_id, emp_name, nvl(DEPT_TITLE, '소속없음'), job_name, HIRE_DATE   FROM EMPLOYEE e LEFT OUTER JOIN DEPARTMENT  on(DEPARTMENT.DEPT_ID  = e.DEPT_CODE  ) JOIN job ON (e.JOB_CODE  = JOB.JOB_CODE ) 
WHERE ent_date IS  NULL 
GROUP BY DEPT_CODE, emp_id, emp_name, DEPT_TITLE, job_name, HIRE_DATE
HAVING hire_date in (SELECT Min(HIRE_DATE ) FROM EMPLOYEE e GROUP BY e.DEPT_CODE)
ORDER BY e.HIRE_DATE 
;


-- 7번

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM job;


SELECT max(substr(emp_no,1,2)) FROM employee;

SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, 
             TO_DATE(SUBSTR(emp_no, 1, 6), 'YYMMDD')))
FROM EMPLOYEE;

SELECT emp_id, emp_name, dept_title, floor( MONTHS_BETWEEN(sysdate, HIRE_DATE)/12)

FROM employee JOIN department ON (dept_id = dept_code);



