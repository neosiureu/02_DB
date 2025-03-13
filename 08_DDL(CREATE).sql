-- DATA DICTIONARY

SELECT * FROM USER_TABLES;
SELECT * FROM USER_CONSTRAINTS  ;



/*
 * - 데이터 딕셔너리란?
 * 데이터베이스에 저장된 데이터구조, 메타데이터 정보를 포함하는 데이터베이스 객체.
  객체 중 VIEW라는 이름이 있었음. 따라서 객체의 일종

  
 * 일반적으로 데이터베이스 시스템은 데이터 딕셔너리를 사용하여 데이터베이스의 테이블, 뷰, 인덱스, 제약조건 등과 관련된 정보를 저장하고 관리함.
 
  
 * * USER_TABLES : 계정이 소유한 객체 등에 관한 정보를 조회 할 수 있는 딕셔너리 뷰
 * * USER_CONSTRAINTS : 계정이 작성한 제약조건을 확인할 수 있는 딕셔너리 뷰
 * * USER_CONS_COLUMNS : 제약조건이 걸려있는 컬럼을 확인하는 딕셔너리 뷰
 * */


/*
 ---------------------------------------------------------------------

-- DDL (DATA DEFINITION LANGUAGE) : 데이터 정의 언어
-- 객체(OBJECT)를 만들고(CREATE), 수정(ALTER)하고, 삭제(DROP) 등
-- 데이터의 전체 구조를 정의하는 언어로 주로 DB관리자, 설계자가 사용함.


-- 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE),
--        인덱스(INDEX), 사용자(USER),
--        패키지(PACKAGE), 트리거(TRIGGER)
--        프로시져(PROCEDURE), 함수(FUNCTION)
--        동의어(SYNONYM)..


----------------------------------------------------------------------


-- CREATE(생성)


-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP 구문을 통해 제거 할 수 있음
-- DROP TABLE MEMBER;


/*
 * -- 표현식
 *
 * CREATE TABLE 테이블명 (
 *    컬럼명 자료형(크기),
 *    컬럼명 자료형(크기),
 *    ...
 * );
 *
 * */


/*
 * 자료형
 *
 * NUMBER : 숫자형(정수, 실수)
 *
 * CHAR(크기) : 고정길이 문자형 (2000 BYTE) : 데이터베이스의 기본 문자 세트(UTF-8)로 인코딩
 *    --> 바이트 수 기준.
 *    --> 영어/숫자/기호 1BYTE, 한글 3BYTE
 *    --> CHAR(10) 컬럼에 'ABC' 3BYTE 문자열만 저장해도 10BYTE 저장공간 모두 사용(남은 공간 공백으로 채움 -> 낭비)
 *
 * VARCHAR2(크기) : 가변길이 문자형 (최대 4000 BYTE) : 데이터베이스의 기본 문자 세트(UTF-8)로 인코딩
 *    --> 바이트 수 기준.
 *    --> 영어/숫자/기호 1BYTE, 한글 3BYTE
 *    --> VARCHAR2(10) 컬럼에 'ABC' 3BYTE 문자열만 저장하면 나머지 7BYTE 남은 공간 반환
 *
 * NVARCHAR2(문자수) : 가변길이 문자형 (최대 4000 BYTE -> 2000글자) : UTF-16로 인코딩
 *    --> 문자길이 수 기준.
 *    --> 모든문자 2BYTE
 *    --> NVARCHAR2(10) 컬럼에 10 글자길이 아무글자(영어,숫자,한글 등) 가능
 *    --> NVARCHAR2(10) 컬럼에 '안녕'과 같은 2글자(유니코드 문자)를 입력했을 때,
 *      나머지 8개의 문자 남은 공간 반환
 *
 * DATE : 날짜 타입
 * BLOB : 대용량 이진 데이터 (4GB)
 * CLOB : 대용량 문자 데이터 (4GB)
 *
 * */


-- MEMBER 테이블을 직접 생성해보자


CREATE TABLE "MEMBER" (
	MEMBER_ID VARCHAR2(20) -- 최대6자의 한글, 최대 20자의 영어를 넣을 수 있음
, MEMBER_PWD VARCHAR2(20)
, MEMBER_NAME VARCHAR2(30)
, MEMBER_SSN CHAR(14)
, ENROLL_DATE DATE DEFAULT SYSDATE -- 값을 지정하지 않으면 이 값이 자동으로 들어감

);



-- 컬럼에 대한 COMMENT 달기

/*
 COMMENT ON COLUMN 테이블명.컬럼명 IS 주석내용
 * */


COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';

COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';

COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';

COMMENT ON COLUMN MEMBER.MEMBER_SSN IS '회원 주민등록번호';

COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일';




-- 테이블에 삽입하기






-- INSERT INTO 테이블명 VALUES(값1, 값2, ... 마지막 값)

INSERT INTO "MEMBER" MBER VALUES('MEM01','123ABC','홍길동','960830-1111222', DEFAULT );



SELECT * FROM MEMBER;

