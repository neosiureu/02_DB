/*
 ## 1. `ON` vs `USING` 차이
### 공통점:
- 둘 다 `JOIN` 시 특정 컬럼을 기준으로 테이블을 연결할 때 사용함.

### 차이점:
| 구분 | `ON` | `USING` |
|------|------|---------|
| 연결 기준 | 두 테이블의 특정 컬럼을 지정할 수 있음 | 두 테이블에 동일한 컬럼 이름이 존재해야 함 |
| 컬럼 명시 | 테이블 별칭을 사용하여 각각 명시 가능 | 공통 컬럼 하나만 명시 가능 |
| 반환 컬럼 | 두 테이블 모두 해당 컬럼을 포함 (ex. `table1.column, table2.column`) | 해당 컬럼을 하나로 반환 (중복 제거) |

#### **예제**
```sql
-- ON을 사용한 예제 (다른 컬럼명)
SELECT *
FROM employees e
JOIN departments d
ON e.department_id = d.dept_id;

-- USING을 사용한 예제 (같은 컬럼명)
SELECT *
FROM employees
JOIN departments
USING (department_id);
```
- `ON` 사용 시: `employees.department_id`, `departments.dept_id` 두 개의 컬럼이 존재.
- `USING` 사용 시: `department_id` 하나만 남음.

---

## 2. JOIN 시 연결고리 컬럼 선택
### 1) 컬럼명이 다를 경우
- `ON table1.col1 = table2.col2` 형식으로 지정.

### 2) 컬럼명이 같을 경우
- `USING (공통컬럼)` 사용 가능.
- `ON table1.공통컬럼 = table2.공통컬럼`도 가능.

```sql
SELECT e.name, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id; -- 같은 이름이지만 USING 안 쓰고 ON 사용 가능
```

---

## 3. 별칭(Alias) 사용과 테이블 명확화 필요 케이스
### **(1) 별칭 사용 예시**
- 테이블 별칭(Alias)을 지정하면 가독성이 좋아짐.
- `AS` 키워드는 생략 가능.

```sql
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
```

### **(2) 테이블을 명확히 해야 하는 경우**
#### (a) **동일한 컬럼명이 존재할 때**
```sql
SELECT employees.name, employees.department_id, departments.department_id
FROM employees
JOIN departments
ON employees.department_id = departments.department_id;
```
- `department_id`가 두 테이블에 모두 존재하므로 `employees.department_id`, `departments.department_id`처럼 테이블을 명시해야 함.

#### (b) **SELF JOIN (자기 자신 조인)**
```sql
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.employee_id;
```
- 같은 테이블을 두 번 사용하므로 별칭(`e1`, `e2`)을 주지 않으면 오류 발생.

---

## 4. 해석 순서와 별칭(Alias) 사용 가능 여부
### **SQL 해석 순서 (FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY)**
- **SELECT 절에서 별칭을 정의하지만, 해석 순서는 가장 마지막**이므로 `WHERE`, `GROUP BY` 등에서는 해당 별칭을 사용할 수 없음.

#### **(1) 별칭이 사용 가능한 경우**
- `SELECT`, `ORDER BY`에서 사용 가능.

```sql
SELECT e.name AS emp_name
FROM employees e
ORDER BY emp_name; -- 별칭 사용 가능
```

#### **(2) 별칭을 사용할 수 없는 경우**
- `WHERE`, `GROUP BY`에서 별칭을 사용할 수 없음.

```sql
SELECT name AS emp_name
FROM employees
WHERE emp_name = 'John'; -- 오류 발생 (WHERE 절은 SELECT보다 먼저 해석됨)
```

- **해결 방법**: 원본 컬럼명을 사용해야 함.
```sql
SELECT name AS emp_name
FROM employees
WHERE name = 'John'; -- 올바른 방식
```

---

## 5. 시험 예상 문제 (쿼리 수정 문제)
### **문제 유형 1: ON과 USING을 잘못 사용한 경우**
❌ **잘못된 쿼리**
```sql
SELECT *
FROM employees e
JOIN departments d
USING (e.department_id); -- USING에서는 테이블 명을 사용할 수 없음
```
✅ **수정된 쿼리**
```sql
SELECT *
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
```
또는
```sql
SELECT *
FROM employees
JOIN departments
USING (department_id);
```

---

### **문제 유형 2: 별칭(Alias) 사용 오류**
❌ **잘못된 쿼리**
```sql
SELECT name AS emp_name, salary
FROM employees
WHERE emp_name = 'John'; -- WHERE에서 별칭 사용 불가
```
✅ **수정된 쿼리**
```sql
SELECT name AS emp_name, salary
FROM employees
WHERE name = 'John';
```

---

### **문제 유형 3: JOIN 조건이 잘못된 경우**
❌ **잘못된 쿼리**
```sql
SELECT e.name, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.dept_no; -- 실제 컬럼명이 다름
```
✅ **수정된 쿼리**
```sql
SELECT e.name, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
```

---

### **문제 유형 4: SELF JOIN에서 테이블 명시 안 한 경우**
❌ **잘못된 쿼리**
```sql
SELECT name, manager_id
FROM employees
JOIN employees
ON manager_id = employee_id; -- 테이블 명시 안 함
```
✅ **수정된 쿼리**
```sql
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.employee_id;
```

---



### **시험 대비 요약**
1. `ON`은 서로 다른 컬럼명도 비교 가능하지만, `USING`은 두 테이블에 동일한 컬럼명이 있어야 함.
2. `JOIN` 시 컬럼명이 다르면 `ON 테이블1.컬럼 = 테이블2.컬럼` 형식으로 명시해야 함.
3. 별칭(Alias)은 `SELECT` 절과 `ORDER BY`에서는 사용 가능하지만, `WHERE`와 `GROUP BY`에서는 사용할 수 없음.
4. `SELF JOIN` 시 반드시 별칭을 사용해야 오류 없이 실행됨.
5. `ON`과 `USING`을 혼동하지 않도록 확인해야 함.
6. 문제 유형은 쿼리에서 원하는 결과가 안 나올 때 수정하는 방식이므로, 실행 순서를 고려하여 수정해야 함.

이런 유형으로 시험이 나올 가능성이 높으니, 위의 예제들을 직접 실행해보는 것이 좋음!
 * */

