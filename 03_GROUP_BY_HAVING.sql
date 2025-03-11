-- SELECT문의 해석순서 재정의

/*
 > SELECT문의 해석 순서 재정의


SELECT 컬럼 별칭 / 계산식/ 함수식

FROM 테이블명

WHERE 컬렴/함수식 비교연산자 비교값

GROUBBY 그룹을 묶을 컬럼명

HAVING 그룹함수식 비교연산자 비교값

ORDERBY 컬럼 / 별칭 / 순번 => DESC 또는 디폴트 + NULLS FIRST와 NULLS LAST
(NULL을 위에 띄울래 아래에 띄울래?)


> 해석 순서 

FROM => WHERE => GROUPBY => HAVING => SELECT + ORDERBY
 
 


-- GROUP BY절: 같은 값들이 여러 개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음

GROUP BY 컬럼 함수 
여러 개의 값을 묶어서 하나로 처리할 목적으로 사용함
그룹으로 묶은 값에 대해 SELECT 절에서 그룹 함수를 사용할 수 있음
그룹 함수는 단 하나의 결과만 산출하기에 그룹이 여럿일 경우 오류가 발생한다
여러 결과 값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDERBY 절에 기술하여 사용하곤 한다

 * */


-- ex1) EMPLOYEE 테이블에서 부서코드, 부서별로 급여 합을 조회한다

-- 일단 부서코드만
SELECT e.DEPT_CODE   FROM EMPLOYEE e ; --23행의 값

-- 전체 급여 합
SELECT SUM(e.SALARY)   FROM EMPLOYEE e ; --1행의 값


SELECT e.DEPT_CODE, SUM(e.SALARY )   FROM EMPLOYEE e ; --23행의 값? 1행의 값?

SELECT e.DEPT_CODE, SUM(e.SALARY )   FROM EMPLOYEE e  GROUP BY e.DEPT_CODE ;

-- DEPT_CODE 컬럼을 그룹으로 묶어, 그 그룹의 급여 합계 (SUM(SALARY))를 구한다


-- ex2) EMPLOYEE테이블에서 (FROM)  직급코드가 같은 사람의 (GROUPBY절) 
-- 직급코드, 급여코드, 급여평균, 인원수를 (SELECT) 직급코드 오름차순으로 조회 (ORDERBY)


SELECT e.JOB_CODE, ROUND( AVG( e.SALARY )) , COUNT(*)  FROM EMPLOYEE e GROUP BY e.JOB_CODE ORDER BY e.JOB_CODE ASC  ;


-- ex3) EMPLOYEE테이블에서 (FROM)  성별과 각 성별 별 인원수, 급여합을 인원수 오름차순으로 조회한다
-- 성별별 = 남자 따로 여자 따로 묶어라 = GROUPBY
-- SUBSTR와 DECODE를 동시에 사용한다.

SELECT  DECODE( SUBSTR(e.EMP_NO, 8, 1),'1','남','2','여','오류') 성별, COUNT(*) "인원 수", SUM(e.SALARY ) "급여 함"  

FROM EMPLOYEE e GROUP BY  DECODE( SUBSTR(e.EMP_NO, 8, 1),'1','남','2','여','오류') 

ORDER BY "인원 수";

-- 해석순서대로 작성해야 함: FROM WHERE GROUPBY HAVING SELECT


-- WHERE절을 추가한 GROUPBY절

/*
 
 WHERE절은 각 컬럼값에 대한 조건 + HAVING절은 그룹에 대한 조건
 
 */


--FROM WHERE GROUPBY HAVING SELECT 

-- ex4) EMPLOYEE TABLE에서 부서 코드가 D5, D6인 부서의 부서코드, 평균급여, 인원수를 조회한다

SELECT e.DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE e -- 이것이 1번
WHERE e.DEPT_CODE IN('D5','D6') -- 2번으로부서코드가 D5, D6를  묶음
GROUP BY e.DEPT_CODE; -- 3번으로 그 결과를 그룹으로 묶는다

-- D5 D6만 잘라서 보고 싶으므로 DEPT로 묶으면 안 됨 => 부서코드, 평균급여, 인원 수 조회


-- 연습문제)EMPLOYEE TABLE에서(FROM) 2000년도 이후 입사자들의 (WHERE) 직급별 (GROUP BY) 급여 합을 (SELECT) 조회

SELECT SUM(e.SALARY ) FROM EMPLOYEE e WHERE e.HIRE_DATE > TO_DATE('2000-01-01')  GROUP BY e.JOB_CODE   ;

SELECT SUM(e.SALARY ) FROM EMPLOYEE e WHERE EXTRACT(YEAR FROM e.HIRE_DATE) >= 2000 GROUP BY  e.JOB_CODE    ;
-- SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY'),1,4) >= '2000'
-- TODATE로 형식을 지정한 후  SUBSTR을 하는 방법은 너무 어려움

/*
 여러 컬럼을 묶어서 그룹으로 지정 가능 => 그룹 내 그룹이 가능하다
 
 주의 사항 
 
 SELECT문에서 GROUP BY절을 사용하는 경우
 SELECT절에 명시한 조회하려는 컬럼 중 
 그룹 함수가 적용되지 않은 컬럼은 모두 GROUP BY절에 작성되어 있어야만 한다
 
 * */




/* ex5) EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 인원수를 조회한다 => 부서코드 오름차순, 직급코드 내림차순으로 정렬한다 
 => SELECT절은 부서코드 직급코드 인원수

 부서별로 같은 직급 => 부서도 같은것끼리 묶어야 하고 직급도 같은 직급으로 묶어야 한다. 
 즉 GROUPBY절의 내용이 DEPT_CODE이고 JOB_CODE도 다시 묶겠다는 말

*/

