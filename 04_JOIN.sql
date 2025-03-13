/*
[JOIN 용어 정리]
  오라클                                   SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인                               내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인                             왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                             JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                        교차 조인(CROSS JOIN)
CARTESIAN PRODUCT


- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.


-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!


/*
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.


- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  
*/


------------------------------------------------------------------------------------


/*
-- ex1) 사번, 이름, 부서코드 + 부서명을 조회한다
앞의 셋은 EMPLOYEE 테이블에서 구할 수 있다 => 부서명은 없다

**/

SELECT * FROM EMPLOYEE e;

--부서의 이름은 나오지 않음.  DEPARTMET라는 테이블을 따로 참조해야 함

SELECT * FROM DEPARTMENT d;


/*
 DEPT_TITLE을 알고 싶지만 사람의 이름은 EMPLOYEE에 있음 하나의 RESULT SET으로 한번에 조회하고 싶음.
  
EMPLOYEE TABLE의 DEPT_CODE 정보 = D로 시작하는 값
  
DEPARTMENT TABLE의 DEPT_ID 정보 = D로 시작하는 값
  
둘의 결과 값은 같기 때문에 EMPLOYEE 테이블의 DEPT_CODE와 DEPARTMENT 테이블의 DEPT_ID를 연결고리로 지정해서 JOIN하기로 한다  
 * */

SELECT e.EMP_ID , e.EMP_NAME, e.DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e
JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);


/*
 > 1) 내부 조인  = 등가 조인
  
 => 연결되는 컬럼의 값이 일치하는 행들만 조인 됨
 => 일치하는 값이 없는 행은 조인에서 제외 됨
 
  **작성법 자체가 ANSI와 오라클로 나뉨**
  
  **ANSI 구문 중에서도 USING과 ON 방식으로 나뉨**
  
 > ANSI - ON의 사용 
  
  연결에 사용할 두 컬럼의 이름이 다른 경우 
 
 * */



/*
 > 1-1: ANSI - ON의 사용 
  
  연결에 사용할 두 컬럼의 이름이 다른 경우 
 * */

SELECT e.EMP_ID , e.EMP_NAME, e.DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e
JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);

/*
 > 내부조인의 특징

연결에 사용된 컬럼의 값이 일치하지 않으면 조회된 결과에 포함되지 않는다.
이러한 단점을 극복하기 위해 외부 조인을 사용한다
 * */


-- > 1-2: ORACLE - 콤마의 사용 


SELECT e.EMP_ID , e.EMP_NAME, e.DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e, DEPARTMENT d 
WHERE e.DEPT_CODE = d.DEPT_ID ;



SELECT * FROM DEPARTMENT d ;
SELECT * FROM LOCATION l ;

-- 연습문제) DEPARTMENT테이블과 LOCATION 테이블을 참조하여 부서명과 지역명을 조회한다 BY 안시

SELECT d.DEPT_ID, l.LOCAL_CODE  
FROM DEPARTMENT d
JOIN LOCATION l  
ON(d.LOCATION_ID = l.LOCAL_CODE ); 


-- 연습문제) 위와 같은 문제 BY 오라클

SELECT d.DEPT_ID, l.LOCAL_CODE  
FROM DEPARTMENT d, LOCATION l 
WHERE d.LOCATION_ID = l.LOCAL_CODE;

/*
   
> 연결에 사용할 두 컬럼의 이름이 물론 같을 수도 있다  
  
-- EMPLOYEE + JOB이라는 테이블을 참조하여 사번, 이름, 직급코드, 직급명을 조회
 * */

SELECT * FROM EMPLOYEE e ;
SELECT * FROM JOB j;
/*
 컬럼값도 같고 컬럼의제목도 똑같다. 둘 다 JOB_CODE이기 때문
  
연결에 사용할 두 컬럼 이름이 같으면 안시에서는 USING 컬럼을 사용한다
 * */

-- 안시 버전
SELECT e.EMP_ID, e.EMP_NAME , JOB_CODE , JOB_NAME  FROM EMPLOYEE e 
JOIN JOB j USING(JOB_CODE);


SELECT EMP_ID, EMP_NAME , EMPLOYEE.JOB_CODE , JOB_NAME  FROM EMPLOYEE ,JOB   WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE  ;