SELECT * FROM TB_USER;


/*
  아래 내용을 순서대로 살펴보면 이해가 쉬울 것입니다.

---

## 1. SELECT 서브쿼리(서브 셀렉트) 사용 시 주의사항

### 1.1 서브쿼리의 위치
- **SELECT 절**: `SELECT (서브쿼리)` 형태로 값을 추출한다.
- **FROM 절**: 인라인 뷰(Inline View) 형태로 테이블처럼 서브쿼리를 사용할 수 있다.
- **WHERE 절**: 비교나 조건을 걸기 위한 서브쿼리를 사용할 수 있다.
- **HAVING 절**: 그룹함수의 조건에 서브쿼리를 쓸 수 있다.

예시) SELECT 절에 서브쿼리
```sql
SELECT 
    e.employee_id,
    e.first_name,
    (SELECT department_name 
       FROM departments d 
      WHERE d.department_id = e.department_id
    ) as dept_name
FROM employees e;
```
- `employees` 테이블의 각 행마다 `department_name`을 함께 보여주고자 서브쿼리를 사용.

### 1.2 서브쿼리와 JOIN 중 선택
- 서브쿼리를 `SELECT 절`에서 사용하는 경우, 한 행당 서브쿼리가 한 번씩 실행될 수 있으므로 성능 문제가 발생할 수 있다.  
- JOIN 구문으로 동일한 결과를 낼 수 있다면, 일반적으로 **조인을 권장**한다.

---

## 2. JOIN에서 `ON`과 `USING`의 차이

### 2.1 `ON`
- **조인 조건**을 자유롭게 기술할 수 있는 구문이다.
- 테이블 컬럼명이 달라도 원하는 컬럼끼리 조인 가능.
- 예시:
  ```sql
  SELECT *
    FROM employees e
         JOIN departments d
           ON e.department_id = d.department_id;
  ```
- 여기서 `department_id`라는 컬럼 이름이 같긴 하지만, 만약 다르더라도 `(e.dept_id = d.department_no)`처럼 자유롭게 매핑 가능.

### 2.2 `USING`
- 두 테이블에 **동일한 컬럼명**이 존재할 때, 해당 컬럼 이름을 한 번만 명시한다.
- **결과셋에서 조인에 사용된 컬럼은 단 한 번만** 표시된다.
- 예시:
  ```sql
  SELECT *
    FROM employees e
         JOIN departments d
         USING (department_id);
  ```
- `USING (department_id)`를 사용하면 결과로 나오는 컬럼에는 `department_id`가 **중복으로 나타나지 않고** 한 번만 표시된다.

> **주의**: `USING`을 쓰려면 **조인하려는 두 테이블의 컬럼 이름이 같아야** 한다. 

---

## 3. JOIN 시 연결고리(조인할 컬럼 이름) 차이
- `ON`을 사용할 때는 `테이블명.컬럼명 = 테이블명.컬럼명` 형태로 적어줄 수 있다.
- `USING`을 사용할 때는 괄호 안에 동일 이름의 컬럼을 적는다.
- **결정 요인**: 조인할 대상 컬럼 이름이 동일한지, 그렇지 않은지.

---

## 4. Alias(별칭) 사용과 테이블 명확화

### 4.1 컬럼/테이블 별칭 사용
1. **컬럼 별칭**: SELECT 절에서 컬럼을 다른 이름으로 표기할 때 사용.
   ```sql
   SELECT e.employee_id AS emp_id,
          e.first_name  AS name
     FROM employees e;
   ```
2. **테이블 별칭**: 길거나 읽기 어려운 테이블 이름을 짧게 줄이거나,  
   같은 컬럼 이름이 여러 테이블에 있을 때 구분을 위해 사용.
   ```sql
   SELECT e.employee_id, d.department_name
     FROM employees e
          JOIN departments d ON e.department_id = d.department_id;
   ```
- 테이블 별칭을 사용하면 이후 SELECT나 WHERE 등에서 `employees.employee_id` 대신 `e.employee_id` 형태로 간결하게 작성 가능.

### 4.2 SQL 해석 순서와 별칭 인식
- **일반적인 SQL 해석 순서**(오라클 기준)  
  1) FROM  
  2) WHERE  
  3) GROUP BY  
  4) HAVING  
  5) SELECT  
  6) ORDER BY  
- 즉, **SELECT 절에서 정의한 컬럼 별칭**은 `WHERE` 절에서 **사용할 수 없다**. 왜냐하면 `WHERE`는 SELECT보다 먼저 해석되기 때문이다.  
  ```sql
  SELECT e.employee_id AS emp_id
    FROM employees e
   WHERE emp_id = 100;    -- ❌ 에러 (WHERE 단계에서 emp_id 별칭은 인식 불가)
  ```
  이럴 때는 반드시 실제 컬럼명을 써야 한다:
  ```sql
  SELECT e.employee_id AS emp_id
    FROM employees e
   WHERE e.employee_id = 100;  -- ✅
  ```
- **ORDER BY**에서는 SELECT 절의 별칭을 사용할 수 있다(ORDER BY는 SELECT보다 나중에 해석).

---

## 5. 시험 문제에 자주 나오는 형태 및 유의점

1. **별칭을 WHERE에서 사용**
   - `SELECT`에서 정의한 별칭을 `WHERE`에서 쓰면 오류 발생.  
   - 예) `WHERE emp_alias = 100` → `WHERE employee_id = 100` 으로 수정해줘야 함.

2. **`USING`으로 조인 시, 결과 컬럼 참조 에러**
   - `USING(department_id)`를 썼다면 결과에는 `department_id` 컬럼이 **한 번만** 나타난다.  
   - `테이블별칭.department_id`로는 참조할 수 없다. 왜냐하면 `USING`을 쓰면 스키마 상(결과셋)에서 한 컬럼으로만 매핑되기 때문에 **“ambiguous column”** 또는 **“invalid identifier”** 오류가 뜰 수 있다.
   - `SELECT department_id`만 쓰면 되거나,  
     `SELECT e.*, d.*` 대신 `SELECT *` 만 써도 조인 컬럼이 하나만 나온다.

3. **ON 절에서 컬럼명을 잘못 지정하거나 테이블 명시를 제대로 하지 않은 경우**
   - 예) `JOIN ON e.employee_id = d.employee_id`인데 사실 `employee_id`가 `departments`에는 없을 수도 있음. 시험 문제에서 이런 식으로 “왜 에러가 날까?” 식으로 물어볼 수 있음.

4. **인라인 뷰(서브쿼리)를 사용하는데 FROM 절 인라인 뷰와 바깥쪽 SELECT 절의 alias가 충돌**
   - 예) 
     ```sql
     SELECT v.col1, v.col2
       FROM (SELECT emp_id col1, dept_id col2 FROM employees) v
      WHERE col1 > 100;
     ```
     - 잘못 alias를 헷갈리면 “컬럼이 없어요” 오류가 날 수 있음.

5. **집계함수를 쓰면서 alias를 HAVING에서 바로 참조하려고 하는 경우**
   - HAVING절은 GROUP BY 이후에 해석되므로 SELECT 절의 별칭을 HAVING에서 바로 쓰지 못한다.  
   - 예) 
     ```sql
     SELECT department_id, COUNT(*) AS cnt
       FROM employees
      GROUP BY department_id
     HAVING cnt > 5; -- ❌ 별칭 cnt는 SELECT 후에 정의되므로 여기선 사용 불가
     ```
     → `HAVING COUNT(*) > 5`처럼 직접 함수나 컬럼을 써야 한다.
     ```sql
     SELECT department_id, COUNT(*) AS cnt
       FROM employees
      GROUP BY department_id
     HAVING COUNT(*) > 5; -- ✅
     ```




### 5.1 예시로 나올 법한 시험 문제 형태

> **문제:** 다음 쿼리를 실행했는데 에러가 발생한다. 원인을 파악하고 올바르게 수정하시오.
> ```sql
> SELECT e.employee_id AS emp_id,
>        e.first_name AS emp_name
>   FROM employees e
>  WHERE emp_id = 101;
> ```
> 
> **원인**: WHERE 절은 SELECT 절보다 먼저 해석되므로 `emp_id`라는 별칭을 아직 모른다.  
> **수정안**:
> ```sql
> SELECT e.employee_id AS emp_id,
>        e.first_name AS emp_name
>   FROM employees e
>  WHERE e.employee_id = 101;
> ```

> **문제:** 다음 조인 쿼리를 실행했더니 오류 또는 예상과 다른 결과가 나온다. 조인 구문을 확인하고 수정하시오.
> ```sql
> SELECT e.employee_id, d.department_name
>   FROM employees e
>        JOIN departments d
>        USING (department_id)
>  WHERE e.department_id IS NOT NULL;
> ```
> **원인**: `USING (department_id)`를 썼다면 결과 컬럼 `department_id`는 한 번만 표시된다. `e.department_id`라고 쓰는 순간 에러가 날 수 있다(“invalid identifier” 등).  
> **수정안**:
> - `ON e.department_id = d.department_id` 로 바꾸거나  
> - `USING (department_id)`를 유지하려면 `WHERE department_id IS NOT NULL` 로 변경한다.

> **문제:** 서브쿼리를 사용했을 때 결과가 제대로 안 나온다. 
> ```sql
> SELECT 
>    e.employee_id,
>    (SELECT d.department_name 
>       FROM departments d 
>      WHERE d.department_id = e.department_id
>    ) dept_name
>   FROM employees e
>  WHERE d.department_name LIKE '%SALES%';
> ```
> **원인**: `WHERE d.department_name LIKE '%SALES%'`에서 `d`는 내부 서브쿼리에만 존재하는 alias여서 바깥쪽 WHERE에서 인식이 안 된다.  
> **수정안**: 바깥쪽 WHERE에서 필터링 하려면 **JOIN** 사용하거나, 인라인 뷰 사용 등. 
> ```sql
> -- JOIN으로 수정 예시
> SELECT e.employee_id, d.department_name
>   FROM employees e
>        JOIN departments d ON e.department_id = d.department_id
>  WHERE d.department_name LIKE '%SALES%';
> ```
> 혹은 인라인 뷰:
> ```sql
> SELECT iv.employee_id, iv.department_name
>   FROM (
>         SELECT e.employee_id, d.department_name
>           FROM employees e
>                JOIN departments d ON e.department_id = d.department_id
>        ) iv
>  WHERE iv.department_name LIKE '%SALES%';
> ```

---

## 마무리

- **ON vs USING**  
  - ON: 컬럼명이 달라도 자유롭게 조인 조건 기술 가능.  
  - USING: 동일한 컬럼명으로 조인 시 결과에서 중복 컬럼이 한 번만 표시됨.
- **Alias(별칭) 주의**  
  - WHERE, GROUP BY, HAVING 절 등에서는 SELECT에서 정의된 별칭을 직접 사용할 수 없음.  
  - ORDER BY는 가능.
- **시험 문제 빈출**  
  - 별칭 인식 순서 에러, USING vs ON 사용법 오류, 서브쿼리에서 내부 alias를 바깥 WHERE에서 사용하려다 생기는 문제 등이 자주 출제된다.

이런 유형으로 “쿼리가 원하는 대로 동작하지 않습니다. 에러 원인을 찾고 수정하시오.” 같은 형태로 나오므로,  
- 조인 컬럼 식별이 올바른지,  
- 별칭 사용 범위가 올바른지,  
- 서브쿼리와 바깥 쿼리의 범위(스코프)가 충돌하지 않는지  
등을 꼼꼼히 확인하면 됩니다.
 * */