SELECT e.DEPT_CODE, e.JOB_CODE, COUNT(*) FROM EMPLOYEE e 
GROUP BY  e.DEPT_CODE, e.JOB_CODE -- GROUPBY 앞쪽에 있는 기준으로 일단 그룹화하고 그 내에서 뒤쪽 내용으로 그룹화를 실행하게 됨
ORDER BY DEPT_CODE ASC , JOB_CODE DESC;



/*
 
 HAVING절: 그룹 함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
 HAVING 컬럼 / 함수 비교연산자 비교값

 쓰는 순서: 
 
 읽는 순서: FROM WHERE GROUPBY HAVING SELECT 

 
 **/


-- ex6) EMPLOYEE 테이블에서 부서별 평균 급여가 3백만원 이상인 부서의 부서코드와 평균 급여를 조회한다 => 부서코드는 오름차순으로 작성한다


SELECT * FROM EMPLOYEE e WHERE e.SALARY ;
-- 23명 각각의 사람 중 3백만원 이상인 것을 거른다? 요구 사항과 맞지 않음 => 부서의 평균이 3백이상이어야 함 

SELECT e.DEPT_CODE, ROUND ( AVG (SALARY)) FROM EMPLOYEE e 
GROUP BY e.DEPT_CODE HAVING AVG(e.SALARY)> 3000000 
-- 일단 DEPT_CODE로 묶고 그룹별로 조건을 설정하는 (300만원 이상) HAVING절.
ORDER BY e.DEPT_CODE ;


-- 연습문제) EMPLOYEE 테이블에서 직급별 인원수가 5명이하인 직급코드와 인원수를 조회한다 (직급코드는 오름차순으로 정렬한다)

SELECT e.JOB_CODE, COUNT(*) FROM EMPLOYEE e 
GROUP BY e.JOB_CODE HAVING COUNT(*)<=5 ORDER BY JOB_CODE  ;

/*
 오직 GROUP BY절에서만 사용할 수 있다

그룹 별 산출 결과 값의 집계를 계산하는 함수 (그룹별로 중간 집계 결과를 추가적으로 보여 줌)

ROLL UP: GROUP BY절에서 가장 먼저 작성 된 컬럼의 중간 집계를 처리하는 함수이다

 * */

SELECT e.DEPT_CODE, e.JOB_CODE, COUNT(*) FROM EMPLOYEE e GROUP BY  e.DEPT_CODE, e.JOB_CODE ORDER BY 1;


SELECT e.DEPT_CODE, e.JOB_CODE, COUNT(*) FROM EMPLOYEE e GROUP BY ROLLUP( e.DEPT_CODE, e.JOB_CODE ) ORDER BY 1;
-- 중간 집계를 내주는 함수: DEPT_CODE를 기준으로 중간 집계를 작성한다 (D1은 합쳐서 얼만데? D2는 합쳐서 얼만데?만 결과로 나온다)


SELECT e.DEPT_CODE, e.JOB_CODE, COUNT(*) FROM EMPLOYEE e GROUP BY CUBE( e.DEPT_CODE, e.JOB_CODE ) ORDER BY 1;

-- 중간 집계를 내주는 함수: DEPT_CODE를 기준으로 일단 중간합계를 내주고 
-- 그 이후 무조건 JOB_CODE 기준으로도 내준다. 출력 순서의 차이만 있을 뿐 무조건적으로 출력한다는 차이가 있다


/*
 여러 SELECT절의 결과인 RESULT SET을 하나의 결과로 만드는 연산자

-UNION: 합집합 => 두 SELECT의 결과를 하나로 합쳐서 조회하되 중복되는 내용은 한 번만 나오도록

-INTERSECT: 교집합 => 두 SELECT 결과 중 중복되는 부분만 조회

-UNIONALL: 합집합 + 교집합 => UNION + INTERSECT로 합집합에서 중복되는 부분을 아예 제거한 내용을 조회

-MINUS: 차집합 => A에서 A교집합B를 뺌
 
 * */


-- EMPLOYEE 테이블에서 

-- (1번째 SELECT문): 부서코드가 D5인 사원의 사번, 이름, 부서코드, 급여 조회

-- (2번째 SELECT문): 급여가 300만원 초과인 사원의 사번, 이름, 부서코드, 급여 조회


SELECT e.EMP_ID, e.EMP_NAME, e.DEPT_CODE, e.SALARY  FROM EMPLOYEE e WHERE DEPT_CODE = 'D5'

MINUS

SELECT e.EMP_ID, e.EMP_NAME, e.DEPT_CODE, e.SALARY  FROM EMPLOYEE e WHERE SALARY > 3000000  ;



/*
 > 집합연산자 사용 시 주의사항

집합연산자 사용을 위한 SELECT문들은 조회하는 컬럼의 타입과 개수가 동일해야 한다

개수는 그렇다 치는데 타입까지 동일해야?

같은 컬럼일 필요는 없지만 타입과 개수까지 반드시 동일해야 한다!
 * */


SELECT e.EMP_ID, e.EMP_NAME, e.DEPT_CODE, e.SALARY  FROM EMPLOYEE e WHERE e.DEPT_CODE='D5'
UNION
SELECT e.EMP_ID, e.EMP_NAME, e.DEPT_CODE, 1 FROM EMPLOYEE e WHERE SALARY > 3000000 ;



-- 게다가 테이블이 달라도 컬럼의 타입과 개수만 일치한다면 집합 연산자를 사용 가능하다

SELECT e.EMP_ID, e.EMP_NAME FROM EMPLOYEE e

UNION

SELECT d.DEPT_ID, d.DEPT_TITLE  FROM DEPARTMENT d  ;



-- LAST