/*
 > 내부조인의 특징



SELECT e.EMP_ID , e.EMP_NAME, e.DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e
JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);


연결에 사용된 컬럼의 값이 일치하지 않으면 조회된 결과에 포함되지 않는다.
이러한 단점을 극복하기 위해 외부 조인이 존재한다
다만 외부조인은 반드시 OUTTER JOIN이라고 명시해야만 한다

**/


SELECT e.EMP_ID , e.EMP_NAME, e.DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e
/* INNER */JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);



/*1) LEFT OUTER JOIN (사실 여기서 OUTER는 안 써도 됨)
합치기에 사용한 두 테이블 중 왼편에 작성된 테이블의 컬럼수를 기준으로 JOIN한다
왼편에 작성된 테이블의 모든 행이 JOIN이 되건말건 NULL이 몇개가 있건 상관없이 모든 행이 결과에 포함되도록 한다
*/
SELECT e.EMP_ID , e.EMP_NAME, e.DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE e
/* INNER */JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);

-- 안시 LEFT 코드
SELECT e.EMP_ID , DEPT_TITLE 
FROM EMPLOYEE e 
LEFT OUTER JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);


-- 오라클 LEFT 코드
SELECT e.EMP_ID , DEPT_TITLE 
FROM EMPLOYEE e, DEPARTMENT d 
WHERE e.DEPT_CODE = d.DEPT_ID(+);

-- 안시 RIGHT 코드
SELECT e.EMP_ID , DEPT_TITLE 
FROM EMPLOYEE e 
RIGHT OUTER JOIN DEPARTMENT d 
ON(e.DEPT_CODE = d.DEPT_ID);
-- 마케팅부, 국내영업부, 해외영업3부와 매칭하는 사원이 EMPLOYEE테이블에 없음. 
--그래도 DEPARTMENT테이블을 기준으로 JOIN했기에 전부 출력 되어야 함

-- 오라클 RIGHT 코드

SELECT e.EMP_NAME , DEPT_TITLE 
FROM EMPLOYEE e, DEPARTMENT d 
WHERE e.DEPT_CODE (+) = d.DEPT_ID ;


/*
 3-5) FULL OUTER JOIN BY ANSI
  합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함한다. 다만 ANSI구문만 FULL OUTER JOIN을 지원한다 
 **/

SELECT e.EMP_NAME, d.DEPT_TITLE   FROM EMPLOYEE e FULL JOIN DEPARTMENT d ON DEPT_CODE = DEPT_ID;


SELECT *FROM EMPLOYEE e  ;



/*
 4. 크로스 조인

교차 조인이라고도 부름

조인 되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법
  
의도적으로 값이 나오는 경우는 없고 조인 구문을 잘못 작성하는 경우에 나오게되는 쓰레기 값이다. 즉 잘못썼다는 것을 알아차릴 수 있으면 된다.
 * */

SELECT e.EMP_NAME , DEPT_TITLE FROM EMPLOYEE e CROSS JOIN DEPARTMENT d ;

SELECT * FROM SAL_GRADE sg ;

SELECT e.EMP_NAME, e.SAL_LEVEL   FROM EMPLOYEE e;


-- ex) 사원의 급여에 따른 급여 등급을 파악하는 예제


SELECT e.EMP_NAME , e.SALARY  , sg.SAL_LEVEL 
FROM EMPLOYEE e 
JOIN SAL_GRADE sg ON(e.SALARY BETWEEN sg.MIN_SAL AND sg.MAX_SAL );


/*
 같은 테이블을 조인한다. 자기 자신과 조인을 맺는 것이다.

사실 같은 테이블이 둘 있다고 생각하면 된다.

또한 같은 테이블에 대해 JOIN할 수 없으므로 각 테이블마다 별칭을 작성하는 것이 필수적이다. (미작성 시 열의 정의가 애매하다는 오류)  
  
> 왜 필요한가?
 * */

-- 사번, 이름, 사수의 사번, 사수의 이름 조회 => 단 사수가 없으면 '없음' 사수의 이름은 '-'

SELECT * FROM EMPLOYEE e ;



-- > 자체조인 BY ANSI
  
SELECT e1.EMP_ID 사번, e1.EMP_NAME 사원이름, NVL(e1.MANAGER_ID, '없음') "사수의 사번", NVL(e2.EMP_NAME, '-' )  "사수의 이름"
FROM EMPLOYEE e1 LEFT JOIN EMPLOYEE e2 ON (e1.MANAGER_ID = e2.EMP_ID  );