/*
 * 아래는 시험에서 한꺼번에 묶여서 출제될 수 있는 “오류 수정” 유형의 문제 3가지 예시입니다.  
(각 문제마다 “문제 상황 → 원인 → 수정안” 형식으로 정리했습니다.)

---

## **문제 1: 별칭(Alias) 사용 위치 오류**

### 문제 상황
```sql
SELECT e.EMP_ID AS emp_alias, e.EMP_NAME
  FROM EMPLOYEES e
 WHERE emp_alias = 'E101';
```
- 실행 시 “invalid identifier” 또는 “column not allowed here” 등의 오류 발생

### 원인
- `WHERE` 절은 `SELECT` 절보다 먼저 해석된다.  
- 따라서 `WHERE`에서 아직 정의되지 않은 별칭(`emp_alias`)를 사용할 수 없다.

### 수정안
```sql
SELECT e.EMP_ID AS emp_alias, e.EMP_NAME
  FROM EMPLOYEES e
 WHERE e.EMP_ID = 'E101';  -- 별칭 대신 실제 컬럼명 사용
```
- `WHERE` 절에는 실제 컬럼명을 사용하면 정상 동작한다.  
- 만약 `ORDER BY`라면 별칭 사용이 가능(SELECT 해석이 끝난 후에 실행되므로).

---

## **문제 2: JOIN 시 `USING` 사용 오류**

### 문제 상황
```sql
SELECT e.EMP_ID, d.DEPT_TITLE
  FROM EMPLOYEES e
       JOIN DEPARTMENT d
       USING (DEPT_ID)
 WHERE e.DEPT_ID IS NOT NULL;
```
- 실행 시 “invalid identifier” 또는 “column ambiguously defined” 등의 오류 가능  
- 또는 결과가 제대로 나오지 않거나, 컬럼명이 다르다는 이유로 오류가 날 수 있음.

### 원인
1. **EMPLOYEES** 테이블의 컬럼명이 `DEPT_CODE`인데, `DEPARTMENT` 테이블은 `DEPT_ID`일 수도 있다.  
2. `USING`을 쓰려면 두 테이블 컬럼명이 완전히 **동일**해야 한다.  
3. `USING(DEPT_ID)`를 쓰면 결과셋에서 `DEPT_ID`는 **한 번만** 나타나므로 `e.DEPT_ID`처럼 테이블명 붙이는 것도 불가.

### 수정안 (예시 2가지)

#### (1) 컬럼명이 실제로 동일하다면 `USING`만 쓰기
```sql
SELECT e.EMP_ID, d.DEPT_TITLE
  FROM EMPLOYEES e
       JOIN DEPARTMENT d
       USING (DEPT_CODE)  -- 두 테이블 컬럼이 동일할 때만 가능
 WHERE DEPT_CODE IS NOT NULL;  -- 결과셋에서는 DEPT_CODE만 남음(테이블명.컬럼명 사용 불가)
```

#### (2) 컬럼명이 다르다면 `ON`으로 조인
```sql
SELECT e.EMP_ID, d.DEPT_TITLE
  FROM EMPLOYEES e
       JOIN DEPARTMENT d
       ON e.DEPT_CODE = d.DEPT_ID  -- 서로 다른 컬럼명 매핑
 WHERE e.DEPT_CODE IS NOT NULL;    -- ON 절 사용 시 테이블명.컬럼명 가능
```

---




















## **문제 3: 서브쿼리에서의 잘못된 참조**

### 문제 상황
```sql
SELECT e.EMP_ID,
       (SELECT d.DEPT_TITLE 
          FROM DEPARTMENT d
         WHERE d.DEPT_ID = e.DEPT_CODE
           AND d.DEPT_TITLE LIKE dept_alias || '%'
       ) AS dept_info
  FROM EMPLOYEES e
       JOIN DEPARTMENT dd ON e.DEPT_CODE = dd.DEPT_ID
 WHERE dd.DEPT_TITLE = '인사'
   AND dept_alias = '관리'; 
```
- 서브쿼리 혹은 WHERE 절에서 `dept_alias` 같은 별칭(또는 바깥 테이블의 별칭이 제대로 연결되지 않는 등) 잘못된 참조로 오류 발생 가능.

### 원인
1. **SELECT 절의 별칭**(`dept_info`나 `dept_alias`)을 서브쿼리 내부 또는 `WHERE` 절에서 잘못 호출.  
2. 바깥쪽 쿼리와 서브쿼리 사이에 스코프가 달라서, 내부에서 정의한 alias를 바깥에서 못 쓰거나 그 반대가 발생.

### 수정안 (예시)
- **JOIN**을 활용해서 서브쿼리 없이 직접 조인.
- 혹은 **인라인 뷰**로 처리하되, 별칭 겹침에 주의.

```sql
-- 1) 서브쿼리 대신 JOIN 사용
SELECT e.EMP_ID,
       dd.DEPT_TITLE AS dept_info
  FROM EMPLOYEES e
       JOIN DEPARTMENT dd
            ON e.DEPT_CODE = dd.DEPT_ID
 WHERE dd.DEPT_TITLE LIKE '관리%'
   AND dd.DEPT_TITLE = '인사';

-- 2) 인라인 뷰 활용 (별칭 범위 주의)
SELECT v.EMP_ID, v.DEPT_TITLE
  FROM ( SELECT e.EMP_ID, d.DEPT_TITLE
           FROM EMPLOYEES e
                JOIN DEPARTMENT d ON e.DEPT_CODE = d.DEPT_ID
        ) v
 WHERE v.DEPT_TITLE = '인사';
```
- 바깥 WHERE에서 `dept_alias` 등을 직접 만들려면, 동일한 범위(scope)에 있어야 하며  
  **SELECT** 절에서 정의된 별칭은 **WHERE**에서 인식되지 않는다는 점을 늘 유의.

---

> **정리**  
> 1. 별칭은 `SELECT`보다 먼저 해석되는 절(WHERE/GROUP BY/HAVING)에서 인식 불가.  
> 2. `USING`은 테이블 간 **동일한 컬럼명**일 때만 사용 가능하며 결과에서 한 컬럼만 남는다.  
> 3. 서브쿼리와 메인쿼리의 별칭/컬럼 참조 스코프를 구분해야 한다.  
> 4. 시험문제는 “쿼리가 오류 나니 수정하라” 형태로 자주 출제되며, 위와 같은 실수(ON↔USING 혼동, 별칭 위치 오류, 서브쿼리/범위 스코프 문제 등)를 교정하는 문제로 나온다.
 * */






















