-- CONNECT와 같은 권한 => DB에 접속할 수 있는 것부터 권한이 필요

-- 계정생성을 해도 CONNECT 자체가 안됨 SYS가 권한을 주었기 때문에 접속이 가능


/*
 * DCL (Data Control Language) : 데이터를 다루기 위한 권한을 다루는 언어
 * 
 * - 계정에 DB, DB객체에 대한 접근 권한을
 * 	 부여(GRANT)하고 회수(REVOKE)하는 언어
 * 
 * * 권한의 종류
 * 
 * 1) 시스템 권한 : DB접속, 객체 생성 권한
 * 		
 * 		CREATE SESSION   : 데이터베이스 접속 권한
 * 		CREATE TABLE     : 테이블 생성 권한
 * 		CREATE VIEW      : 뷰 생성 권한
 *    	CREATE SEQUENCE  : 시퀀스 생성권한
 * 		CREATE PROCEDURE : 함수(프로시져) 생성 권한
 * 		CREATE USER		 : 사용자(계정) 생성 권한
 * 		
 * 		DROP USER 		 : 사용자(계정) 삭제 권한
 * 
 * 2) 객체 권한 : 특정 객체를 조작할 수 있는 권한
 * 
 * 		권한 종류 			설정 객체
 * 
 * 		SELECT        TABLE, VIEW, SEQUENCE
 *    INSERT        TABLE, VIEW
 * 		UPDATE			 	TABLE, VIEW
 * 		DELETE			 	TABLE, VIEW
 * 		ALTER			 		TABLE, SEQUENCE (수정하되 구조를 변경)
 * 		REFERENCES 		TABLE (참조권한- FK를 설정할 권한)
 * 		INDEX			 		TABLE (인덱스를 생성할 수 있는 권한)
 * 		EXECUTE			  PROCEDURE (실행 권한- 프로시저, 즉 함수를 실행할 수 있는 권한)
 * 
 * */


/*
 * USER - 계정 (사용자) - 일종의 객체
 * 
 * * 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정.
 * 					모든 권한과 책임을 가지는 계정.
 * 					ex) sys(최고관리자), system(sys에서 권한 몇개가 제외된 관리자)
 * 
 * 
 * * 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
 * 					작업을 수행할 수 있는 계정으로
 * 					업무에 필요한 최소한의 권한만을 가지는것을 원칙으로 한다.
 * 					ex) kh, workbook 등
 
 * 
 * */






-- 1.SYS계정으로 사용자 계정을 생성하는 방법

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 계정명에 대한 이상한 SQL 법칙을 무시하게 하는 문법

-- [작성법]

-- CREATE UESER 사용자명 IDENTIFIED BY 비밀번호;

CREATE USER ljw_sample IDENTIFIED BY 1234;



-- ljw_sample은 create session권한이 없다 =>  접속권한 부여해야 함


/*
 권한 부여 작성법
 GRANT 권한1, 권한2, 권한3 ... TO 사용자명
 * */

GRANT CREATE SESSION TO ljw_sample;



-- 연결이 성공했으니 sample계정으로 접속해서 테이블을 생성해본다. 물론 권한이 없어 안 될 것이다


CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY
	,CONTENT VARCHAR2(100)
);

-- CREAT TABLE권한이 없다 + 데이터를 저장할 수 있는 공간이 없으므로 할당받아야 한다
-- 다시 SYS로 가서 이 둘을 하기로 한다



GRANT CREATE TABLE TO ljw_sample;

ALTER USER ljw_sample DEFAULT TABLESPACE SYSTEM /*테이블 스페이스의 이름이 SYSTEM*/ QUOTA UNLIMITED ON SYSTEM;



-- 다시 SAMPLE로 와서 테이블을 재생성



CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY
	,CONTENT VARCHAR2(100)
);


SELECT * FROM TB_TEST;
-- ROLE (역할): 권한의 묶음
-- 묶어둔 권한을 특정 계정에 부여 => 해당 계정은 지정된 권한을 이용하여 특정 역할을 갖게된다.

/*

CONNECT / RESOURCE : 사용자에게 부여할 수 있는 기본적인 시스템 역할

CONNECT: DB접속된 관련 권한을 묶어둔 ROLE, 가령 CREATE SESSION, ALTER SESSION


RESOURCE: DB 사용을 위한 객체 생성 권한을 묶어둔 ROLE, 가령 CREATE TABLE, CREATE SEQUENCE

*/

-- sys로 접속하여 sample계정에 CONNECT 및 RESOURCE를 부여하겠다

GRANT CONNECT, RESOURCE TO ljw_sample;



/* 객체 권한? 

ex) kh, sample사용자 계정끼리 서로 상대의 객체에 접근 권한을 부여해보자


 * */


-- 먼저 sample계정으로 가 kh계정의 EMPLOYEE에 접근 못함을 확인하자


SELECT * FROM EMPLOYEE;

/*
 아예 존재하지 않는다고 뜬다 => kh로 접속해 sample계정 쪽으로 EMPLOYEE테이블만은 조회할 수 있게 권한을 부여하면 되겠다
  
 * */


/*

[객체 권한의 부여 방법]

GRANT 객체권한 ON 객체명 TO 사용자명;

*/


