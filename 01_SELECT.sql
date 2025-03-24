-- 
/*
 * > 개넘정리
SQL = Structured Query Language의 약자 (구조적 질의언어)
데이터 베이스와 상호작용하기 위해 사용하는 표준 언어
이를 이용하여 데이터 조회, 삽입, 수정, 삭제 가능


> SELECT란?

SELECT는 "조회" => 데이터를 조회하면 조건에 맞는 행들이 조회된다.

=> 데이터 조회한 결과는 행이 나오는데 이를 RESULT SET이라 한다.
 * RESULT SET은 0개 이상의 행이 포함될 수 있음. 즉 Result Set인데도 어떤 행도 조회되지 않는 경우가 있다. 조건에 맞는 행이 아예 없을 수 있기 때문이다.
 * 
 * 
 * 
> 작성법

SELECT 컬럼이름 FROM 테이블이름;
테이블에서 컬럼을 조회한다는 의미
 * 
 * 
 */

-- "*": 모든 컬럼을 조회한다는 뜻


SELECT * FROM EMPLOYEE;

-- 콤마를 통해 조회할 컬럼을 결정할 수 있다


SELECT EMP_ID, EMP_NO, PHONE  FROM EMPLOYEE;


-- 컬럼 값에 대한 산술 연산
-- 컬럼 값: 테이블 내 한 칸에 작성된 값 DATA

-- EMPLOYEE TABLE에서 모든 사원의 사번, 이름, 급여, 연봉을 조회 => 일단 FROM EMPLOYEE의 모든 것을 출력해서 살펴보기로 한다


SELECT EMP_ID, EMP_NAME , SALARY, SALARY * 12  FROM EMPLOYEE;

-- SELECT EMP_NAME+10  FROM EMPLOYEE; <- SQL Error [1722] [42000]: ORA-01722: 수치가 부적합합니다



SELECT '같음' FROM DUAL WHERE 1 = '1';

/*
 * EMPLOYEE 테이블에는 '같음'이라는 문자열은 당연히 없다
하지만 모든 DB에서는 더미 테이블이 존재한다. DUAL이라는 테이블은 사실 없는 테이블인데 아무테이블이나 쓴 것이다. 

WHERE절에 있는 내용이 TRUE(1)라면 SELECT 뒤에 있는 문자를 표시한다는 의미이다.

**SELECT 표시할것 FROM DUAL WHERE 조건
**

DB에서는 문자열이나 문자나 상관 없이 홑따옴표로 표시된다.
DB에서는 같은 것이 ==이 아닌 =이다

그 말은 곧 숫자1과 문자1이 같다고 인식된다는 것이다.
 * */

-- NUMBER 타입인 숫자1과 문자열인 '1'은 같다고 인식 중이다
-- DUAL : ORACLE에서 사용하는 더미 테이블
-- 더미테이블이란? 실제 데이터를 저장하지는 않지만 임시 계산 또는 테스트 목적으로 사용할 때 호출
-- 문자열 타입이어도 저장된 값이 숫자라면 자동적인 형변환이 이루어져 연산이 가능하다.

SELECT EMP_ID +1000 FROM EMPLOYEE;




-- 날짜 타입의 SELECT

SELECT EMP_NAME, HIRE_DATE, SYSDATE  FROM EMPLOYEE;

--15:47:50.000 
-- SYSDATE: 시스템 상의 현재 시간 (날짜)를 나타내는 상수이다
-- DUAL의 더미 테이블에서도 조회 가능하다

-- 날짜 + 산술연산도 가능

SELECT SYSDATE -1, SYSDATE, SYSDATE+1 FROM DUAL;

--날짜에 +나 -를 연산할 시 일 단위로 계산 진행

/* alias SELECT 옆 내용이 직접 컬럼 이름으로 나오게 되는 것이 디폴트
 하지만 컬럼에 별칭을 주는 것도 가능
 컬럼명 AS 별칭
 
 별칭은 오직 문자만 가능!!
 
 컬럼명 AS " "를 하면 별칭 안에 띄어쓰기나 특수문자를 사용할 수 있다
 

AS는 있어도 되고 없어도 된다
 

*/


SELECT SYSDATE -1 "하루 전" , SYSDATE AS "현재 시간!!" , SYSDATE+1 AS "내일" FROM DUAL;

/*
 * > 리터럴 표기법

자바에서 리터럴 = 값 자체

DB에서 리터럴 = 임의로 지정한 값을 기존 테이블에 존재하는 값처럼 사용하는 것. 즉 마치 처음부터 존재하는 것처럼 사용하는 것

DB에서 리터럴을 나타내는 방법은 홑따옴표 ''
이는 문자열을 나타내는 표기법과 겹침

가령 SELECT '같음' FROM DUAL WHERE 1= '1';
 * */



