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
 * */

--사수에 해당하는 사원번호 조회 (서브쿼리)
SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL
;


SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID) 
WHERE MANAGER_ID IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL) 
; -- 메인쿼리

SELECT * FROM EMPLOYEE;

-- 종합

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
; 

--NOT조건을 같이 

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
; 

-- 사수이거나 사수가아닌 평직원이거나

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, 
CASE 
	WHEN
	EMP_ID IN (SELECT DISTINCT e.MANAGER_ID FROM EMPLOYEE e WHERE e.MANAGER_ID IS NOT NULL)
	THEN
	'사수'
	ELSE
	'사원'
	END
"구분"
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN  DEPARTMENT  ON (DEPT_CODE = DEPT_ID)
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
CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID 
			FROM EMPLOYEE 
			WHERE MANAGER_ID IS NOT NULL) -- 사수가 맞는 조건
	THEN '사수'
	ELSE '사원'
END 구분
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE) 
LEFT JOIN  DEPARTMENT  
ON (DEPT_CODE = DEPT_ID);
ORDER BY EMP_ID;


-- > ex5) 대리 직급의 직원들 중 
-- 과장 직급의 최소 급여
--보다 많이 받는 직원의 사번, 이름, 직급명, 급여를 조회하라


-- "> ANY"를 사용 => 가장 작은 값보다 큰가?


-- 메인: 직급이 대리인 직원들의 사번, 이름, 직급 ,급여 조회 (메인)

SELECT EMP_ID, EMP_NAME, J.JOB_CODE  , e.SALARY   
FROM EMPLOYEE e JOIN JOB J ON (j.JOB_CODE  = e.JOB_CODE )
WHERE JOB_NAME = '대리' ;


-- 서브
SELECT MIN(SALARY) FROM EMPLOYEE JOIN JOB USING (JOB_CODE) WHERE JOB_NAME ='과장'  ;



-- 메인 + 서브

SELECT EMP_ID, EMP_NAME, J.JOB_CODE  , e.SALARY   
FROM EMPLOYEE e JOIN JOB J ON (j.JOB_CODE  = e.JOB_CODE )
WHERE JOB_NAME = '대리' AND e.SALARY > ANY (SELECT MIN(SALARY) FROM EMPLOYEE JOIN JOB USING (JOB_CODE) WHERE JOB_NAME ='과장')  ;











-- SOLUTION1) ANY를 이용하기


SELECT e.EMP_ID , e.EMP_NAME, JOB_NAME, e.SALARY  
FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) 
WHERE JOB_NAME ='대리' 
AND SALARY > ANY 
(SELECT SALARY FROM EMPLOYEE e 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME ='과장') ;


/*
 가장 작은 값보다 큰가? ">ANY"
(해당 대리의 각 행이) 과장직급 최소 급여보다 더 큰 급여를 받는가?
  
가장 큰 값보다 작은가? "<ANY"
(해당 대리의 각 행이) 과장직급 최대 급여보다 더 작은 급여를 받는가?
 * */


-- > ex5) 대리 직급의 직원들 중 
-- 과장 직급의 최소 급여
--보다 많이 받는 직원의 사번, 이름, 직급명, 급여를 조회하라

-- SOLUTION2) MIN을 이용하여 단일행 서브쿼리로 만들어 해결

SELECT e.EMP_ID , e.EMP_NAME, JOB_NAME, e.SALARY  
FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) 
WHERE JOB.JOB_NAME  ='대리' AND SALARY > 
(SELECT MIN(SALARY) FROM EMPLOYEE JOIN JOB USING (JOB_CODE) WHERE JOB_NAME ='과장');

/*
 > ALL 연산자의 이해
  
 ex6) 차장 직급의 급여 중 가장 큰 값보다 많이 받는 과장 직급의 직원의 
  사번, 이름, 직급, 급여를 조회하라
 * */

-- >ALL, <ALL : 가장 큰 값보다 크냐?, 가장 작은 값보다 작냐?

-- 6-1) 차장 직급의 모든 급여를 조회

SELECT e.SALARY  FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) WHERE JOB.JOB_NAME ='차장' ; 