-- 사수가 없어도 어쨋든 표시하기 위해 LEFT JOIN으로 


-- > 자체조인 BY ORACLE

SELECT e1.EMP_ID 사번, e1.EMP_NAME 사원이름, NVL(e1.MANAGER_ID, '없음') "사수의 사번", NVL(e2.EMP_NAME, '-' )  "사수의 이름"
FROM EMPLOYEE e1, EMPLOYEE e2
WHERE e1.MANAGER_ID = e2.EMP_ID(+) ;



SELECT e.JOB_CODE  FROM EMPLOYEE e ;
SELECT j.JOB_CODE  FROM JOB j ;

SELECT  e.EMP_NAME , JOB_NAME
FROM EMPLOYEE e 
JOIN JOB USING (JOB_CODE);
--NATURAL JOIN JOB;


SELECT e.EMP_NAME , DEPT_TITLE FROM EMPLOYEE e NATURAL JOIN DEPARTMENT d ;

-- 이름 자체가 같지 않은데 이렇게 해버리면 크로스조인 결과가 나옴 

SELECT * FROM EMPLOYEE e ;
SELECT * FROM DEPARTMENT d  ;
SELECT * FROM LOCATION l  ;


-- ANSI 표준 다중 조인

SELECT e.EMP_NAME, d.DEPT_TITLE, l.LOCAL_NAME  FROM EMPLOYEE e 
JOIN DEPARTMENT d ON (d.DEPT_ID  = e.DEPT_CODE )
JOIN LOCATION l  ON (d.LOCATION_ID  = l.LOCAL_CODE );



-- ORACLE 다중 조인


SELECT e.EMP_NAME, d.DEPT_TITLE, l.LOCAL_NAME FROM EMPLOYEE e, DEPARTMENT d, LOCATION l 
WHERE DEPT_CODE = d.DEPT_ID AND d.LOCATION_ID  = l.LOCAL_CODE ;
-- 조건을 AND로 연산하면 된다.

/*
 직급이 대리이면서 아시아 지역 (ASIA로 시작하는 지역명이 있음)에 근무하는 직원을 조회한다
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여
 * */





SELECT e.EMP_ID "사번", e.EMP_NAME "이름", j.JOB_NAME "직급명", D.DEPT_ID "부서명", l.LOCAL_NAME "근무 지역명", E.SALARY "급여"   
FROM EMPLOYEE e 
JOIN JOB j ON (e.JOB_CODE = j.JOB_CODE) 
JOIN DEPARTMENT d  ON e.DEPT_CODE = d.DEPT_ID 
JOIN LOCATION l ON L.LOCAL_CODE = D.LOCATION_ID
WHERE E.JOB_CODE ='J6' AND SUBSTR(L.LOCAL_NAME,1,4)='ASIA';



SELECT e.EMP_ID "사번", e.EMP_NAME "이름", j.JOB_NAME "직급명", D.DEPT_ID "부서명", l.LOCAL_NAME "근무 지역명", E.SALARY "급여"   
FROM EMPLOYEE e 
JOIN JOB j USING (JOB_CODE)
JOIN DEPARTMENT d ON(e.DEPT_CODE  = d.DEPT_ID )
JOIN LOCATION l  ON (d.LOCATION_ID = l.LOCAL_CODE)
WHERE j.JOB_NAME  ='대리' AND l.LOCAL_NAME LIKE 'ASIA%';







/*
 JOIN 연습문제
1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의
사원명, 주민번호, 부서명, 직급명을 조회하시오.
 * */

SELECT e.EMP_NAME "사원명" , e.EMP_NO "주민번호", d.DEPT_TITLE  "부서명" 
FROM EMPLOYEE e JOIN DEPARTMENT d  ON e.DEPT_CODE = d.DEPT_ID  JOIN JOB j ON j.JOB_CODE = e.JOB_CODE
WHERE SUBSTR(e.EMP_NO, 1,1) = '7' AND SUBSTR(e.EMP_NAME,1,1)='전' AND SUBSTR(e.EMP_NO, 8,1) ='2' 
;

-- EMPLOYEE와 DEPARTMENT를 연결

/*
 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을
조회하시오.

 * */

