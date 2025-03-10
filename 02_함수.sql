/*
 * >함수란?

컬럼의 값을 읽어 연산을 한 결과를 반환한다

> 단일행

N개의 값이 들어오면 리턴 역시 N개 => 각 행마다 반복적으로 실행되기 때문에 단일행이라는 이름

> 그룹

N개의 값이 들어오면 리턴이 1개 => 그룹 전체 행에 모든 행에 대해 한 값만 나오기 때문 (합계, 평균, 최대, 최소)
 * */

-- 함수는 SELECT문 중 SELECT절 WHERE절 ORDERBY절 뿐 아니라 곧 배울 GROUPBY절, HAVAING절에서 사용하곤 한다.

-- 단일 행 함수의 예시


-- LENGTH(컬럼명 | 문자열): 컬럼의 길이나 문자열의 길이를 반환한다

SELECT EMAIL, LENGTH ('가나다라마바사') "모든 행에 대해서 저 숫자를 전달" FROM EMPLOYEE ;

/*
 * > INSTR

INSTR (컬럼이나 문자이름, '찾을 문자열')
INSTR (컬럼이나 문자이름, '찾을 문자열' [, 시작 위치] [, 순번] ) => 생략 가능

지정한 위치부터 지정한 순번째로 검색되는 문자의 위치를 반환한다
 * */

-- AABAACAABBAA라는 임의의 문자열을 만들었다 => 문자열을 앞에서부터 검색하여 처음 나오는 B의 위치를 반환하는 함수

SELECT INSTR('AABAACAABBAA','BBA') FROM DUAL;
-- 디폴트는 첫 번째 나오는 문자열을 조회


-- AABAACAABBAA라는 임의의 문자열을 만들었다 => 문자열을 앞에서부터 5번째부터 검색하여 처음 나오는 B의 위치를 반환하는 함수


SELECT INSTR('AABAACAABBAA','B',5) FROM DUAL;

SELECT INSTR('AABAACAABBAA','B' ,5,2) FROM DUAL;


-- 연습문제) EMPLOYEE 테이블에서 사원명, 이메일, 이메일중에서@의 위치를 조회

SELECT EMP_NAME, EMAIL, INSTR (EMAIL, '@') FROM EMPLOYEE;


-- 지금까지 LENGTH INSTR

/*
 SUBSTR('문자열'또는 '컬럼명', 잘라내기 시작할 위치) 
 SUBSTR('문자열'또는 '컬럼명', 잘라내기 시작할 위치 [, 잘라낼 길이]) 
 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라내어 반환
 옵션에 해당하는 잘라낼 길이 생략 시 끝까지 잘라낸다

*/

-- EMPLOYEE 테이블에서 사원명, 이메일 중 앞에 있는 아이디 부분 (@앞)만 조회

SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) FROM EMPLOYEE ;
-- 문자의 위치를 반환하는 INSRT


/*
 > TRIM류

주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
(주로 문자열의 앞뒤 공백을 제거하는 용도)

TRIM ( [ [옵션], '문자열'또는 컬럼명 FROM ] **'문자열'또는 '컬럼명 **)

[옵션] 부분에 들어갈 수 있는 것:

BOTH (양쪽), LEADING (앞쪽), TRAILING(뒤쪽)

   
 * */


SELECT TRIM('     H E LL      O    ') FROM DUAL;

SELECT TRIM(BOTH  '#' FROM '####안녕####') FROM DUAL;
SELECT TRIM(LEADING  '#' FROM '####안녕####') FROM DUAL;
SELECT TRIM(TRAILING  '#' FROM '####안녕####') FROM DUAL;




SELECT ABS(10) 양수10의ABS함수 , ABS(-10) 음수10의ABS함수 FROM DUAL;
SELECT '절댓값 같음' FROM DUAL WHERE ABS(10) = ABS(-10)  ;

-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 때 각 행의 나머지를 조회한다

SELECT EMP_NAME, SALARY, MOD(EMPLOYEE.SALARY, 1000000 ) FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번과 이름을 조회


SELECT EMP_ID, EMP_NAME  FROM EMPLOYEE WHERE MOD(EMP_ID,2)=0 ;


SELECT EMP_ID, EMP_NAME  FROM EMPLOYEE WHERE NOT MOD(EMP_ID,2)=0 ;
SELECT EMP_ID, EMP_NAME  FROM EMPLOYEE WHERE MOD(EMP_ID,2)!=0 ;
SELECT EMP_ID, EMP_NAME  FROM EMPLOYEE WHERE MOD(EMP_ID,2) <> 0 ;