GRANT SELECT ON EMPLOYEE TO ljw_sample;






SELECT * FROM kh.EMPLOYEE;


SELECT * FROM kh.DEPARTMENT;


/*
 
 kh로 접속하여 smaple계쩡에 부여했던 EMPLOYEE테이블의 조회 권한을 회수할 수 있다
 
 [권한 회수 작성법]
 
 REVOKE 객체의 권한 ON 객체명 FROM 사용자명
    
 **/

REVOKE SELECT ON EMPLOYEE FROM ljw_sample;


SELECT * FROM kh.EMPLOYEE;






-- 1.SYS계정으로 사용자 계정을 생성하는 방법

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 계정명에 대한 이상한 SQL 법칙을 무시하게 하는 문법

-- [작성법]

-- CREATE UESER 사용자명 IDENTIFIED BY 비밀번호;

CREATE USER kh_shop IDENTIFIED BY 1234;



-- ljw_sample은 create session권한이 없다 =>  접속권한 부여해야 함


/*
 권한 부여 작성법
 GRANT 권한1, 권한2, 권한3 ... TO 사용자명
 * */

GRANT CREATE SESSION TO kh_shop;



GRANT CONNECT, RESOURCE TO kh_shop;






























/*
 요약하면 다음과 같습니다:

---

## 💡 Oracle에서 사용자 계정 생성 및 권한 설정 흐름 요약

### ✅ 1. SYS 계정에서 사용자 생성
```sql
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;  -- 특수 계정명 허용 설정
CREATE USER 사용자명 IDENTIFIED BY 비밀번호;  -- 예: CREATE USER ljw_sample IDENTIFIED BY 1234;
```

### ✅ 2. 기본 접속 권한 부여
```sql
GRANT CREATE SESSION TO 사용자명;
```

### ✅ 3. 객체 생성 권한 및 테이블스페이스 설정
```sql
GRANT CREATE TABLE TO 사용자명;
ALTER USER 사용자명 DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
```

### ✅ 4. ROLE(역할)로 편리하게 권한 부여
- `CONNECT`: 접속 관련 권한 묶음 (CREATE SESSION 등)
- `RESOURCE`: 객체 생성 관련 권한 묶음 (CREATE TABLE 등)
```sql
GRANT CONNECT, RESOURCE TO 사용자명;
```

### ✅ 5. 다른 사용자 객체에 대한 **객체 권한 부여**
- 특정 테이블만 접근 허용:
```sql
GRANT SELECT ON 테이블명 TO 사용자명;  -- 예: GRANT SELECT ON EMPLOYEE TO ljw_sample;
```

- 접근 시 `소유자.테이블명` 형식으로 사용:
```sql
SELECT * FROM kh.EMPLOYEE;
```

### ✅ 6. 객체 권한 회수
```sql
REVOKE SELECT ON 테이블명 FROM 사용자명;  -- 예: REVOKE SELECT ON EMPLOYEE FROM ljw_sample;
```

---

이 과정을 반복하여 `kh_shop` 계정도 생성하고 동일한 권한 부여를 수행함.
 * */


















/*
`GRANT CONNECT, RESOURCE TO 사용자명;` 한 줄이면 정말 **2번, 3번이 전부 필요 없는지** 헷갈릴 수 있는데,  
실제로는 **부분적으로만 대체가 가능**해.

---

## 🔎 CONNECT, RESOURCE가 부여하는 권한은?

### ✅ `CONNECT` ROLE에 포함된 권한 (접속 관련)
- `CREATE SESSION`  
→ **DB 접속을 가능하게 해줌**

즉, **2번: GRANT CREATE SESSION TO 사용자명**은 `CONNECT`를 부여하면 **자동 포함되므로 따로 안 해도 됨!**

---

### ✅ `RESOURCE` ROLE에 포함된 권한 (객체 생성 관련, 일부)
- `CREATE TABLE`
- `CREATE SEQUENCE`
- `CREATE PROCEDURE`
- `CREATE TRIGGER`
- `CREATE TYPE`

즉, **3번 중 일부인 `GRANT CREATE TABLE TO 사용자명`은 RESOURCE에 포함되므로 생략 가능**해!

---

## ❗ 그런데 완전히 끝난 건 아님!

### 🚫 RESOURCE Role에는 **테이블스페이스 할당**이 없다!
즉, 다음 줄:

```sql
ALTER USER 사용자명 DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
```

이거는 **꼭 필요함!**  
안 해주면 테이블을 만들 수 있는 권한이 있어도 **저장할 공간이 없어서** `ORA-01950: no privileges on tablespace` 같은 오류가 나옴.

---

## ✅ 결론 정리

| 항목 | CONNECT, RESOURCE로 대체 가능? |
|------|------------------------------|
| `GRANT CREATE SESSION` | ✅ YES → CONNECT에 포함됨 |
| `GRANT CREATE TABLE`   | ✅ YES → RESOURCE에 포함됨 |
| `ALTER USER ... TABLESPACE ...` | ❌ NO → 별도로 꼭 해줘야 함 |

---

궁금한 점 있으면 이어서 설명해줄게!
 
 * */