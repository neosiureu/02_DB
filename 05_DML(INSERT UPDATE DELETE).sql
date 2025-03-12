/*
 
> WHAT IS DML?

데이터 조작 언어 (테이블에 값을 삽입하거나 수정하거나 삭제하는 구문)

**"주의! 혼자서 COMMIT과 ROLLBACK을 수행하면 테이블이 망가짐"**

일단 복사본 테이블을 그대로 하나씩 더 만든다

 * */

CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;

CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;


SELECT * FROM EMPLOYEE2 e ;

SELECT * FROM DEPARTMENT2 d  ;


/*
새로운 행의 추가

> WHAT IS INSERT?  

테이블에 새로운 행을 추가하는 구문

  
> CASE1: 테이블 모든 컬럼에 삽입하고 싶을 때

INSERT INTO 테이블명 VALUES (컬럼1값, 컬럼2값, 컬럼3값)
-- 반드시 컬럼 순서에 맞춰서 값을 넣도록 한다.    

> CASE2: 테이블 내 모든 컬럼에 삽입하고 싶은 것은 아닐 때

INSERT INTO 테이블명 (컬럼1, 컬럼2, 컬럼3...) VALUES (컬럼1값, 컬럼2값, 컬럼3값)
-- 반드시 컬럼 순서에 맞춰서 값을 넣도록 한다.

테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때 이를 사용한다
선택 안 된 컬럼은 값이 NULL로 들어감. 다만 
  

DEFAULT라는 값이 존재하면 해당 설정 값이 삽입 된다. 다만 복사된 EMPLOYEE2와 같은 테이블에는 디폴트 값이 없다

  
테이블명 뒤에 컬럼명이 나열되고 VALUES가 있으면? 나열된 컬럼 값
  
테이블명 뒤에 바로 VALUES가 있으면? 모든 값  
 * */


SELECT * FROM EMPLOYEE2 e ;

-- ID NAME 사번 이메일 전화번호 
-- 부서코드 직업코드, 급여레벨, 급여, 보너스, 매니저의 아이디, 입사일, 은퇴일, 은퇴여부

INSERT INTO EMPLOYEE2 VALUES('900','이주원','900800-1234567','siwooreu@or.kr', '01011112222',
'D1', 'J7','S3',4300000, 0.2, 200, SYSDATE, NULL, 'N')    
;
-- EMPLOYEE2에는 디폴트 값이 없기 때문에 강제로 'N'도 넣어야 한다

SELECT * FROM EMPLOYEE2 e WHERE EMP_ID = 900 ;


-- ROLLBACK;

INSERT INTO EMPLOYEE2 (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY )
VALUES ('900', '홍길동', '991215-1234567', 'siwoore@or.kr', '01011111111', 'D1', 'J7', 'S3', 4300000 );

SELECT * FROM EMPLOYEE2 e WHERE EMP_ID = 900 ;


COMMIT; -- 이주원 데이터 영구 저장

ROLLBACK; -- 되돌릴 수 없다. 이미 TRANSACTION의 바구니는 소용 없기 때문



CREATE TABLE EMP_01(
	EMP_ID NUMBER, EMP_NAME VARCHAR2(30), DEPT_TITLE VARCHAR2(20)
  
  );

SELECT * FROM EMP_01;


SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM EMPLOYEE2 e LEFT JOIN DEPARTMENT2 d  ON (e.DEPT_CODE  = DEPT_ID)  ;

/*
 조인을 이용해 테이블을 확장 
  
이 문의 결과가 EMP_ID, EMP_NAME, DEPT_TITLE인데 이 컬럼들이 EMP_01에 들어가겠다는 말
 * */

-- 서브 쿼리 (SELECT) 결과를 EMP_01 테이블에 INSERT
-- SELECT 조회 결과의 데이터 타입과 컬럼의 개수가 INSERT하려는 테이블의 컬럼과 반드시 일치해야 한다


INSERT INTO EMP_01(
SELECT EMP_ID, EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE2 e 
LEFT JOIN DEPARTMENT2 d  ON (e.DEPT_CODE  = DEPT_ID)  
);


SELECT * FROM EMP_01;


/*
 내용을 바꾸거나 추가해서 최신화 시킨다 => 테이블에 기록된 컬럼의 값을 수정하는 구문

> 작성법
  
  
UPDATE 테이블명
SET 컬럼 = '바꿀 것'
WHERE [컬럼 비교연산자 비교]

행의 개수는 INSERT도 DELETE도 아니므로 유지+ WHERE절은 옵션이긴 하나 핵심 (WHERE가 없으면 모든 행이 변화 됨)

 * */


-- 먼저 DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 정보를 조회한다

SELECT * FROM DEPARTMENT2 d
WHERE DEPT_ID ='D9';
--이 D9이라는 부서의 DEPT_TITLE을 '전력기획팀'이라는 이름으로 변경하는 것이 예제

UPDATE DEPARTMENT2 d SET DEPT_TITLE = '전략기획팀' 
WHERE DEPT_ID = 'D9';


SELECT * FROM DEPARTMENT2 d
WHERE DEPT_ID ='D9';


--EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의 BONUS를 0.1로 모두 변경한다
SELECT * FROM EMPLOYEE2 e ;

UPDATE EMPLOYEE2 e  SET BONUS = 0.1
WHERE BONUS IS NULL;



SELECT e.EMP_NAME, e.BONUS  FROM EMPLOYEE2 e ;


/*
 > 조건절이 없다면?
  
모든 행들이 다 UPDATE 될 듯

 * */

SELECT * FROM DEPARTMENT2 d;


UPDATE DEPARTMENT2 SET DEPT_TITLE = '기술연구팀';

SELECT * FROM DEPARTMENT2 d;

ROLLBACK;





-- > 여러 컬럼을 한 번에 수정할 시 콤마를 통해 컬럼을 구분한다

-- ID가 D9이고 TITLE이 총무부였는데 D0 전략기획팀으로 변경

UPDATE DEPARTMENT2 SET DEPT_ID = 'D0', DEPT_TITLE ='전략 기획팀' WHERE DEPT_ID='D9' AND DEPT_TITLE = '총무부';


SELECT * FROM DEPARTMENT2 d;

/*
 > UPDATE 문에서 서브 쿼리를 사용하는 경우
  
[작성법]

UPDATE 테이블명 SET 컬럼명 = (서브쿼리) 
  
ex) 방명수 사원의 급여와 보너스율을 유재식 사원과 동일하게 변경하는 방법
 * */

-- 유재식 사원의 기존 급여와 보너스 율을 미리 조회해야 한다 => 먼저 SELECT

SELECT SALARY FROM EMPLOYEE2 e WHERE e.EMP_NAME ='유재식';


SELECT BONUS FROM EMPLOYEE2 e WHERE e.EMP_NAME ='유재식';

-- 이 둘이 서브쿼리에 그대로 들어감


UPDATE EMPLOYEE2 e 
SET SALARY = (SELECT SALARY FROM EMPLOYEE2 e WHERE e.EMP_NAME ='유재식'),
 BONUS = (SELECT BONUS FROM EMPLOYEE2 e WHERE e.EMP_NAME ='유재식')
WHERE EMP_NAME = '방명수';

SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE2 e WHERE e.EMP_NAME IN ('유재식', '방명수');



-- MERGE = 병합

-- "구조가 같은" 두 테이블을 하나로 합치는 것

-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE 없으면 INSERT 됨


CREATE TABLE EMP_M01 AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02 AS SELECT * FROM EMPLOYEE WHERE JOB_CODE = 'J4' ;

SELECT * FROM EMP_M02;

--열은 똑같으므로 머지 병합은 될 듯


INSERT INTO EMP_M02 VALUES (999, '이주원', '561016-1234567','siwoooreu@or>kr','01011112222', 
'D9', 'J4', 'S1', 9000000, 0.5, NULL, SYSDATE, NULL, 'N');



UPDATE EMP_M02 SET SALARY = 0;

MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
	EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
	EMP_M01.EMP_NO = EMP_M02.EMP_NO,
	EMP_M01.EMAIL = EMP_M02.EMAIL,
	EMP_M01.PHONE = EMP_M02.PHONE,
	EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
	EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
	EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
	EMP_M01.SALARY = EMP_M02.SALARY,
	EMP_M01.BONUS = EMP_M02.BONUS,
	EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
	EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
	EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
	EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
	         EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, 	  	         EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
	         EMP_M02.ENT_DATE, EMP_M02.ENT_YN);



SELECT EMP_NAME, SALARY FROM EMP_M01;

COMMIT;

SELECT * FROM EMPLOYEE2 e WHERE EMP_NAME = '홍길동';

-- 홍길동 삭제하기 

DELETE FROM EMPLOYEE2  WHERE EMP_NAME ='홍길동';

SELECT * FROM EMPLOYEE2 e WHERE EMP_NAME = '홍길동';

ROLLBACK;


SELECT * FROM EMPLOYEE2 e WHERE EMP_NAME = '홍길동';



DELETE FROM EMPLOYEE2 WHERE EMP_ID IN (
SELECT EMP_ID
FROM EMPLOYEE2 e 
WHERE SALARY >=3000000
);

SELECT * FROM EMPLOYEE2 e;


ROLLBACK;



/*
 이건 여기에 들어올 것이 아님 DML에 해당되지 않음. 사실 DDL에 해당. (CREATE DROP ALT 등을 다룰 때 써야 함)
  
![](https://velog.velcdn.com/images/neosiureu/post/3fd5ca02-5262-468d-986e-e83e0fd53984/image.png)

ROLLBACK을 통해 복구가 가능한 것은 사실 DML 뿐. 따라서 TRUNCATE는 실행하면 영구적으로 변화할 수 없음.
  
테이블의 전체 행을 삭제하는 DDL에 해당한다 => DELETE에 비해 수행 속도는 빠르다.
  
일단 역시 테이블 생성
  
 * */

CREATE TABLE EMPLOYEE3 AS SELECT * FROM EMPLOYEE2;

SELECT * FROM EMPLOYEE3;

-- TRUNCATE로 삭제한다

TRUNCATE TABLE EMPLOYEE3;


SELECT * FROM EMPLOYEE3;



--LAST