/* ROUND (숫자 | 컬럼명 [,소수점 위치]) : 반올림 
*/

SELECT ROUND(123.456) FROM DUAL;
-- 디폴트는 소수점 아래를 잘라낸다
SELECT ROUND(123.456,1) FROM DUAL;
-- 옵션이 있으면 해당 자릿수의 소수점만큼만 표기한다
SELECT ROUND(123.456,-1) FROM DUAL;
-- 

SELECT CEIL (123.1), FLOOR(123.9) FROM DUAL;
-- 무조건 소수점 첫째 자리에서만 올리거나 내릴 수 있다

-- TRUNC (숫자| 컬럼 [,위치]):  특정 위치 아래를 절삭

SELECT TRUNC(123.456) FROM DUAL;
-- 소수점 아래를 전부 절삭

SELECT TRUNC(123.456,1) FROM DUAL;
-- 소수점 아래 한자리수만 남기고 다 절삭

SELECT TRUNC(123.456,-1) FROM DUAL;
-- 소수점 위 한자리수는 그냥 0으로 취급 (십의자리 아래를 전부 절삭)




-- 시스템 상의 현재 시간을 나타내는 SYSDATE => 연월일 시분초가 전부 반환

SELECT SYSDATE FROM DUAL;
SELECT SYSTIMESTAMP FROM DUAL;


/*
 > MONTHS_BETEWEEN (날짜, 날짜)

두 날짜의 개월 수 차이를 반환
 */


SELECT ABS(ROUND( MONTHS_BETWEEN (SYSDATE, '2025-07-22'),3)) "종강까지 남은 시간" FROM DUAL;



/*
 
 
 > ADD_MONTH (날짜, 숫자) : 날짜에 숫자인자만큼의 개월수를 더한다 (음수도 가능)

 * */


-- ex) 사원의 이름, 입사일, 근무 개월수, 근무년차


SELECT EMP_NAME, HIRE_DATE, 
CEIL( MONTHS_BETWEEN(SYSDATE,EMPLOYEE.HIRE_DATE))  "근무한 개월 수" , 
CEIL( MONTHS_BETWEEN(SYSDATE,EMPLOYEE.HIRE_DATE)/12) ||'년차'  "근무 년차" FROM EMPLOYEE; 

SELECT ADD_MONTHS(SYSDATE,4) FROM DUAL;

-- LAST_DAY(날짜): 해당 달의 마지막 날짜를 반환

SELECT LAST_DAY(SYSDATE) FROM DUAL;

SELECT LAST_DAY('2020-02-01') FROM DUAL;


-- > EXTRACT (YEAR/ MONTH/ DAY FROM 날짜): 연 월 일 정보를 추출하여 반환


-- ex) EMPLOYEE 테이블에서 각 사원의 이름, 입사일 년도, 월, 일을 조회

SELECT EXTRACT(YEAR FROM EMPLOYEE.HIRE_DATE)  || 
'년' AS 입사년도  ,EXTRACT(MONTH FROM EMPLOYEE.HIRE_DATE) || 
'월' AS 입사월  ,EXTRACT(DAY FROM EMPLOYEE.HIRE_DATE) || 
'일'  AS 입사일 
FROM EMPLOYEE; 


SELECT EXTRACT(YEAR FROM EMPLOYEE.HIRE_DATE)  || 
'년' AS 입사년도  ,EXTRACT(MONTH FROM EMPLOYEE.HIRE_DATE) || 
'월' AS 입사월  ,EXTRACT(DAY FROM EMPLOYEE.HIRE_DATE) || 
'일'  AS 입사일 
FROM EMPLOYEE; 




SELECT TO_CHAR(1234, '99999') FROM DUAL;
SELECT TO_CHAR(1234, '00000') FROM DUAL;
SELECT TO_CHAR(1234) FROM DUAL;



SELECT TO_CHAR(1000000) ;



SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL; 
SELECT TO_CHAR(1000000, 'L9,999,999') || '원' FROM DUAL; 


-- 형변환 함수

-- 문자열과 숫자, 날짜 함수끼리 형변환이 가능하다


/*
 날짜를 문자열로 변환한다 => TO_CHAR(날짜, [포맷])

[포맷]에 들어갈 수 있는 것

YYYY: 년도
YY: 년도 (짧게)
MM: 월
DD: 일
AM / PM: 오전 오후
HH: 시간
HH24: 24시간 표기법
MI: 분
SS: 초
DAY: 요일 (전체 - 가령 "월요일")
DY: 요일 (일부- 가령 "월")

 
 */