-- 6-2) 메인에서 그것보다 급여가 많으면서 과장인 것을 구한다

SELECT e.EMP_ID, e.EMP_NAME, e.JOB_CODE  
FROM EMPLOYEE e JOIN JOB j ON (e.JOB_CODE = j.JOB_CODE)  WHERE JOB_NAME= '과장' AND e.SALARY >ALL (SELECT e.SALARY  FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) WHERE JOB.JOB_NAME ='차장') ;

-- 최고보다 크거나 최저보다 작으면 ALL, 최고보다는 작거나 최저보다는 크다면 ANY를 둘다 범위 연산자에서 쓰인다

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT d ;
SELECT * FROM JOB ;

/*
문제 개요:
LOCATION 테이블에서 **NATIONAL_CODE가 'KO'**인 경우, 해당하는 LOCAL_CODE를 찾는다.
DEPARTMENT 테이블에서 위에서 찾은 LOCAL_CODE가 LOCATION_ID와 같은 경우, 해당 DEPT_ID를 찾는다.
EMPLOYEE 테이블에서 위에서 찾은 DEPT_ID와 동일한 DEPT_CODE를 가진 사원(EMPLOYEE)을 조회한다.

"LOCATION 테이블에서 NATIONAL_CODE가 'KO'인 지역의 LOCAL_CODE를 찾고, 
이를 기반으로 DEPARTMENT 테이블에서 해당 LOCATION_ID를 가진 부서(DEPT_ID)를 찾은 후, 
해당 부서(DEPT_ID)와 같은 DEPT_CODE를 가진 EMPLOYEE 테이블의 사원 정보를 조회하라."

*/




-- 1) LOCATION테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE를 조회한다

SELECT l.LOCAL_CODE FROM LOCATION l WHERE l.NATIONAL_CODE ='KO' ;


-- 2) LOCAL 코드가 DEPARTMENT 테이블에서 LOCATION_ID와 동일한 DEPT_ID가 


SELECT d.DEPT_ID  FROM LOCATION l JOIN DEPARTMENT d ON (l.LOCAL_CODE = d.LOCATION_ID) WHERE l.LOCAL_CODE  = (SELECT l.LOCAL_CODE FROM LOCATION l WHERE l.NATIONAL_CODE ='KO')  ;




-- 3) EMPLOYEE테이블에서 위 결과들과 동일한 DEPT_CODE를 가진 사원을 조회한다

SELECT e.EMP_NAME  FROM EMPLOYEE e JOIN JOB j ON (e.JOB_CODE = j.JOB_CODE)  
WHERE e.DEPT_CODE 
IN 
(SELECT d.DEPT_ID  FROM LOCATION l JOIN DEPARTMENT d ON (l.LOCAL_CODE = d.LOCATION_ID) WHERE l.LOCAL_CODE  = (SELECT l.LOCAL_CODE FROM LOCATION l WHERE l.NATIONAL_CODE ='KO') 
)   ;

SELECT * FROM LOCATION l ;
SELECT * FROM DEPARTMENT d  ; 
SELECT * FROM JOB j   ; 



/*
> 응용: 서브 쿼리의 중첩 사용
LOCATION 테이블에서 
NATIONAL코드가 KO인 경우 
위에서 나온 LOCAL 코드와 DEPARTMENT 테이블에서 LOCATION_ID와 동일한 DEPT_ID가 
EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원을 조회하라
*/


--이미 연산자에 올 값이 다중 행이라 IN 등을 써야 함

/*
 정확히는 단일행 다중열에 해당 

서브 쿼리 SELECT절에 나열된 컬럼의 개수가 여럿
  
> ex) 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름과 직급코드, 부서코드, 입사일을 조회한다
 * */

-- 1) 퇴사한 여직원 조회하기

SELECT DEPT_CODE, JOB_CODE  
FROM EMPLOYEE 
WHERE ENT_YN ='Y'AND SUBSTR (EMP_NO,8,1)='2';

-- SOLUTION1) 단일행, 단일열 서브쿼리 둘을 사용한다

