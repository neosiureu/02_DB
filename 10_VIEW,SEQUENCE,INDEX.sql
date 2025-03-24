/* VIEW
실제로 값은 없지만 테이블 형식을 띄고 있는 객체

목적) 

1) 쿼리의 재사용
2) 값의 숨김

<BR><BR><BR>

----------------------------------------------------------------------------  
VIEW
 
정의:   논리적 가상 테이블

-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
  
  - SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
 
  
 * ** VIEW 사용 목적 **
   1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
   2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리 (진짜 테이블 주소를 숨긴다)
 
 * ** VIEW 사용 시 주의 사항 **
 1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문 사용 불가.
 2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만 제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.

  
 *  ** VIEW 작성법 **
  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
  AS 서브쿼리(SELECT문) => (복잡한 SELECT문을 쉽게 재사용하기 위해)
  [WITH CHECK OPTION]
  [WITH READ OLNY];
 <BR> <BR> <BR>
1) OR REPLACE 옵션 : 
  기존에 동일한 이름의 VIEW가 존재하면 이를 변경
  없으면 새로 생성
 <BR> <BR> <BR> 
2) FORCE | NOFORCE 옵션 : 
  FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
  NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
  <BR> <BR> <BR>
3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정
  <BR> <BR> <BR> 
4) WITH CHECK OPTION 옵션 : 
  옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
  <BR> <BR> <BR> 
5) WITH READ OLNY 옵션 :
  뷰에 대해 SELECT만 가능하도록 지정.** 반필수 (DML을 하지 않도록 하기 위해)**

 ----------------------------------------------------------------------------  
BUT 권한이 없이 만들 수 없음 
 * */





ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; -- 이상한 접두사 생략 가능하게 하는 문

-- 계정명이 혹시 언급된다면 이 구문이 미리 들어가야

GRANT CREATE VIEW TO kh; -- 이 마지막 kh때문에 ALTER SESSION 필수



CREATE VIEW V_EMP AS SELECT * FROM EMPLOYEE;


SELECT * FROM V_EMP;



-- 사번과 이름과 부서명과 직급명을 조회하기 위한 VIEW

CREATE OR REPLACE VIEW V_EMP AS 
SELECT EMP_ID 사번, EMP_NAME 이름, NVL(DEPT_TITLE, '없음') 부서명, JOB_NAME 직급명 
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE) 
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
ORDER BY 사번;


SELECT * FROM V_EMP;


-- V_EMP에서 대리 직원들을 이름 오름차순으로 조회한다 => 컬럼명들을 어떻게 해야 하나?

SELECT * FROM V_EMP 
WHERE 직급명 = '대리'  
ORDER BY 이름
; --반드시 별칭의 형태로 써야 한다. 기존 테이블 원래 이름은 볼 수 없기 때문

-- VIEW 조회 결과로 보이는 컬럼명, 여기서는 별칭 설정한 것을 이름으로 사용해야 오류가 안 남

-------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
 VIEW를 이용하여 DML을 사용하되 왜 이러면 안되는지 알아보자
 * */


-- DEPT_COPY2라는 테이블 생성 (뷰 말고 진짜 테이블)

CREATE TABLE DEPT_COPY2 
AS SELECT * FROM DEPARTMENT;


--복사한 테이블에서 DEPT_ID와 LOCATION_ID라는 컬럼만 이용하여 V_DCOPY2라는 VIEW를 여기서 생성한다



CREATE OR REPLACE VIEW V_DECOPY2 
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2 ;


SELECT * FROM DEPT_COPY2; --테이블은 3열
SELECT * FROM V_DECOPY2; --뷰는 2열


INSERT INTO V_DECOPY2 VALUES ('D0', 'L2');




SELECT * FROM V_DECOPY2;--뷰는 2열인데 D0가 추가

SELECT * FROM DEPT_COPY2; --틀림없이 INSERT한 것은 VIEW에 해당하는 V_DECOPY2인데 ?
-- VIEW 생성 시 사용한 원본 테이블에 값이 함께 INSERT된다는 것을 확인




CREATE OR REPLACE VIEW V_DECOPY2 
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2 WITH READ ONLY ;


--INSERT INTO V_DECOPY2 VALUES ('D0', 'L3');


-----------------------


