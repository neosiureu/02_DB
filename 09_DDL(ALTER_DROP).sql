-- DDL(Data Definition Language)
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP) 하는 데이터 정의 언어


/*
 * ALTER(바꾸다, 수정하다, 변조하다)
 * 
 * -- 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제)
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름변경 (테이블명, 컬럼명..)
 * 
 * 
 * */


-- 1) 제약조건(추가/삭제)-- 

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
--			ADD [CONSTRAINT 제약조건명] 제약조건(지정할컬럼명)
--			[REFERENCES 테이블명[(컬럼명)]]; <-- FK 인 경우 추가








-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음!
--> 삭제 후 추가를 해야함.




CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;

/*복사해서 테이블을 생성하는 경우 컬럼이름, 데이터의 타입, NOTNULL인 제약조건은 복사가 되지만 나머지는 기존것에서 복사되지 않는다   */



SELECT * FROM DEPT_COPY;

-- 기존 DEPY_COPY 테이블 DEPT_TITLE컬럼에 유니크를 추가

ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_TITLE_U  UNIQUE(DEPT_TITLE);




-- DEPT_COPY의 DEPT_TITLE컬럼에서 UNIQUE 제약 재삭제


ALTER TABLE DEPT_COPY 
DROP CONSTRAINT DEPT_COPY_TITLE_U;

-- 이름의 제약조건을 삭제학 싶다면 제약조건명을 직접 찾아 써야한다!

-- 다음으로 DEPT_COPY의 DEPT_TITLE컬럼에 NOT NULL제약조건을 추가하거나 삭제할 수 있다?



-- ALTER TABLE DEPT_COPY  ADD CONSTRAINT DEPT_COPY_TITLE_NOTNULL NOT NULL (DEPT_TITLE);


ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NOT NULL ;

-- 컬럼 DEPT_TITLE에 NOTNULL 적용


ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL ;


--------------------------------------------------------------------------------


-- 2. 컬럼(추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);


-- 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --> 데이터 타입 변경

-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; --> DEFAULT 값 변경


-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (삭제할컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

--------------------------------------------------------------------------------



-- CNAME컬럼 추가


ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(30));

SELECT * FROM DEPT_COPY;
-- 새로 추가한 컬럼에 있는 값은 NULL


ALTER TABLE DEPT_COPY ADD (LNAME VARCHAR2(30) DEFAULT '한국' );
SELECT * FROM DEPT_COPY;
-- 새로 추가한 컬럼에 있는 값은 디폴트


-- D10 개발1팀을 추가하자 => DML 중 INSERT INTO를 추가

INSERT INTO DEPT_COPY VALUES ('D10','개발1팀','L1',NULL, DEFAULT);

-- "KH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)

-- DEPT_ID의 데이터 타입이 CHAR(2)이므로 영어와 숫자를 합쳐 두 글자까지 저장이 가능하다 

-- => D10은 3바이트이므로 당연히 오류

-- 데이터의 타입을 VARCHAR2(3)으로 변경 (남는 데이터 메모리를 반환하는 가변형 변수)


-- DEPT_ID 컬럼의 데이터 타입을 수정하는 방법 => ALTER TABLE 이름 MODIFY 컬럼 타입


ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);


INSERT INTO DEPT_COPY VALUES ('D10','개발1팀','L1',NULL, DEFAULT);



SELECT * FROM DEPT_COPY;




/*
 > 디폴트 값 역시 같은 방식으로 변경 가능  
  

ALTER TABLE 이름 MODIFY 컬럼 타입
  
디폴트 L_NAME컬럼의 값을 한국 대신 KOR로  
 **/

ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';

SELECT * FROM DEPT_COPY;

-- 기본 값을 변경했다고 해서 기존 데이터가 변하지는 않는다 => 앞으로 INSERT에서만 
-- UPDATE를 쓰면 모든 값을 변경할 수 있음

UPDATE DEPT_COPY SET LNAME = DEFAULT WHERE LNAME='한국';