SELECT e.EMP_ID, e.EMP_NAME, d.DEPT_TITLE, j.JOB_NAME  
FROM EMPLOYEE e  JOIN JOB j ON j.JOB_CODE = e.JOB_CODE JOIN DEPARTMENT d ON d.DEPT_ID = e.DEPT_CODE    
WHERE e.EMP_NAME LIKE '%형%'
;


/*
 * 3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을
조회하시오.
 * */

SELECT e.EMP_NAME, j.JOB_NAME, j.JOB_CODE, d.DEPT_TITLE    FROM EMPLOYEE e JOIN DEPARTMENT d  ON (e.DEPT_CODE = d.DEPT_ID) JOIN JOB j ON(e.JOB_CODE = J.JOB_CODE )
;

/*
 4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을
조회하시오.
 * */

SELECT e.EMP_NAME, e.BONUS, d.DEPT_TITLE, l.LOCAL_NAME      FROM EMPLOYEE e 
JOIN DEPARTMENT d  ON (e.DEPT_CODE = d.DEPT_ID) 
JOIN JOB j ON(e.JOB_CODE = J.JOB_CODE ) 
JOIN LOCATION l ON (d.LOCATION_ID  = l.LOCAL_CODE )
WHERE e.BONUS  IS NOT NULL
;


/*
 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
 * */




SELECT e.EMP_NAME, e.JOB_CODE,  d.DEPT_TITLE, l.LOCAL_NAME FROM EMPLOYEE e 
JOIN DEPARTMENT d  ON (e.DEPT_CODE = d.DEPT_ID) 
JOIN JOB j ON(e.JOB_CODE = J.JOB_CODE ) 
JOIN LOCATION l ON (d.LOCATION_ID  = l.LOCAL_CODE )
WHERE e.DEPT_CODE IS NOT NULL
;

/*
6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명,
급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)*/

SELECT e.EMP_NAME, e.JOB_CODE, e.SALARY , e.SALARY * (1+NVL( e.BONUS, 1)) "보너스를 합친 급여"  FROM EMPLOYEE e 
JOIN DEPARTMENT d  ON (e.DEPT_CODE = d.DEPT_ID) 
JOIN JOB j ON(e.JOB_CODE = J.JOB_CODE ) 
JOIN LOCATION l ON (d.LOCATION_ID  = l.LOCAL_CODE )
JOIN SAL_GRADE sg  ON sg.SAL_LEVEL  = e.SAL_LEVEL;
;


/*
 * 7.한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을
조회하시오.
 * */


SELECT e.EMP_NAME,  d.DEPT_TITLE, l.LOCAL_NAME, l.NATIONAL_CODE  FROM EMPLOYEE e 
JOIN DEPARTMENT d  ON (e.DEPT_CODE = d.DEPT_ID) 
JOIN JOB j ON(e.JOB_CODE = J.JOB_CODE ) 
JOIN LOCATION l ON (d.LOCATION_ID  = l.LOCAL_CODE )
WHERE l.NATIONAL_CODE ='KO' OR l.NATIONAL_CODE ='JP'
;


/*
 * 

8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을
조회하시오.(SELF JOIN 사용)

 * */

SELECT e1.EMP_NAME  ,  d.DEPT_ID, e2.EMP_NAME  
FROM EMPLOYEE e1
LEFT JOIN EMPLOYEE e2  ON (e1.DEPT_CODE = e2.DEPT_CODE)  -- 부서끼리 같은 것을 e2로 만들어야 하는데 
JOIN DEPARTMENT d ON (e1.DEPT_CODE = d.DEPT_ID )
WHERE e1.DEPT_CODE  = e2.DEPT_CODE  AND e1.EMP_ID <> e2.EMP_ID -- 이 부분을 빼먹으면 같은 부서 내 자기 이름도 같은 부서 사람이라고 나옴
ORDER BY d.DEPT_ID 
;

SELECT * FROM EMPLOYEE e ;
SELECT * FROM JOB J;
SELECT * FROM DEPARTMENT d  ;
SELECT * FROM LOCATION l  ;

/*
 *

9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명,
직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
 * */


SELECT e.EMP_NAME, j.JOB_NAME, e.SALARY  FROM EMPLOYEE e 
JOIN JOB j ON(e.JOB_CODE = J.JOB_CODE ) 
WHERE e.BONUS IS NULL  
;









-- LAST