SELECT DEPT_CODE 
FROM EMPLOYEE 
WHERE ENT_YN ='Y'AND SUBSTR (EMP_NO,8,1)='2';

SELECT JOB_CODE 
FROM EMPLOYEE 
WHERE ENT_YN ='Y'AND SUBSTR (EMP_NO,8,1)='2';


-- 메인

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE 
FROM EMPLOYEE 
WHERE ENT_YN ='Y'AND SUBSTR (EMP_NO,8,1)='2' ) AND JOB_CODE = ( SELECT JOB_CODE 
FROM EMPLOYEE 
WHERE ENT_YN ='Y'AND SUBSTR (EMP_NO,8,1)='2')
;


-- SOLUTION2) 다중열 서브쿼리 사용


SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE 

FROM EMPLOYEE 

WHERE (DEPT_CODE, JOB_CODE ) -- 여기서 WHERE절에 작성된 컬럼 순서에 맞게 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
-- 즉 컬럼의 순서가 중요사항
=(SELECT DEPT_CODE, JOB_CODE  

FROM EMPLOYEE 

WHERE ENT_YN ='Y'AND SUBSTR (EMP_NO,8,1)='2' );





-- 연습문제1) 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회 (단, 본인은 제외) => 사번, 이름, 부서코드, 직급코드, 부서명, 직급명


SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME  

FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) 

LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) 

WHERE (DEPT_CODE, JOB_CODE ) = (SELECT DEPT_CODE, JOB_CODE  

FROM EMPLOYEE 

WHERE EMPLOYEE.EMP_NAME ='노옹철'  ) AND EMP_NAME<>'노옹철'
;


/*
SELECT DEPT_CODE, JOB_CODE  FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) 
WHERE EXTRACT (YEAR FROM HIRE_DATE ) = '2000'
;*/

-- 연습문제2) 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회 => 사번, 이름, 부서코드 , 직급코드, 입사일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE 
FROM EMPLOYEE e 
WHERE (DEPT_CODE, JOB_CODE ) = (SELECT DEPT_CODE, JOB_CODE  FROM EMPLOYEE e JOIN JOB USING (JOB_CODE) 
WHERE EXTRACT (YEAR FROM HIRE_DATE ) = '2000');


-- 연습문제3) 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회 => 사번, 이름, 부서코드, 사수번호, 주민번호, 입사일

--서브 시작

SELECT e.DEPT_CODE , e.MANAGER_ID  FROM EMPLOYEE e WHERE (SUBSTR(e.EMP_NO,8,1) = 2) AND (SUBSTR(e.EMP_NO,1,2) =77)  ;  -- 여자사원 + 77년생
-- 동일한 부서, 사수

SELECT * FROM EMPLOYEE e WHERE (e.DEPT_CODE, e.MANAGER_ID) 
= (SELECT e.DEPT_CODE , e.MANAGER_ID  FROM EMPLOYEE e WHERE (SUBSTR(e.EMP_NO,8,1) = 2) AND (SUBSTR(e.EMP_NO,1,2) =77)   -- 여자사원 + 77년생
)   ;

-- 서브 끝



/*
행과 열이 모두 여럿 => 서브쿼리 조회 결과 행의 수와 열의 수가 여럿일 때 
  
본인이 소속된 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회한다
(단, 급여와 급여 평균은 만원단위에서 끊는다 TRUNC (컬럼명, -4)) 

 * */


--1) 직급별로 평균 급여를 구한다 => 서브 쿼리
SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
FROM EMPLOYEE
GROUP BY JOB_CODE;


--2) 사번, 이름, 직급코드 ,급여 => 평균 급여와 같은 값을 받고있는 직원 찾기

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE e WHERE (JOB_CODE, SALARY) -- 이 중에 정확히 일치하는 것이 있냐 => IN

IN (SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
FROM EMPLOYEE
GROUP BY JOB_CODE);


SELECT * FROM EMPLOYEE e ;