-- 2025/3/10/ 12:45:35 월요일

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL;


-- 2025년 3월 10일 (월)이라고 띄운다

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') || '일 ' || TO_CHAR(SYSDATE, '(DY)') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM "월" /DD "일" (DY)')  FROM DUAL;



/*
 *
TO_DATE(문자형 데이터[, 포맷]) : 문자형 -> 날짜로 변경
TO_DATE(숫자형 데이터[, 포맷]) : 숫자형 -> 날짜로 변경

이 결과 지정된 포맷대로 날짜를 인식함

 */

SELECT TO_DATE('2025-03-10') FROM DUAL; 
-- 이제부터 저 문자는 DATE 타입

SELECT TO_DATE(20250310) FROM DUAL; 
-- 이제부터 저 숫자는 DATE 타입

SELECT TO_DATE('250310 140730', 'YYMMDD HH24MISS ' ) FROM DUAL; 

-- => 패턴을 적용하여 작성된 문자열의 각 문자가 어떤 날짜 포맷으로 사용한 것인지 인식시킬 필요가 있다.

-- Y패턴: 현재 세기 (21세기 == 20XX년, 즉 2000년대)
-- R패턴: 한 세기를 기준으로 50년 이상인 경우 이전 세기 (1900년대)를 나타 냄, 반면 절반 미만인 경우 현재 세기인 2000년대를 나타 냄

SELECT TO_DATE('800505', 'YYMMDD') FROM DUAL; --2080-05-05 00:00:00.000
SELECT TO_DATE('800505', 'RRMMDD') FROM DUAL; --1980-05-05 00:00:00.000
-- 80이 50보다 크기 때문에 1900년대로 표시
SELECT TO_DATE('490505', 'RRMMDD') FROM DUAL; --2049-05-05 00:00:00.000
--  49가 50보다 작기 때문에 2000년대로 표시


-- > 연습문제 EMPLOYEE 테이블에서 각 직원이 태어난 생년월일을 모두 조회하여 사원이름과 생년월일 순서로 출력하라

SELECT e.EMP_NAME ,  SUBSTR(e.EMP_NO, 1, INSTR(e.EMP_NO ,'-')-1 ) AS 생년월일  FROM EMPLOYEE e;

-- 1단계: 주민번호에서 대쉬 앞 글자까지 추출 (대쉬 바로 앞까지만 잘라내어 1부터 해당 위치까지 SUBSTR 한다)

SELECT e.EMP_NAME , TO_DATE (SUBSTR(e.EMP_NO, 1, INSTR(e.EMP_NO ,'-')-1 ), 'RRMMDD') AS 생년월일  FROM EMPLOYEE e;

-- 2단계: 추출한 생년월일을 VARCHAR2에서 DATE타입으로 변경 -> Y는 무조건 2000년대이므로 R패턴을 사용하여 1900년도로 변환한다.


SELECT e.EMP_NAME , 
TO_CHAR(TO_DATE (SUBSTR(e.EMP_NO, 1, INSTR(e.EMP_NO ,'-')-1 ), 'RRMMDD'),'YYYY"년" MM"월" DD"일" ') AS 생년월일  FROM EMPLOYEE e;

-- 3단계: 이 날짜를 원하는 형식의 문자열로 변경하기 위해 TOCHAR 사용. 가령 1962년 12월 31일과 같이 나오도록


SELECT '1,000,000' + 500000 FROM DUAL;



SELECT TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL;
-- 숫자 자릿수를 9라는 포맷을 통해 백만이 숫자라는 것을 알려주고 그 숫자에 오십만을 더한 값이





-- NULL처리 함수

-- NVL (컬럼명, 컬럼값이 NULL일 때 바꿀 값): NULL인 컬럼 값을 다른 값으로 변경

SELECT BONUS FROM EMPLOYEE e ;

SELECT EMP_NAME, SALARY, NVL(BONUS,0),  NVL (e.SALARY *BONUS,0 )
FROM EMPLOYEE e  ;

/*
 > NVL의 또 다른 형태

NVL (컬럼명, 바꿀 값1, 바꿀 값2) => 일종의 삼항 연산자
해당 컬럼의 값이 있으면 바꿀값1로 변경, 해당 컬럼의 값이 NULL이면 바꿀값 2로 변경
 * */

-- EMPLOYEE 테이블에서 보너스를 받으면 O 안 받으면 X