SELECT EMP_NAME, SALARY, '원 입니다' FROM EMPLOYEE;


/*
 * > DISTINCT: 조회 시 컬럼에 표시된 중복 값을 한번만 표기하고 싶을 때

주의사항 1) DISTINCT 구문은 SELECT마다 딱 한번씩만 작성 가능
주의사항 2) DISTINCT 구문은 반드시 SELECT문 제일 앞에 나와야 한다
 * */

SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;


/*
 * > 조건을 검색하는 SELECT의 WHERE

SELECT 문 = SELECT 절 FROM 절 WHERE 절 ORDERBY 절;

SELECT절: SELECT 컬럼명
FROM절: FROM 테이블명
WHERE절 (조건절): WHERE 컬럼명 연산자 값
ORDER BY절: ORDER BY (컬럼명 또는 별칭 또는 컬럼순서) 

=> [ ASC 또는 DESC ]
=> [ NULLS FIRST 또는 NULLS LAST ]


'문'이라는 것은 순서가 중요 

어느테이블에서 어떤 조건의 조회할 대상을 정렬
FROM절 => WHERE절 => SELECT절 => ORDER BY절
 * */


/*
 * EMPLOYEE 테이블서 (FROM)

급여가 300만원 초과인 사원의 (WHERE)

사번, 이름 부서 코드를 조회한다 (SELECT)

 * */


SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE SALARY>3000000; /*WHERE절 */
-- CTRL+SHIFT + 위아래 방향키 = 줄의 이동 (CTRL+ALT로 복사하는 것은 똑같음)

/*
 * EMPLOYEE 테이블서 (FROM)

부서코드가 D9인 사원의 (WHERE)

사번, 이름, 부서 코드, 직급코드를 조회한다 (SELECT)

 * */
SELECT EMP_ID, EMP_NAME,  DEPT_CODE, JOB_CODE /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE DEPT_CODE='D9' ; /*WHERE절 */


-- 논리연산자 (AND OR)

/*
 * EMPLOYEE 테이블서 (FROM)

급여가 300만원 미만 또는 500만원 이상인 사람의 (WHERE)

사번, 이름, 급여, 전화번호를 조회한다 (SELECT)

 * */


SELECT EMP_ID, EMP_NAME, SALARY , PHONE /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE SALARY <3000000 OR SALARY >= 5000000  ; /*WHERE절 */




/*
 * EMPLOYEE 테이블서 (FROM)

급여가 300만원 이상 500만원 미만 사람의 (WHERE)

사번, 이름, 급여, 전화번호를 조회한다 (SELECT)

 * */

SELECT EMP_ID, EMP_NAME, SALARY , PHONE /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE SALARY >= 3000000 AND SALARY <= 5000000  ; /*WHERE절 */



SELECT EMP_ID, EMP_NAME, SALARY , PHONE /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE SALARY BETWEEN 3000000 AND 6000000 ; /*WHERE절 */



SELECT EMP_ID, EMP_NAME, SALARY , PHONE /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE SALARY NOT BETWEEN 3000000 AND 6000000 ; /*WHERE절 */

/*
 * EMPLOYEE 테이블에서 1990-01-01에서 1999-12-31 사이인 직원의 이름과 입사일을 조회한다
 * */
SELECT EMP_NAME, HIRE_DATE  /*SELECT절 */ FROM EMPLOYEE /*FROM절 */ WHERE HIRE_DATE BETWEEN '1990-01-01' AND '1999-12-31' ; /*WHERE절 */



----------------------------------------------------------------------------------------------------------------------------------------------

-- Like

/*
LIKE : 비교하려는 값이 특정한 패턴을 만족시키면 조회하는 연산자
작성법? WHERE LIKE '패턴 적용 값';

> 패턴이 뭔데?


%: 다른 글자가 거기에 있는 조건
_: 글자의 수가 언더바 만큼 있다


예시를 암기) %의 이용

'A%': A로 시작하는 문자열

'%A': A로 끝나는 문자열

'%A%': A를 포함하는 문자열



예시를 암기) _의 이용


'A_': A로 시작하여 뒤에 무엇이 올지는 모르지만 한 글자 추가
'____A': A로 끝나는 다섯글자의 문자열
'__A_': A앞에 두글자 뒤에 한글자
'_____': 어떤 글자라도 5자의 문자열
 * */


-- ex1) EMPLOYEE 테이블에서 성이 '전'씨인 사원의 사번과 이름을 조회

SELECT EMP_ID,  EMP_NAME  
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '전%';
-- S F W A O