/*
 메인쿼리가 사용하는 테이블의 값이 있음 => 서브쿼리안에 그것이 들어 감
  
메인 쿼리의 테이블값이 변경되면 서브쿼리 결과 값이 변하는 구조
  
메인쿼리 한 행을 조회하고 해당 행이 서브쿼리의 조건을 충족하는지 확인 => SELECT
  
해석순서가 기존 서브쿼리와 다름 => 
  
메인쿼리 한 행을 읽고 그 한 행에 대해 서브 쿼리를 수행한다.

메인쿼리 다음 행을 읽고 그 한 행에 대해 서브 쿼리를 수행한다.
  
....  
....
....  
메인쿼리 마지막 행을 읽고 그 한 행에 대해 서브 쿼리를 수행한다.
  
 * */

-- ex) 직급별 급여평균보다 급여를 많이 받는 직원의 
--이름과 직급코드와, 급여를 조회 BY 상관서브쿼리

-- 메인쿼리

SELECT EMP_NAME, JOB_CODE, e.SALARY  FROM EMPLOYEE e ;
SELECT AVG(SALARY) FROM EMPLOYEE e WHERE JOB_CODE ='J1';  --  직급별인데 GROUP BY가 아님. 한 행만 일단 생각해봐
-- 서브쿼리
-- J1인 잡코드를 가지는 행만 가지고 평균을 냄 => 당연히 한 사람이니 8백만원 
-- => 다시 메인 쿼리로 감 => 급여 평균 800만원인데 800만원보다 많이 받냐? FALSE 
-- => 최종 RESULT SET에서 제외
SELECT AVG(SALARY) FROM EMPLOYEE e WHERE JOB_CODE ='J2';  --  직급별인데 GROUP BY가 아님. 한 행만 일단 생각해봐

-- 송종기 J2인 잡코드를 가지는 행만 가지고 평균을 냄 => 480만원
-- => 다시 메인 쿼리로 감 => 급여 평균 480만원인데 480만원보다 많이 받냐? TRUE
-- => 최종 RESULT SET에 포함


-- 노옹철 J2인 잡코드를 가지는 행만 가지고 평균을 냄 => 600만원
-- => 다시 메인 쿼리로 감 => 급여 평균 480만원인데 480만원보다 많이 받냐? FALSE
-- => 최종 RESULT SET에서 제외


-- 이와같은 식으로 진행한다

-- 메인의 급여> 서브쿼리의 조건인 것만 조회하겠다


-- 상관쿼리 이름
SELECT EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE MAIN 
WHERE SALARY > ( SELECT AVG(SALARY) FROM EMPLOYEE SUB WHERE MAIN.JOB_CODE = SUB.JOB_CODE)
;



-- 사수가 있는 직원의 사번, 이름, 부서명, 사수의사번을 조회한다
-- 상관 서브쿼리를 이용하여 각 직원의 MANAGER_ID가 실제로 직원 테이블의 EMP_ID와 일치하는지 확인한다



-- 메인쿼리: 직원의 사번, 이름, 부서명, 사수의사번을 조회한다
-- 서브쿼리: 사수인 직원 조회

-- 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID 
FROM EMPLOYEE e LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);  -- 아이디가 없는 것도 포함

SELECT EMP_ID FROM EMPLOYEE e WHERE e.EMP_ID  = 200; -- 사수가 실제로 존재하는 직원 (선동일이 사수)

SELECT EMP_ID FROM EMPLOYEE e WHERE e.EMP_ID  = 214; -- 사수가 실제로 존재하는 직원 (방명수가 사수)


-- 최종

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID 
FROM EMPLOYEE MAIN LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) WHERE MANAGER_ID = (SELECT EMP_ID FROM EMPLOYEE SUB WHERE SUB.EMP_ID =MAIN.MANAGER_ID  )
;



-- ex3)

-- 부서별 입사일이 가장 빠른 사원의 사번과 이름, 부서코드와 부서이름 (NULL이라면 소속이 없다), 직급명, 입사일을 조회한다

-- 입사일이 빠른순으로 정렬하되 퇴사한 사원은 제외한다


/*메인쿼리

사원의 사번과 이름, 부서코드와 부서이름 (NULL이라면 소속이 없다), 직급명, 입사일 + 퇴사한 사원은 제외
*/


