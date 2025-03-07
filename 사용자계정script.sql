ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 12C버전 이전 문법을 허용한다



CREATE USER kh IDENTIFIED BY kh1234; 
-- 계정을 생성하는 구문
-- CREATE USER 계정명 IDNTIFIED BY 비밀번호명;

GRANT RESOURCE, CONNECT TO kh;

-- 사용자 계정에게 권한을 부여 
-- GRANT 권한명, 권한명, 권한명 TO 계정명

-- RESOURCE : 테이블이나 인덱스와 같은 DB의 객체를 생성할 권한
-- CONNECT : DB에 연결하고 로그인할 수 있는 권한
-- 이게 없으면 oracle을 커넥션 로그인해도 수행이 되지 않는다

ALTER USER kh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;

-- 이제 이 계정으로 테이블을 만들 것인데 DB에서는 이를 DB 객체라고 부름 
-- 그를 만들 수 있는 공간 할당량을 무제한으로 지정


-- 한줄주석 
/* 범위주석은 자바와 마찬가지 */
-- 선택한 SQL을 수행하려면 수행하고자 하는 구문에 커서를 누르고 ctrl+enter를 누른다

-- 선택한 구문 뿐 아니라 여러 줄, 특히 전체의 SQL 구문을 수행시키고 싶다면 alt+X를 누른다