/*
 
SEQUENCE(순서, 연속)
> 순차적으로 일정한 간격의 숫자(번호)를 발생시키는 객체
  = 번호 생성기 
 
> WHY SEQUENCE? 
  
  PRIMARY KEY(기본키) : 테이블 내 각 행을 구별하는 식별자 역할
				 NOT NULL + UNIQUE의 의미를 가짐
 
 * **PK가 지정된 컬럼에 삽입될 값을 생성할 때 SEQUENCE를 이용**하면 좋다!
 
> HOW TO SEQUENCE?
  
  뼈대는 CREATE SEQUENCE 이름 => 옵션 6개중에 쓰면 됨
  
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] (처음 발생시킬 시작값 지정, 생략하면 1이 기본)
  
  [INCREMENT BY 숫자] (다음 값에 대한 증가치, 생략하면 1이 기본)
  
  [MAXVALUE 숫자 | NOMAXVALUE] 발생시킬 최대값 지정, 생략하면 기본값은 굉장히 큰 값 / NOMAXVALUE를 사용하면 최대값 제한이 없음을 의미  (NO가 디폴트)
  
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 , 기본값은 -10^26 /  NOMINVALUE를 사용하면 최소값 제한이 없음을 의미 (NO가 디폴트)
  
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정 , 기본값은 NOCYCLE
		-- CYCLE: 값이 최대값에 도달하면 다시 최소값부터 순환 (최대를 10으로 설정했으면 123456789123456789....)
		-- NOCYCLE: 값을 순환하지 않고, 최대값에 도달하면 오류를 발생시킴
  
  [CACHE 시퀀스개수 | NOCACHE] -- 기본값은 20
	-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	--> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	--  매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.

> 이 위까지는 시퀀스 생성
  
 * ** 사용법 **
 
1) 시퀀스명.NEXTVAL : **다음 시퀀스 번호**를 얻어옴.
  (INCREMENT BY 만큼 증가된 수)
 단, 생성 후 처음 호출된 시퀀스인 경우
 START WITH에 작성된 값이 반환됨.

** 만들자마자 이거부터 해야 한다
**  
  
2) 시퀀스명.CURRVAL : **현재 시퀀스 번호**를 얻어옴.
 단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생.
== 마지막으로 호출한 NEXTVAL 값을 반환
 * */





-- 시퀀스를 생성한다


CREATE SEQUENCE SEQ_TEST_NO
START WITH 100 --시작
INCREMENT BY 5 -- 증감 (NEXTVAL이 호출될 시 )
MAXVALUE 150 --최대
NOMINVALUE -- 최소값은 미지정
NOCYCLE -- CIRCULAR 연산은 하지 않음
NOCACHE -- 미리 만들어둘 시퀀스 번호는 없다. 그 때 그 때 생성해서 반환
;




-- 시퀀스를 없앤다

DROP SEQUENCE SEQ_TEST_NO;



-- 시퀀스는 다른 객체 내에서 사용하게 됨. 따라서 테이블 하나를 만들기로 함

CREATE TABLE TB_TEST(
	TEST_NO NUMBER PRIMARY KEY
	,TEST_NAME VARCHAR2(30) NOT NULL
);

SELECT SEQ_TEST_NO.CURRVAL FROM DUAL; 


--시퀀스 SEQ_TEST_NO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다

-- CURRAVAL의 정확한 의미는 현재 시퀀스 값이 아니다!
-- 가장 최근 호출된 NEXTVAL을 반환해야 하는데 그를 호출한적이 없어 오류가 발생하는 것!


-- 따라서 일단 NEXTVAL부터 호출해보자


SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;

SELECT SEQ_TEST_NO.CURRVAL FROM DUAL; 

-- 가장 최근에 NEXTVAL로 100이 호출되었기 때문에 CURRVAL의 출력 결과는 100


--이제 NEXTVAL을 호출할 때마다 INCREMENT BY에 작성된 수만큼 증가하는지 확인해보자  

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
/*
 처음에는 100
 1회는 105
 2회는 110...
 과 같이 5씩 증가
 * */

--단순 SELECT 말고 TV_TEST테이블에서 EMP_ID, 즉 PK값에 대해 싴눤스 값을 넣어서 INSERT하는 문제 

INSERT INTO TB_TEST VALUES (SEQ_TEST_NO.NEXTVAL, '짱구'); 
INSERT INTO TB_TEST VALUES (SEQ_TEST_NO.NEXTVAL, '철수'); 
INSERT INTO TB_TEST VALUES (SEQ_TEST_NO.NEXTVAL, '유리');

SELECT SEQ_TEST_NO.CURRVAL FROM DUAL;


UPDATE TB_TEST SET TEST_NO = SEQ_TEST_NO.NEXTVAL WHERE TEST_NAME = '짱구';
SELECT * FROM TB_TEST ;


ALTER SEQUENCE SEQ_TEST_NO
MAXVALUE 200;



SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;




