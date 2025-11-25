-- ====================================
-- Oracle SQL 기본 코드 - 초보자용
-- ====================================

-- 1. 테이블 생성하기 (CREATE TABLE)
-- 학생 정보를 저장할 테이블을 만듭니다
CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,        -- 학생 번호 (기본키, 중복 불가)
    name VARCHAR2(50) NOT NULL,           -- 이름 (필수 입력)
    age NUMBER,                           -- 나이
    email VARCHAR2(100),                  -- 이메일
    enrollment_date DATE DEFAULT SYSDATE  -- 등록일 (기본값: 현재 날짜)
);

-- 2. 데이터 입력하기 (INSERT)
-- 테이블에 새로운 데이터를 추가합니다
INSERT INTO students (student_id, name, age, email)
VALUES (1, '김철수', 20, 'kim@example.com');

INSERT INTO students (student_id, name, age, email)
VALUES (2, '이영희', 22, 'lee@example.com');

INSERT INTO students (student_id, name, age, email)
VALUES (3, '박민수', 21, 'park@example.com');

-- 여러 행을 한번에 입력
INSERT ALL
    INTO students VALUES (4, '최지은', 23, 'choi@example.com', SYSDATE)
    INTO students VALUES (5, '정수진', 19, 'jung@example.com', SYSDATE)
SELECT * FROM dual;

-- 변경사항을 확정합니다
COMMIT;

-- 3. 데이터 조회하기 (SELECT)
-- 모든 학생 정보 조회
SELECT * FROM students;

-- 특정 컬럼만 조회
SELECT name, age FROM students;

-- 조건에 맞는 데이터만 조회 (WHERE)
SELECT * FROM students WHERE age >= 21;

-- 이름에 '김'이 포함된 학생 조회
SELECT * FROM students WHERE name LIKE '%김%';

-- 정렬해서 조회 (ORDER BY)
SELECT * FROM students ORDER BY age DESC;  -- 나이 내림차순
SELECT * FROM students ORDER BY name ASC;  -- 이름 오름차순

-- 4. 데이터 수정하기 (UPDATE)
-- 학생 번호가 1인 학생의 나이를 변경
UPDATE students 
SET age = 21 
WHERE student_id = 1;

-- 여러 컬럼 동시 수정
UPDATE students 
SET age = 24, email = 'newemail@example.com'
WHERE student_id = 2;

COMMIT;

-- 5. 데이터 삭제하기 (DELETE)
-- 특정 학생 정보 삭제
DELETE FROM students WHERE student_id = 5;

-- 조건에 맞는 여러 행 삭제
DELETE FROM students WHERE age < 20;

COMMIT;

-- 6. 집계 함수 사용하기
-- 전체 학생 수 조회
SELECT COUNT(*) AS total_students FROM students;

-- 평균 나이 계산
SELECT AVG(age) AS average_age FROM students;

-- 최대/최소 나이
SELECT MAX(age) AS oldest, MIN(age) AS youngest FROM students;

-- 7. 그룹화하기 (GROUP BY)
-- 나이별 학생 수
SELECT age, COUNT(*) AS student_count 
FROM students 
GROUP BY age;

-- 나이별 학생 수가 2명 이상인 경우만 조회
SELECT age, COUNT(*) AS student_count 
FROM students 
GROUP BY age
HAVING COUNT(*) >= 2;

-- 8. 테이블 조인하기 (JOIN)
-- 먼저 과목 테이블 생성
CREATE TABLE courses (
    course_id NUMBER PRIMARY KEY,
    course_name VARCHAR2(100),
    student_id NUMBER,
    score NUMBER
);

-- 데이터 입력
INSERT INTO courses VALUES (1, '수학', 1, 85);
INSERT INTO courses VALUES (2, '영어', 1, 90);
INSERT INTO courses VALUES (3, '수학', 2, 78);
INSERT INTO courses VALUES (4, '영어', 3, 92);
COMMIT;

-- INNER JOIN: 학생과 과목 정보를 함께 조회
SELECT s.name, c.course_name, c.score
FROM students s
INNER JOIN courses c ON s.student_id = c.student_id;

-- LEFT JOIN: 모든 학생을 포함 (과목이 없어도 표시)
SELECT s.name, c.course_name, c.score
FROM students s
LEFT JOIN courses c ON s.student_id = c.student_id;