/* 서브쿼리
부서별 입사일이 가장 빠른 사원
*/


-- 메인

SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N' ; 


-- 서브

-- MIN을 이용하여 입사일의 값이 가장 작은 것을 찾는다

SELECT MIN(HIRE_DATE) FROM EMPLOYEE WHERE DEPT_CODE = 'D1'; -- 방명수는 가장 빠른 입사일을 가진 사람이 아니므로 제외

SELECT MIN(HIRE_DATE) FROM EMPLOYEE WHERE DEPT_CODE = 'D2'; -- 차태연은 가장 빠른 입사일을 가진 사람이 아니므로 제외

SELECT MIN(HIRE_DATE) FROM EMPLOYEE WHERE DEPT_CODE = 'D3'; -- 전지연은 가장 빠른 입사일을 가진 사람이 맞다

SELECT MIN(HIRE_DATE) FROM EMPLOYEE WHERE DEPT_CODE = 'D4'; -- 임시환은 가장 빠른 입사일을 가진 사람이 아니므로 제외


SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE MAIN JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N' AND HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE WHERE DEPT_CODE = 'D4' )
-- 원하는 것은 이게 아님!
;


SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE MAIN JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N' AND HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE SUB WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE )
-- 이것이 원하는 것 (퇴사자 없으면 부서 X)
;




-- 상관쿼리1) 
/*
 이태림이 DB부서에서 가장빠른 입사& 퇴사자여서 걸러졌는데 D8부서가 아예 제외되게 만들고싶지는 않음 
 -> 메인쿼리에서 퇴사자 & DB부서의 가장 빠른 입사일인 이태림을 이미 제외시킨 상태
 * */

SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE MAIN JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N' AND HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE SUB WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE) 
ORDER BY HIRE_DATE;
;

-- 상관쿼리2) 
/*
 D8을 포함시키고 이태림을 빼고 D8에서 제일 
 
 * */
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE MAIN JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
 WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE)
								FROM EMPLOYEE SUB
								WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE AND ENT_YN = 'N' 
								OR (SUB.DEPT_CODE IS NULL AND MAIN.DEPT_CODE IS NULL))
ORDER BY HIRE_DATE;





-- D8부서의 가장 빠른 입사일 => 메인 쿼리에서 퇴사자 & D8부서의 가장빠른 입사일인 이태림을 벌써 제외시킨 상태 => 원하는 결과가 안 나옴









-- 모든 직원의 이름, 직급, 급여, 전체사원 중 가장 높은 급여와의 차를 조회
-- 서브 = 전체사원 중 가장 높은 급여


SELECT EMP_NAME, JOB_CODE, SALARY, (SELECT MAX(SALARY) FROM EMPLOYEE) -SALARY "급여차" FROM EMPLOYEE ;




-- 모든 직원의 이름, 직급, 급여, 각 직원들이 속한 직급의 급여 평균을 조회

-- 각 직원들이 속한 직급 (스칼라+ 상관 커리)의 서브쿼리



SELECT EMP_NAME, JOB_CODE, SALARY  FROM EMPLOYEE ;

-- 서브쿼리 

SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE ='J1' ;
SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE ='J2' ;
SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE ='J3' ;




--최종

SELECT EMP_NAME, JOB_CODE, SALARY, (SELECT ROUND(AVG(SALARY),-3) FROM EMPLOYEE SUB WHERE SUB.JOB_CODE = MAIN.JOB_CODE) 평균  FROM EMPLOYEE MAIN 
;


-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회 (단 관리자가 없는 경우 '없음'으로 표시) => 스칼라와 상관 커리르 섞어라


-- 메인
SELECT EMP_NO, EMP_NAME, MANAGER_ID, NVL ( ( SELECT EMP_NAME FROM EMPLOYEE SUB  WHERE  MAIN.MANAGER_ID = SUB.EMP_ID ), '없음' )관리자명  FROM EMPLOYEE MAIN ;

-- 서브

( SELECT EMP_NAME FROM EMPLOYEE SUB  WHERE  MAIN.MANAGER_ID = SUB.EMP_ID );






