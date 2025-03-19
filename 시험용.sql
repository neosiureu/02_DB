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
  
 * */