-- yyyy대 rrrr

/*
 **`YYYY`, `YY`, `RR`, `RRRR`의 동작 방식**이 다르기 때문에 **20세기(1900년대)인지, 21세기(2000년대)인지 해석 방식이 다르다.**  
아래 표를 보면 정확히 이해할 수 있어.

---

## **📌 `YYYY`, `YY`, `RR`, `RRRR` 차이점 정리**
| 포맷  | 입력 값 | 변환 결과 (현재 연도가 2024년 기준) | 기준 |
|------|--------|-----------------|------------------|
| `YYYY` | `24`  | **0024년** | 무조건 네 자리 연도로 해석 |
| `YY`   | `24`  | **0024년** | 2자리 → 앞에 `00` 붙임 |
| `RR`   | `24`  | **2024년** | `50 이상 → 19XX`, `49 이하 → 20XX` |
| `RRRR` | `24`  | **2024년** | 2자리면 RR처럼, 4자리면 그대로 |

---

## **🚀 예제별 동작 방식**
### **✅ `YYYY`, `YY` → 그냥 숫자 그대로 해석 (19세기, 20세기 고려 안 함)**
```sql
SELECT TO_DATE('24-06-15', 'YY-MM-DD') FROM DUAL;  
```
> **결과:** `0024-06-15`  
> **설명:** `YY`는 무조건 앞에 `00`을 붙여서 **0024년**이 됨. (19세기, 20세기 고려 안 함)

```sql
SELECT TO_DATE('24-06-15', 'YYYY-MM-DD') FROM DUAL;
```
> **결과:** `0024-06-15`  
> **설명:** `YYYY`도 네 자리 연도로 그대로 해석되므로 **0024년**이 됨.

---

### **✅ `RR`, `RRRR` → 50을 기준으로 19세기 또는 20세기로 변환**
```sql
SELECT TO_DATE('24-06-15', 'RR-MM-DD') FROM DUAL;  
```
> **결과:** `2024-06-15`  
> **설명:** `RR`은 현재 연도(2024년)를 기준으로 **50 이하 → 2000년대**, **50 이상 → 1900년대** 해석.  
> `24`는 `50 이하`이므로 **2024년**이 됨.

```sql
SELECT TO_DATE('75-06-15', 'RR-MM-DD') FROM DUAL;  
```
> **결과:** `1975-06-15`  
> **설명:** `75`는 `50 이상`이므로 **1975년**이 됨.

```sql
SELECT TO_DATE('24-06-15', 'RRRR-MM-DD') FROM DUAL;
```
> **결과:** `2024-06-15`  
> **설명:** `RRRR`은 **2자리면 `RR`처럼**, **4자리면 그대로 유지**하므로 **2024년**이 됨.

```sql
SELECT TO_DATE('1924-06-15', 'RRRR-MM-DD') FROM DUAL;
```
> **결과:** `1924-06-15`  
> **설명:** `RRRR`은 4자리면 그대로 인식하므로 **1924년**으로 저장됨.

---

## **🔥 결론**
- **`YYYY`, `YY`는 그냥 숫자를 그대로 해석** (1000년대, 2000년대 구분 X)  
- **`RR`, `RRRR`는 50을 기준으로 1900년대와 2000년대를 자동 판별**  
- **`RRRR`는 4자리 연도 그대로 해석하며, 2자리 입력 시 `RR`처럼 동작**  
- **21세기(2000년대)를 기준으로 사용하려면 `RR` 또는 `RRRR`을 쓰는 게 더 적절함!** 🚀
 * */




















 /*
 오라클에서 **홑따옴표(')**와 **쌍따옴표(")**의 사용법 및 `alias`(별칭)에서 따옴표를 생략할 수 있는 경우를 정확히 구분해서 정리해 보겠습니다.

---

## 🔹 **1. 홑따옴표(') 사용 - 문자열 리터럴**
> **홑따옴표(`'`)는 문자열을 나타낼 때 반드시 사용해야 함.**
> - `VARCHAR2`, `CHAR`, `CLOB` 같은 문자열 데이터 타입과 함께 사용됨.

### ✅ **예제**
```sql
SELECT 'Hello World' FROM DUAL;  -- 'Hello World'라는 문자열 리터럴을 출력
SELECT '620314-1031314' FROM DUAL; -- 주민번호 같은 문자열 데이터
```

### 🚨 **잘못된 예제 (문자열에 홑따옴표 없이 사용)**
```sql
SELECT Hello World FROM DUAL;  -- 오류 발생
```
📌 **오류 발생 이유**: `Hello`와 `World`가 **컬럼명으로 인식**되기 때문.

---

## 🔹 **2. 쌍따옴표(") 사용 - 대소문자 및 공백 포함 별칭, 컬럼/테이블명**
> **쌍따옴표(`"`)는 식별자(컬럼명, 테이블명, 별칭)를 정의할 때 사용함.**
> - 공백이 포함된 별칭
> - 숫자로 시작하는 컬럼/테이블명
> - 대소문자를 유지해야 하는 경우

### ✅ **예제**
```sql
SELECT first_name AS "Full Name"
FROM employees;
```
📌 **설명**: `"Full Name"`은 **공백이 포함된 별칭**이므로 쌍따옴표를 사용해야 함.

```sql
CREATE TABLE "123Table" (id NUMBER);  -- 숫자로 시작하는 테이블명
SELECT * FROM "123Table";
```
📌 **설명**: `"123Table"`은 숫자로 시작하므로 쌍따옴표 없이 사용할 수 없음.

```sql
CREATE TABLE "MyTable" ( "EmpID" NUMBER, "empName" VARCHAR2(100) );
SELECT "empName" FROM "MyTable";
```
📌 **설명**: `"MyTable"`과 `"empName"`을 대소문자 그대로 유지해야 할 경우 쌍따옴표 사용.

---

## 🔹 **3. `alias`(별칭)에서 따옴표 없이 사용할 수 있는 경우**
> **별칭(Alias)은 대소문자 구분이 필요 없고, 공백이 없으면 따옴표 없이 사용 가능.**

### ✅ **따옴표 없이 사용 가능한 경우**
```sql
SELECT first_name firstName FROM employees;
```
📌 **설명**: `firstName`은 **공백이 없으며 대소문자 구분이 필요 없으므로** 따옴표 없이 사용 가능.

```sql
SELECT first_name AS firstName FROM employees;
```
📌 **설명**: `AS` 키워드를 명시해도 공백이 없으면 따옴표 없이 가능.

---

### 🚨 **`alias`에서 따옴표를 꼭 사용해야 하는 경우**
- **공백이 포함된 별칭**
- **예약어를 별칭으로 사용할 때**
- **숫자로 시작하는 별칭**
- **대소문자를 유지하고 싶을 때**

```sql
SELECT first_name AS "First Name" FROM employees;  -- 공백 포함
SELECT salary AS "Total$Salary" FROM employees;  -- 특수문자 포함
SELECT first_name AS "SELECT" FROM employees;  -- 예약어 사용
SELECT first_name AS "123Alias" FROM employees;  -- 숫자로 시작
```

---

## 🔹 **정리**
| 구분 | 사용 예 | 설명 |
|------|--------|------|
| **홑따옴표 `'`** | `'Hello'` | 문자열 값 |
| | `'2024-03-19'` | 날짜 값도 문자열로 취급됨 (`TO_DATE` 필요) |
| **쌍따옴표 `"`** | `"Full Name"` | 공백이 포함된 별칭 |
| | `"MyTable"` | 대소문자 구분이 필요한 경우 |
| | `"123Column"` | 숫자로 시작하는 컬럼명 |
| **별칭 (Alias)에서 생략 가능** | `first_name firstName` | 공백 없으면 가능 |
| | `salary AS TotalSalary` | 특수문자 없으면 가능 |
| **별칭 (Alias)에서 따옴표 필요** | `"Total Salary"` | 공백 포함 |
| | `"123Alias"` | 숫자로 시작 |
| | `"SELECT"` | 예약어 사용 |

✅ **즉, 홑따옴표는 문자열, 쌍따옴표는 대소문자/공백/숫자 포함된 식별자(컬럼명, 테이블명, 별칭)에서 사용하면 됨!** 🚀
 * */
 

SELECT * FROM employee;
SELECT * FROM job;
SELECT * FROM department;
SELECT * FROM SAL_GRADE;
SELECT * FROM location;


SELECT local_name 지역명, emp_id 아이디, emp_name 이름  
FROM EMPLOYEE 
JOIN department ON (department.dept_id = employee.dept_code) JOIN location  ON location_id = local_code JOIN job ON employee.job_code = job.job_code 
WHERE dept_code =  (SELECT dept_code FROM EMPLOYEE  WHERE emp_name='선동일' ) AND emp_name<>'선동일' ORDER BY 이름
;


/*
 * SELECT AREA_NAME 지역명, MEMBER_ID 아이디, MEMBER_NAME 이름, GRADE_NAME 등급명
FROM TB_MEMBER
JOIN TB_GRADE ON(GRADE = GRADE_CODE)
JOIN TB_AREA ON (AREA_CODE = AREA_CODE)
WHERE AREA_CODE = (
    SELECT AREA_CODE FROM TB_MEMBER
    WHERE 이름 = '김영희')
ORDER BY 이름 DESC;​
 * */
 