-- ex2) EMPLOYEE 테이블에서 전화번호가 010으로 시작하지 않는 사원의 사번과 이름과 전화번호를


SELECT EMP_ID,  EMP_NAME, PHONE
FROM EMPLOYEE 
WHERE PHONE NOT LIKE '010%';
-- S F W A O


-- ex3) EMPLOYEE 테이블에서 EMAIL에 _ 앞의 글자가 세 글자인 사원의 이름과 이메일을 조회


SELECT EMP_ID, EMAIL
FROM EMPLOYEE 
-- WHERE EMAIL LIKE '___ _%';
-- 언더바 앞에 세개를? 이러면 그냥 네개가 됨
-- ESACLPE 문자 뒤에 작성된 언더바는 일반 문자로 쓰인다는 뜻
WHERE EMAIL LIKE '___#_%' ESCAPE '#';
-- 진짜 언더바 문자를 포함하며 앞에 세 글자만 있는 조건





-- 연습문제) EMPLOYEE 테이블에서 EMAIL에 _ 앞의 글자가 네 글자 && 부서 코드가 D9나 D6이고, 입사일이 1990-01-01부터 2000-12-31일 사이 && 급여가 270만원 이상인 사원의 사번, 이름과 이메일, 급여 조회


SELECT * FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, HIRE_DATE, SALARY
FROM EMPLOYEE 
WHERE (EMAIL LIKE '____^_%' ESCAPE '^')
AND (DEPT_CODE='D9' OR DEPT_CODE ='D6') 
AND (HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-31') 
AND (SALARY>=2700000);
-- 연산자 우선순위 => and는 or보다 우선 순윅 높다! 하지만 ()를 사용하면 된다


/*
연산자의 우선순위

1위) 산술 연산자 (+-*또는 /)

2위) 연결 연산자 (||)

3위) 비교 연산자 (> < >= <= = != <>)

4위) IS NULL / IS NOT NULL + LIKE또는 IN과 NOT IN

5위) BETWEEN ... AND / NOT BETWEEN

6위) NOT(논리 연산자)
ex) SELECT EMP_NAME FROM EMPLOYEE WHERE **NOT GENDER** = '남';

7위) AND

8위) OR

*/



/*
 * > 비교 연산자 IN

비교하려는 값과 목록에 작성된 값 중 일치하는 것이 있으면 조회하는 연산자


[작성법]

WHERE 컬럼 IN (값1, 값2, 값3) ;

이는 아래 명령어와 동치이다

WHERE 컬럼 = '값1' OR 컬럼 = '값2' OR 컬럼 = '값3';
 * */

-- ex1) EMPLOYEE 테이블에서 부서코드가 D1 D6 D9인 사원의  사번, 이름, 부서코드 조회


SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE  

WHERE DEPT_CODE NOT IN ('D1','D6','D9')
OR 
(DEPT_CODE IS NULL )
;



-- 컬럼에 값 자체가 없다면 NULL 

--EMPLOYEE 테이블에서 보너스가 있는 사원의 이름과 보너스를 조회한다

SELECT EMP_NAME, BONUS FROM EMPLOYEE  
WHERE (BONUS IS NOT NULL);

/*
 * > ORDER BY절

SELECT문의 조회 결과인 RESULT SET, 즉 값들을 원하는 방식으로 정렬하기 위함
SELECT문 해석 시 가장 마지막에 해석 된다
 * */


-- EMPLOYEE 테이블에서 급여 오름차순으로 사번과 이름과 급여를 조회한다

SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY ASC;


-- EMPLOYEE 테이블에서 급여가 200만 이상인 사원의 사번, 이름, 급여를 조회한다, 단 급여 내림차순으로 조회한다

SELECT EMP_ID , EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY>=2000000  ORDER BY 3 DESC;


-- ORDER BY뒤에 컬럼의 이름을 썼지만 컬럼명 뿐 아니라 순서, 별칭이 모두 들어올 수 있다


-- ex) EMPLOYEE 테이블에서 이름과 입사일을 입사일 순서대로 조회한다

SELECT EMP_NAME 이름 , HIRE_DATE AS 입사일 FROM EMPLOYEE ORDER BY 입사일;

-- 이름 자리에 쌍따옴표가 있으면 공백이나 특수문자도 들어갈 수 있다

-- 부서코드 오름차순 정렬 후 급여를 내림차순 정렬
-- 대분류(앞조건)를 먼저 정렬한 후에 소분류 (뒷조건)를 정렬

SELECT EMP_NAME 이름 , DEPT_CODE 코드, EMPLOYEE.SALARY AS 월급 FROM EMPLOYEE ORDER BY DEPT_CODE, SALARY DESC;





