/*
INSERT/ UPDATE 시에 컬럼 값을 DEFAULT로 작성하면 테이블을 생성할 때 해당 컬럼에 지정된 디폴트 값으로 자동 생성 됨
 * */

COMMIT;


INSERT INTO "MEMBER" MBER VALUES('MEM02','JUWN111','김영희','020000-3333333', SYSDATE );

INSERT INTO "MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME) VALUES ('MEM03', '1Q2W3E', '이지연' );


/*
  > NUMBER 타입 이용 시 주의해야할 점
  
 일단 MEMBER2라는 이름의 테이블을 생성한다 (아이디, 비밀번호, 이름, 전화번호)
 * */


CREATE TABLE MEMBER2 (
MEMBER_ID VARCHAR2(20) -- 최대6자의 한글, 최대 20자의 영어를 넣을 수 있음
, MEMBER_PWD VARCHAR2(20)
, MEMBER_NAME VARCHAR2(30)
, MEMBER_TEL NUMBER
);

INSERT INTO MEMBER2 VALUES ('MEM01', 'PASS01', '고길동',01012341234);

/*
 NUMBER타입 컬럼에 데이터 삽입 시 제일 앞에 0이 있으면 이를 자동으로 제거함
=> 따라서 전화번호나 주민등록번호처럼 숫자로만 되어있는 데이터라고 해도 0으로 시작될 가능성이 조금이라도 있다면 CHAR 또는 VARCHAR2와 같은 문자열을 사용하기로 한다
 * */

SELECT * FROM MEMBER2;

COMMIT;







-- 제약조건을 포함한다

--------------------------------------------------------------

-- 제약 조건 (CONSTRAINTS)


/*
 * 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약.
 * 데이터 무결성 보장을 목적으로 함.
 *  -> 중복 데이터 X
 *
 * + 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
 * + 데이터의 수정/삭제 가능 여부 검사등을 목적으로 함.
 *    --> 제약조건을 위배하는 DML 구문은 수행할 수 없다.
 *
 *
 * 제약조건 종류
 * PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY.
 *
 *
 * */

-- 1. NOT NULL
-- 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
-- 삽입/수정 시 NULL 값을 허용하지 않도록 컬럼레벨에서 제한

-- * 컬럼레벨 : 테이블 생성 시 컬럼을 정의하는 부분에 작성하는 것


CREATE TABLE USER_USED_NN ( 
	-- 이 부분이 컬럼 레벨에 해당
	USER_NO NUMBER NOT NULL  -- 사용자 번호에 대한 컬럼 => 모든 사용자는 사용자번호가 있어야 하기 때문에
	,USER_ID VARCHAR2(20)
	,USER_PWD VARCHAR2(20)
	,USER_NAME VARCHAR2(30)
	,GENDER VARCHAR2(10)
	,PHONE VARCHAR2(30)
	,EMAIL VARCHAR2(50)
	
	-- 여기서부터는 컬럼 레벨이 아닌 테이블 레벨이라는 영역
);

INSERT INTO USER_USED_NN VALUES (
1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'HONGGD@or>kr'
);









--- 다음 제약 조건: UNIQUE

/*
 -- 2. UNIQUE 제약조건
-- 컬럼에 입력값에 대해서 중복을 제한하는 제약조건
-- 컬럼 레벨에서 설정가능, 테이블 레벨에서 설정가능
-- 단, UNIQUE 제약조건이 설정된 컬럼에 NULL 값은 중복 삽입 가능.


-- * 테이블 레벨 : 테이블 생성 시 컬럼 정의가 끝난 후 마지막에 작성


-- * 제약조건 지정 방법
-- 1) 컬럼 레벨   : [CONSTRAINT 제약조건명] 제약조건 
-- 2) 테이블 레벨 : [CONSTRAINT 제약조건명] 제약조건(컬럼명) => 사용자 제약조건 이름 지정 시

 * */


-- NULL빼고는 중복이 불가능하다

CREATE TABLE USER_USED_UK ( 
	-- 유니크 제약조건을 생성한다
	USER_NO NUMBER NOT NULL  -- 사용자 번호에 대한 컬럼 => 모든 사용자는 사용자번호가 있어야 하기 때문에
	-- USER_ID VARCHAR2(20) UNIQUE -- 컬럼레벨 => 제약조건은 알아서 지어달라는 말
	USER_ID VARCHAR2(20) CONSTRAINT USER_ID_U UNIQUE -- 컬럼레벨 => 제약조건 이름을 직접 지정하는 방식
	
	,USER_PWD VARCHAR2(20)
	,USER_NAME VARCHAR2(30)
	,GENDER VARCHAR2(10)
	,PHONE VARCHAR2(30)
	,EMAIL VARCHAR2(50),
	-- 마지막 컬럼이 끝나고 콤마가 있어야 함
	
	-- 여기서부터는 컬럼 레벨이 아닌 테이블 레벨이라는 영역
	-- 테이블 레벨
	-- UNIQUE(USER_ID) -- 테이블 레벨에서 제약조건을 쓴다 (다만 제약조건 이름은 미지정)
	CONSTRAINT USER_ID_U UNIQUE (USER_ID)
);