-- 모든 컬럼을 삭제 => ALTER TABLE 이름 DROP (컬럼) 


ALTER TABLE DEPT_COPY DROP (LNAME); 

ALTER TABLE DEPT_COPY DROP COLUMN CNAME; 

ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID; 

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE; 

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID; 


DROP TABLE DEPT_COPY ;


SELECT * FROM DEPT_COPY;

-- DEPARTMENT 테이블을 다시 복사

CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT; -- 복사되는 것 세가지


--문제) DEPT_COPY 테이블에 PK조건 추가 (컬럼명: DEPT_ID, 제약조건명: D_COPY_PK)

ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_PK PRIMARY KEY(DEPT_ID) ;



-- 이제 컬럼, 테이블, 제약의 이름을 변경하자


-- 1) 컬럼명을 변경

ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;



-- 2) 제약명을 변경 (D_COPY_PK => DEPT_COPY_PK)


ALTER TABLE DEPT_COPY RENAME CONSTRAINT DEPT_COPY_PK TO DEPT_COPY_PRIMARYKEY;


SELECT  * FROM DEPT_COPY;


-- 3) 테이블명을 변경


ALTER TABLE DEPT_COPY RENAME TO DCOPY;


SELECT  * FROM DEPT_COPY;
SELECT  * FROM DCOPY;

/*
 -- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음!
--> 삭제 후 새로운 구문을 추가 해야함.
  
 * */



-- 단독인 테이블 삭제 VS 자식이 있는 FK 테이블

-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS]




--1) 아무 관계가 형성되지 않은 테이블의 삭제

DROP TABLE DCOPY;


SELECT * FROM DCOPY;


--2) 관계가 형성된 테이블을 만들자

CREATE TABLE TB1 (
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
);

--TB1은 부모, 즉 참조의 대상


CREATE TABLE TB2 (
	TB2_PK  NUMBER PRIMARY KEY,
	TB2_COL NUMBER /* FK제약조건을 건다*/
	REFERENCES TB1 /*부모의 PK를 자동 참조*/
);
--TB2은 자식, 즉 TB1을 참조함

INSERT INTO TB1 VALUES (1,100);
INSERT INTO TB1 VALUES (2,200);
INSERT INTO TB1 VALUES (3,300);
-- PRIMARY KEY이므로 널도, 중복도 안 됨

SELECT * FROM TB1;


INSERT INTO TB2 VALUES (11, 1);
INSERT INTO TB2 VALUES (12, 2);
INSERT INTO TB2 VALUES (13, 3);

SELECT * FROM TB2;


DROP TABLE TB1;
-- 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다. (삭제하려는 테이블의 값을 참조하는 어떤 테이블이 존재하므로 삭제가 불가능하다)




/*
 * 1) 자식을 먼저 없애고 부모 삭제를 재시도
 
2) ALTER 구문을 이용하여 FK 제약조건을 삭제 후 (즉 부모 자식 제약을 삭제하고) 부모를 삭제  
  
3) DROP TABLE 테이블명에서 CASCADE CONSTRAINTS라는 옵션을 사용한다
  삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제 (2번과 동시에 테이블 삭제도 동시 진행)
 * */


-- 3) DROP TABLE 테이블명에서 CASCADE CONSTRAINTS라는 옵션을 사용한다. 삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제 (2번과 동시에 테이블 삭제도 동시 진행)
 
DROP TABLE TB1 CASCADE CONSTRAINTS;

-- TB1 자체가 이걸로 삭제 끝난 것

--SELECT * FROM TB1;

SELECT * FROM TB2;

COMMIT;



-- DML (INSERT)

INSERT INTO  TB2 VALUES (14,4);
INSERT INTO  TB2 VALUES (15,5);
--지금 이 시점에서는 TB1이라는 FK가 없으므로 4나, 5도 가능하다!


-- DDL을 섞어쓰면? (컬럼명을 바꿔보자)

ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLUMN;

SELECT * FROM TB2;


ROLLBACK ;

SELECT * FROM TB2;


--LAST