SELECT EMP_NAME, NVL2(BONUS, 'O','X') "보너스 수령" FROM EMPLOYEE e ;



/*
 DECODE(계산식 / 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2, .. ,디폴트)

디폴트의 경우 아무것도 일치하지 않을 때

비교하고자하는 값 또는 컬럼이 조건식과 같다면 해당 선택값을 반환하는 함수
 * */

-- 직원의 성별을 구한다

SELECT EMP_NO FROM EMPLOYEE e ; -- 621231-1985634

-- DECODE의 첫 식은 값이 나와야

SELECT EMPLOYEE.EMP_NAME,  DECODE(SUBSTR(EMP_NO,8,1),'1', '남성', '2', '여성') "성별" FROM EMPLOYEE ;


/* 직원의 급여를 인상하려고 한다
직급 코드가 J7인 직원은 20퍼센트 인상
직급 코드가 J6인 직원은 15퍼센트 인상
직급 코드가 J5인 직원은 10퍼센트 인상
그 외 직급은 5퍼센트 인상

이름, 직급코드, 급여, 인상률, 인상된 급여를 조회한다

*/


SELECT e.EMP_NAME ,  e.JOB_CODE, e.SALARY, DECODE(e.JOB_CODE , 'J7', '20%', 'J6','15%', 'J5', '10%', '5%' ) 인상률, 
DECODE('인상률' , '20%',  e.SALARY*1.2  ,'15%', e.SALARY*1.15 , '10%', e.SALARY*1.1, '5%', e.SALARY*1.05 ) "인상된 급여"
 
-- DECODE(e.JOB_CODE  , 'J7',  e.SALARY*1.2  ,'J6', e.SALARY*1.15 , 'J5', e.SALARY*1.1,  e.SALARY*1.05 ) "인상된 급여"
FROM EMPLOYEE e;




/*
 > CASE WHEN (조건식 THEN 결과값) (ELSE 결과값) END

비교 하고자하는 값이나 컬럼이 조건식과 같으면 결과 값을 반환한다. 이 때 조건은 범위 값도 가능하다


ex) 급여가 500만원 이상이면 '대', 300만원 이상인데 500만원 미만이면 '중', 급여가 300만원 미만이라면 '소'로 조회하겠다

사원이름, 급여, 급여받는정도(대중소)를 출력하라

 * */

SELECT e.EMP_NAME, SALARY, 
CASE WHEN e.SALARY >= 5000000 THEN '대'
WHEN e.SALARY >= 3000000 THEN '중'
ELSE '소'
END "급여 받는 정도"
FROM EMPLOYEE e;







-- 그룹함수--


/*

정의: 하나 이상의 행을 그룹으로 묶어 연산하여 총합이나 평균 등의 하나의 결과 행으로 반환하는 함수
SUM (숫자가 기록된 컬럼 이름): 합계

모든 직원의 급여 합을 조회한다
*/

SELECT SUM(SALARY) FROM EMPLOYEE e;

SELECT ROUND(AVG(SALARY),-2) FROM EMPLOYEE e;


SELECT SUM(SALARY), ROUND (AVG(SALARY)) FROM EMPLOYEE e  WHERE DEPT_CODE = 'D9';

-- 직원테이블에서 부서코드가 D9인 사원을 먼저 추린다 그들 중에 급여 합계와 평균 값을 조회한다

-- ex) 급여의 최소값, 가장 빠른 입사일, 알파벳순서가 가장 빠른 이메일을 조회


SELECT MIN(e.SALARY), MIN(e.HIRE_DATE ), MIN(e.EMAIL), MIN(e.EMP_NAME)  FROM EMPLOYEE e  ;

SELECT MAX(e.SALARY), MAX(e.HIRE_DATE ), MAX(e.EMAIL), MAX(e.EMP_NAME)  FROM EMPLOYEE e  ;



SELECT  e.EMP_NAME, e.SALARY, e.JOB_CODE  FROM EMPLOYEE e WHERE e.SALARY =( SELECT MAX(e.SALARY)  FROM EMPLOYEE e  )  ;



/*
 COUNT(컬럼명): NULL을 제외한 실제 값이 기록 된 행의 개수를 세서 반환.

COUNT(*): NULL을 포함한 전체 행의 개수를 세서 반환.

COUNT([DISTINCT]컬럼명): 중복을 제외한 행의 개수를 반환.

 
 * */

SELECT COUNT(e.BONUS) FROM EMPLOYEE e ;


SELECT COUNT(e.JOB_CODE) FROM EMPLOYEE e 



-- LAST