/*
 INDEX(색인)

- SQL 구문 중 SELECT 처리 속도를 향상 시키기 위해 * 컬럼에 대하여 생성하는 객체


- 인덱스 내부 구조는 B* 트리(B-star tree) 형식으로 되어있음.


INDEX의 장점

이진 트리 형식으로 구성되어 자동 정렬 및 검색 속도 증가.
조회 시 테이블의 전체 내용을 확인하며 조회하는 것이 아닌 인덱스가 지정된 컬럼만을 이용해서 조회하기 때문에 시스템의 부하가 낮아짐.


INDEX의 단점

데이터 변경(INSERT,UPDATE,DELETE) 작업 시 이진 트리 구조에 변형이 일어남
DML 작업이 빈번한 경우 시스템 부하가 늘어 성능이 저하됨.
인덱스도 하나의 객체이다 보니 별도 저장공간이 필요(메모리 소비).
인덱스 생성 시간이 필요함.


[작성법]

CREATE [UNIQUE] INDEX 인덱스명
ON 테이블명 (컬럼명[, 컬럼명 | 함수명]);
DROP INDEX 인덱스명;

인덱스가 자동 생성되는 경우

PK ,FK, UNIQUE 제약조건이 설정된 컬럼에 대해 UNIQUE INDEX가 자동 생성된다.

PK에 자동 생성되는 이유 : 기본 키는 중복을 허용하지 않고, NOT NULL이어야 하기 때문이다.

UNIQUE 제약조건 설정 컬럼에서 자동생성 되는 이유 : 중복을 허용하지 않는 고유 값을 보장해야하기 때문이다.
 * */


SELECT ROWID, EMP_ID, EMP_NAME FROM EMPLOYEE;

--오라클에서 각 행의 고유한 주소를 나타내는 가상 컬럼 (물리적 주소)
-- 인덱스가 ROWID를 저장 => 인덱스 = 컬럼 값 + 해당행의 ROWID를 연결시켜 저장
-- 컬럼 값을 통해 해당 행의 ROWID를 빠르게 찾아낼 수 있다

-- 인덱스가 생성된 장소를 찾아볼 수 있는 명령어

-- 가령 딕셔너리 뷰

SELECT INDEX_NAME, TABLE_NAME, UNIQUENESS, STATUS FROM USER_INDEXES;


-- 인위적으로 만드는 인덱스
-- EMPLOYEE 테이블의 EMP_NAME 컬럼에 인덱스를 생성

CREATE INDEX IDX_EMP_NAME ON EMPLOYEE (EMP_NAME);


-- 지금부터는 EMPLYOEE테이블의 EMP_NAME컬럼에 대해 빠른 검색이 가능

/*
 인데스명: IDX_EMP_NAME 
 테이블명: EMPLOYEE
 컬럼명: EMP_NAME
 목적: EMP_NAME을 이용한 컬럼 검색 속도 향상

 * */



-- EMPLOYEE 테이블의 EMAIL 컬럼에 UNIQUE INDEX를 생성

CREATE UNIQUE INDEX IDX_UNIQUE_EMAIL ON EMPLOYEE (EMAIL);


-- 유니크 인덱스의 특징: 중복 방지


-----------------------------------------------------------------------------------------------------------------------------------------------


-- 인덱스 성능 확인용 테이블의 생성


CREATE TABLE TB_IDX_TEST (
	TEST_NO NUMBER PRIMARY KEY, -- 자동으로 유니크 인덱스로 생성
	TEST_ID VARCHAR2(20) NOT NULL
);


-- 총 백만개의 샘플 데이터를 삽입한다


-- TB_IDX_TEST테이블에 100만개의 데이터를 삽입하기 위해

-- PL/SQL이라는 것을 사용한다


-- 오라클 데이터베이스에서 사용하는 절차적 확장 언어

-- 데이터베이스인데도 변수, 조건문 (IF/ CASE), 반복문 (LOOP/ WHILE)이 모두 가능하다 => 논리적 흐름 제어가 필요할 때 이러한 문법을 사용한다












-- PL/SQL아 100만번 INSERT 해줘


BEGIN
	FOR I IN 1..1000000 -- 1부터 100만까지 I변수가 반복된다.
	
	LOOP
		INSERT INTO TB_IDX_TEST
		VALUES (I, 'TEST' || I );  -- 1부터 TEST1 2에는 TEST2 .... 백만에는 TEST1000000와 같이 표시하기 위함
	END LOOP;
	COMMIT; -- 삽입 작업이 길기 때문에 커밋하는 편이 나음
END;

SELECT COUNT(*) FROM TB_IDX_TEST;


-- 인덱스를 이용한 검색

-- WHERE절에 INDEX가 적용된 컬럼을 언급

/*
 인덱스 사용 안할 시 TEST_ID가 'TEST500000'인 행을 조회한다
 인덱스가 있는 것은 TEST_NO NUMBER PRIMARY KEY이지 TEST_ID는 아님 
 => TEST_NO가 500000인 행을 조회하면 실제로 성능상 빠른 효과를 볼 수 있다
 
 * */



SELECT * FROM TB_IDX_TEST WHERE TEST_ID = 'TEST500000';

SELECT * FROM TB_IDX_TEST WHERE TEST_NO = 500000;

COMMIT;
-- LAST