/*
  INLINE VIEW


FROM절에서 서브쿼리를 사용하는 경우임 => 서브쿼리가 만든 결과의 RESULT SET을 테이블취급하여 사용하는 것
  
 * */


SELECT EMP_NAME 이름, DEPT_TITLE 부서 FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); 


-- 부서가 기술지원부인 모든 컬럼을 조회


SELECT * FROM 
( 
SELECT EMP_NAME 이름, DEPT_TITLE 부서 FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
)
WHERE 부서 = '기술지원부';




-- TOP N 분석 => 전직원 중 급여가 높은 상위 5명의 순위와 이름과 급여를 조회한다

-- ROW NUM 가상 컬럼 => 행 번호를 나타내는 가상 컬럼

-- ROW NUM은 SELECT, WHERE, ORDERBY절에서 사용 가능

SELECT ROWNUM, EMP_NAME, SALARY FROM EMPLOYEE WHERE ROWNUM<=5 ORDER BY SALARY DESC  ;
-- SELECT문의 해석순서 때문에 급여상 TOP5가 아닌 조회순서는 따로 있고 상위 5명끼리의 급여 순위가 조회되는 것 => 일단 SELECT되었으니 그 이후에 

-- 이름, 급여를 급여 내림차수능로 조회한 결과를 인라인뷰 사용하여 조회한다 => FROM절에 작성된다면 해석순위가 제일 앞선다



-- 단계1: 서브쿼리의 작성
SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC ;



-- 단계2: 메인쿼리 조회 시 ROWNUM을 5이하까지만 조회
SELECT ROWNUM, EMP_NAME, SALARY 
FROM ( SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC ) -- 1순위 해석 FROM자체가 전체 직원의 SALARY를 내림차순 정렬
WHERE ROWNUM<=5; -- 2순위 해석
;



-- ex2)
-- 급여평균이 3위안에 드는 부서의 부서코드, 부서명, 평균급여를 조회한다
-- 인라인뷰 내에 GROUPBY를 써야 함

-- 서브 (급여평균이 3위 내)

SELECT DEPT_CODE, DEPT_TITLE, AVG(SALARY) "평균급여"  
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY AVG(SALARY) DESC
; -- 서브쿼리 내에도 테이블이 되어야 하므로 세 개의 컬럼이 있어야 함


-- 메인

SELECT DEPT_CODE, DEPT_TITLE, "평균급여"
FROM  (SELECT DEPT_CODE, DEPT_TITLE, AVG(SALARY) "평균급여"  
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY AVG(SALARY) DESC) 
WHERE ROWNUM<=3
;


-- 전직원의 급여 10 순위

-- 서브

SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY  DESC;
-- 결과 값을 테이블로 사용하는 인라인뷰 사용 예정 => 복사붙여넣기 하지 말고 WITH AS를 앞에 쓰자

/*

WITH 
서브쿼리에 이름을 붙이고 마치 그 이름처럼 사용한다 => 인라인뷰로 사용될, 즉 결과값일 테이블인 서브쿼리에 주로 사용됨
실행속도가 빨라짐
 * */ 



WITH TOP_SAL AS (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY  DESC)
SELECT ROWNUM, EMP_NAME, SALARY FROM TOP_SAL WHERE ROWNUM<=10;
-- 그 뒤에 메인을 붙여넣으면 됨







-- RANK() OVER / DENSE_RANK() OVER

/*
 
 RANK()OVER => 동일한 순위 이후의 등수를 동점인 인원수 만큼 건너뛰게끔 순위를 계산한다
 가령 1등이 두명이면 그 다음은 3위가 됨
 
 
 ex) 사원별 급여 순위
 
 RANK() OVER (정렬 순서) / DENSE_RANK() OVER(정렬순서)

 * */


SELECT RANK() OVER (ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY FROM EMPLOYEE;


SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY FROM EMPLOYEE;







-- DENSE_RANK() OVER(ORDER BY) => 공동 1위가 둘이어도 다음 순위는 2위










-- LAST