-- 9. 서브쿼리 사용하기
-- 평균 나이보다 많은 학생 조회
SELECT name, age 
FROM students 
WHERE age > (SELECT AVG(age) FROM students);

-- 점수가 가장 높은 과목 정보
SELECT * FROM courses 
WHERE score = (SELECT MAX(score) FROM courses);

-- 10. 뷰(VIEW) 생성하기
-- 자주 사용하는 쿼리를 뷰로 저장
CREATE VIEW student_summary AS
SELECT s.student_id, s.name, s.age, 
       COUNT(c.course_id) AS course_count,
       AVG(c.score) AS average_score
FROM students s
LEFT JOIN courses c ON s.student_id = c.student_id
GROUP BY s.student_id, s.name, s.age;

-- 뷰 조회
SELECT * FROM student_summary;

-- 11. 시퀀스(SEQUENCE) 생성
-- 자동 증가 번호를 생성합니다
CREATE SEQUENCE student_seq
START WITH 10
INCREMENT BY 1;

-- 시퀀스 사용
INSERT INTO students (student_id, name, age)
VALUES (student_seq.NEXTVAL, '강민호', 22);

-- 12. 인덱스(INDEX) 생성
-- 검색 속도를 빠르게 합니다
CREATE INDEX idx_student_name ON students(name);

-- 13. 트랜잭션 제어
-- 작업 시작
INSERT INTO students VALUES (20, '임시학생', 20, 'temp@example.com', SYSDATE);

-- 작업 취소
ROLLBACK;

-- 작업 확정
INSERT INTO students VALUES (21, '신규학생', 21, 'new@example.com', SYSDATE);
COMMIT;

-- 14. 제약조건 추가
-- 기존 테이블에 제약조건 추가
ALTER TABLE students 
ADD CONSTRAINT chk_age CHECK (age >= 18 AND age <= 100);

-- 15. 컬럼 추가/수정/삭제
-- 컬럼 추가
ALTER TABLE students ADD phone VARCHAR2(20);

-- 컬럼 수정
ALTER TABLE students MODIFY email VARCHAR2(150);

-- 컬럼 삭제
ALTER TABLE students DROP COLUMN phone;

-- 16. 날짜 함수
-- 현재 날짜와 시간
SELECT SYSDATE FROM dual;

-- 날짜 계산
SELECT SYSDATE + 7 AS next_week FROM dual;  -- 7일 후
SELECT SYSDATE - 30 AS last_month FROM dual; -- 30일 전

-- 날짜 포맷 변경
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual;
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') FROM dual;

-- 17. 문자열 함수
-- 대소문자 변환
SELECT UPPER('hello') FROM dual;  -- HELLO
SELECT LOWER('WORLD') FROM dual;  -- world

-- 문자열 연결
SELECT name || ' (' || age || '세)' AS info FROM students;

-- 문자열 자르기
SELECT SUBSTR('Oracle Database', 1, 6) FROM dual;  -- Oracle

-- 18. 숫자 함수
-- 반올림
SELECT ROUND(85.7) FROM dual;  -- 86

-- 올림/내림
SELECT CEIL(85.1) FROM dual;   -- 86
SELECT FLOOR(85.9) FROM dual;  -- 85

-- 19. NULL 처리
-- NULL 값을 다른 값으로 대체
SELECT name, NVL(email, '이메일 없음') AS email FROM students;

-- NULL이 아닌 경우만 조회
SELECT * FROM students WHERE email IS NOT NULL;

-- 20. CASE 문 (조건부 표현)
SELECT name, age,
    CASE 
        WHEN age < 20 THEN '10대'
        WHEN age < 30 THEN '20대'
        ELSE '30대 이상'
    END AS age_group
FROM students;

-- ====================================
-- 데이터 정리 (실습 후 정리용)
-- ====================================
-- DROP TABLE students CASCADE CONSTRAINTS;
-- DROP TABLE courses CASCADE CONSTRAINTS;
-- DROP SEQUENCE student_seq;
-- DROP VIEW student_summary;

-- ====================================
-- 연습 과제:
-- 1. 자신만의 테이블을 만들어보세요 (예: 도서, 상품 등)
-- 2. 데이터를 5개 이상 입력해보세요
-- 3. 다양한 조건으로 조회해보세요
-- 4. UPDATE와 DELETE를 연습해보세요
-- ====================================
