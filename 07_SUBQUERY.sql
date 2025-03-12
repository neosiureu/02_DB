/*
 * 서브쿼리란?
  
하나의 SQL문 안에 포함된 또 다른 SQL문
메인 쿼리를 위해 보조역할을 하는 쿼리문
  
메인이 SELECT절이면 HAVING


  <BR>
서브쿼리 = (내부 쿼리)
메인 쿼리 = (외부 쿼리, 기존 쿼리)
 * */


-- 서브쿼리 예시1



-- 부서코드가 노옹철사원과 같은 부서 소속인 직원의 이름과 부서코드를 얻고 싶다

-- 먼저 노옹철 사원의 부서코드를 조회한다 = 서브쿼리



-- 다음으로 부서코드가 'D9'인 직원의 이름과 부서코드를 조회한다 (메인쿼리)


SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE e WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE e WHERE EMP_NAME = '노옹철')
;



-- 서브쿼리 예시 2: 전 직원의 평균 급여보다 많은 급여를 받고있는 직원의 사번과 이름, 직급코드, 급여를 조회한다





SELECT e.EMP_ID, e.EMP_NAME , e.DEPT_CODE, e.SALARY  FROM EMPLOYEE e
WHERE e.SALARY >= (SELECT CEIL(AVG(SALARY)) 
FROM EMPLOYEE e)
;


/*
 /* 서브쿼리 유형
 * 
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
 * 
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
 * 
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때
 * 
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * 
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
 * 						메인쿼리 테이블의 값이 변경되면 
 * 						서브쿼리의 결과값도 바뀌는 서브쿼리
 * 
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
 * 
 * ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 ** 
 * 
 * */	


SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE) 
ORDER BY JOB_CODE
;

/*
 * > ex2) 가장 적은 급여를 받는 직원의 사번, 이름, 직급명, 부서코드, 급여, 입사일을 조회한다
 
  
  가장 적은 급여 - 서브
  
  를 받는 직원의 사번, 이름, 직급명, 부서코드, 급여, 입사일을 조회한다 -메인
 * */

SELECT MIN(e.SALARY ) FROM EMPLOYEE e ;-- 서브

SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MIN(e.SALARY ) FROM EMPLOYEE e)
;


-- ex3) 노옹철사원의 급여보다 많이 받는 직원의 사번, 이름, 부서명, 직급명, 급여를 조회한다

SELECT e.SALARY FROM EMPLOYEE e WHERE e.EMP_NAME ='노옹철';

SELECT e.EMP_ID,e.EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE e 
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) 
WHERE e.SALARY > (SELECT e.SALARY FROM EMPLOYEE e WHERE e.EMP_NAME ='노옹철')
;

/*
> ex4) 부서별로 (NULL부서 포함) 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계를 조회
 
  
부서별로 (NULL부서 포함) 급여의 합계 - 서브
의 합계 중 가장 큰 부서의 부서명, 급여 합계를 조회 - 메인 

 * */


SELECT DEPT_TITLE, SUM(SALARY ) 
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) 
= (SELECT  MAX(SUM(SALARY )) FROM EMPLOYEE GROUP BY EMPLOYEE.DEPT_CODE);






/*
 * 다중 행 서브쿼리
 * 
 * 서브쿼리의 조회 결과 값의 개수가 여러 행인 것. 
  
여러 값이 나오기 때문에 당연히 일반적인 비교 연산자는 사용할 수 없다

> IN / NOT IN
  
IN 또는 NOT IN을 사용할 수 있다: 여러 개의 결과값 중에서 한개라도 일치하는 값이 있다면 / 없다면

> ">ANY" "<ANY" 

여러 결과값들 중 한개라도 크거나 작은 경우, 즉 가장 작은값보다 큰 것이 있나? ">ANY"
가장 큰 값보다 작은 것이 있나? "<ANY" 

> ">ALL" "<ALL"   
  
여러 결과값들 모두보다 크거나 작은 경우 제일 크다면 ">ALL" "<ALL"
 
  
> EXISITS / NOT EXISITS
  
값이 존재하는가/ 존재하지 않는가?
 * */


-- 부서별 최고급여를 받는 (서브)
-- 직원의  이름, 직급, 부서, 급여를 부서 오름차순으로 정렬하여 조회한다 (메인)



-- 부서별 최고급여를 받는 (서브)

SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE;

-- 메인 쿼리 + 서브쿼리

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY 
FROM EMPLOYEE WHERE SALARY IN ( SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE ) ORDER BY DEPT_CODE ;


/*
ex2) 사수(MANAGER_ID사번)에 해당하는 직원에 대한 조회 => 사번, 이름, 부서명, 직급명, 구분 (사수/ 사원)조회 

사수에 해당하는 사원번호 조회 (서브쿼리)
  
 * */

SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL;


SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
; -- 메인쿼리


-- 종합

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
; 


SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
; 




-- 사수와 사원을 동시에 조회하려면?

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
 
UNION

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
; 


-- 합집합을 구하면 된다



SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, 
CASE WHEN EMP_ID IN 
(SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL) -- 사수가 맞는 조건
THEN '사수'
ELSE '사원'
END 구분
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID);


SELECT * FROM EMPLOYEE e;
SELECT * FROM JOB;
SELECT * FROM DEPARTMENT;








-- LAST
