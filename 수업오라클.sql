-------------------------------------------------------
-- [ DDL (Data Definition Language) - 데이터 정의어 ]
-- DDL은 테이블의 구조를 생성, 수정, 삭제하는 명령어입니다

-- 테이블 생성 (CREATE TABLE)
-- student 테이블을 만듭니다 (학생 정보 저장용)
create table student (
sno number(4) primary key,    -- 학생번호: 숫자 4자리, 기본키(중복불가, null불가)
name varchar2(100),            -- 이름: 최대 100바이트 문자열 (한글 약 33자)
kor number(3),                 -- 국어 점수: 숫자 3자리 (0~999)
eng number(3),                 -- 영어 점수: 숫자 3자리
math number(3),                -- 수학 점수: 숫자 3자리
total number(3),               -- 총점: 숫자 3자리
avg number(5,2)                -- 평균: 정수 3자리, 소수점 2자리 (예: 100.00)
);

-- 테이블 삭제 (DROP TABLE)
-- member 테이블을 완전히 삭제합니다 (데이터와 구조 모두 삭제)
drop table member;

-- 테이블 변경 (ALTER TABLE)
-- 이미 생성된 테이블의 구조를 수정할 때 사용합니다

-- 컬럼 추가 (ALTER ADD)
-- student 테이블에 sdate(날짜) 컬럼을 추가합니다
alter table student add sdate date;

-- 컬럼 삭제 (ALTER DROP)
-- student 테이블에서 sdate 컬럼을 삭제합니다
alter table student drop column sdate;

-- 컬럼 수정 (ALTER MODIFY)
-- 기존 컬럼의 데이터 타입이나 크기를 변경합니다
alter table student modify name varchar2(1000);  -- name 컬럼 크기를 1000으로 확장
alter table student modify name varchar2(90);    -- name 컬럼 크기를 90으로 축소
alter table student modify name varchar2(5);     -- 주의! 입력된 데이터보다 작게는 변경 불가

-- [ 테이블을 생성하면서 데이터 가져오기 ]

-- 방법1: 테이블 복사 (구조 + 데이터 모두 복사)
-- student 테이블의 모든 구조와 데이터를 student2로 복사합니다
create table student2 as select * from student;

-- 방법2: 테이블 구조만 복사 (데이터는 제외)
-- where 1=2는 항상 거짓이므로 데이터는 복사되지 않고 구조만 복사됩니다
create table student3 as select * from student where 1=2;

-- [ 이미 존재하는 테이블에 데이터 가져오기 ]

-- 방법1: 컬럼이 동일한 경우
-- student의 모든 데이터를 student2에 추가합니다
insert into student2 select * from student;

-- 방법2: 컬럼 개수나 구조가 다른 경우
-- 필요한 컬럼만 지정해서 데이터를 가져옵니다
insert into student3(sno,name,kor,eng,math,sdate) 
select sno,name,kor,eng,math,sdate from student;



------------------------------------------------------------

-- [ DML (Data Manipulation Language) - 데이터 조작어 ]
-- DML은 테이블의 데이터를 조회, 추가, 수정, 삭제하는 명령어입니다
-- SELECT(조회), INSERT(추가), UPDATE(수정), DELETE(삭제)

-- 데이터 추가 (INSERT)
-- 사용법1: insert into 테이블명 (컬럼명들) values (값들)
-- 사용법2: insert into 테이블명 values(모든 컬럼의 값들)
-- 중요! commit을 해야 임시저장이 실제 저장으로 확정됩니다

insert into student (sno,name,kor,eng,math,total,avg)
values (
1,'홍길동',100,100,100,300,100  -- 학번1, 이름, 국어, 영어, 수학, 총점, 평균
);

-- 데이터 조회 (SELECT)
-- 사용법: select 컬럼명 from 테이블명
-- *는 모든 컬럼을 의미합니다
select sno,name,kor,eng,math,total,avg from student;  -- 모든 컬럼 조회
select sno,name,total from student;                    -- 특정 컬럼만 조회
select * from student;                                 -- 모든 컬럼 조회(간편한 방법)

-- 데이터 수정 (UPDATE)
-- 사용법: update 테이블명 set 컬럼=새값 where 조건
-- 주의! where절이 없으면 모든 행이 수정됩니다
update student set name = '홍길영' where sno=1;  -- 학번이 1인 학생의 이름을 '홍길영'으로 변경
update student set name='홍길동' where sno=1;    -- 다시 '홍길동'으로 변경

-- 데이터 삭제 (DELETE)
-- 사용법: delete from 테이블명 where 조건
-- 주의! where절이 없으면 모든 데이터가 삭제됩니다
delete student where sno = 3;  -- 학번이 3인 학생만 삭제
delete student;                -- 모든 학생 데이터 삭제 (위험!)

-----------------------------------

-- employees 테이블에서 사원번호와 사원이름만 조회
select employee_id,emp_name from employees;

-- 사원번호가 200보다 큰 사원만 조회 (조건 검색)
select * from employees where employee_id>200;

-- 시스템 관리 명령어
-- 현재 데이터베이스에 존재하는 모든 테이블 목록 확인
select * from tab;

-- 테이블 구조 확인 (describe의 약자)
-- 컬럼명, 데이터 타입, NULL 허용 여부 등을 보여줍니다
desc student;

--------------------------------
-- 날짜 데이터 다루기
select * from student;

-- SYSDATE: 오라클에서 현재 날짜와 시간을 반환하는 함수
-- (참고: MySQL에서는 now() 함수를 사용합니다)

-- 모든 학생의 날짜를 특정 날짜로 설정
update student set sdate = '2025-01-01';

-- 모든 학생의 날짜를 현재 날짜로 설정
update student set sdate = sysdate;

-- 트랜잭션 제어 명령어
commit;    -- 변경사항을 실제 데이터베이스에 저장 (확정)
rollback;  -- 마지막 commit 이후의 변경사항을 모두 취소 (되돌리기)

-- DISTINCT: 중복 제거
select * from employees;                                        -- 모든 사원 정보 조회
select manager_id from employees;                               -- 관리자 ID 조회 (중복 포함)
select distinct manager_id from employees;                      -- 관리자 ID 조회 (중복 제거)
select distinct manager_id from employees order by manager_id;  -- 관리자 ID 중복 제거 후 정렬

-- 실습 문제: employees 테이블에서 사원번호, 사원이름, 부서번호를 출력하시오
select * from employees;                                  -- 먼저 전체 데이터 확인
select employee_id,emp_name,department_id from employees; -- 필요한 컬럼만 선택해서 조회

-- student 테이블 실습 문제
select * from student;  -- 먼저 현재 데이터 확인

-- 문제1: 1번 학생의 이름을 '홍길동'에서 '홍길순'으로 변경
update student set name='홍길순' where sno=1;

-- 문제2: 모든 학생의 날짜를 2025-10-10으로 변경
update student set sdate='2025-10-10';

-- 문제3: 3번 학생 데이터 삭제
delete student where sno=3;

-- 문제4: 새로운 학생 정보 입력 (학번4, 이름 김구, 각 과목 70점, 총점 210, 평균 70, 현재날짜)
insert into student values(
4,'김구',70,70,70,210,70,sysdate
);

-- 모든 변경사항을 데이터베이스에 확정
commit;

-----------------------------------------------
-- 산술 연산자 활용
-- Oracle에서 지원하는 산술 연산자: + (더하기), - (빼기), * (곱하기), / (나누기)

-- 날짜 계산: 날짜에 숫자를 더하면 그 일수만큼 미래 날짜가 됩니다
select sdate, sdate+100 from student;  -- 등록일로부터 100일 후 날짜 계산

select * from student;

-- 실습1: 1번 학생의 국어 점수를 90점으로 수정
update student set kor = 90 where sno=1;

-- 실습2: 1번 학생의 총점과 평균을 재계산
-- 총점 = 국어 + 영어 + 수학
-- 평균 = (국어 + 영어 + 수학) / 3
update student set total=kor+eng+math, avg=(kor+eng+math)/3 where sno=1;

commit;    -- 변경사항 저장
rollback;  -- 변경사항 취소 (commit 이전 상태로 되돌림)


select * from employees;

-- 컬럼 별칭(ALIAS) 사용하기
-- AS 키워드로 컬럼에 별칭을 붙일 수 있습니다 (AS는 생략 가능)
-- 월급을 달러에서 원화로 환산 (1달러 = 1474원 가정)

select emp_name,                        -- 사원 이름
       salary,                          -- 월급 (달러)
       salary*1474 as k_salary,         -- 월급 (원화) - 'as'로 별칭 지정
       salary*1474*12 year_k_salary     -- 연봉 (원화) - 'as' 생략 가능
from employees;



-- 테이블 데이터 관리
delete student2;  -- student2 테이블의 모든 데이터 삭제
commit;           -- 삭제 확정

-- 테이블 구조 수정
alter table student3 drop column total;  -- total 컬럼 삭제
alter table student3 drop column avg;    -- avg 컬럼 삭제

select * from student2;  -- student2 데이터 확인
select * from student3;  -- student3 데이터 확인

--------------------------------------------------------------
-- student3 테이블 구조 확인
desc student3;

-- 컬럼 추가하기
alter table student3 add total number(3);      -- total 컬럼 추가 (숫자 3자리)
alter table student3 add avg number(5,2);      -- avg 컬럼 추가 (전체 5자리, 소수점 2자리)

-- total(총점)과 avg(평균) 데이터를 계산해서 업데이트
-- 모든 행에 대해 계산 수행 (where절 없음)
update student3 set total=kor+eng+math, avg=(kor+eng+math)/3;

select * from student3;  -- 업데이트 결과 확인

select * from employees;

-- NULL 값 처리하기
-- NULL + 숫자 = NULL (NULL과의 연산은 결과도 NULL이 됩니다)
-- NVL(컬럼명, 대체값): NULL 값을 다른 값으로 대체하는 함수

-- commission_pct 컬럼 확인 (보너스 비율, NULL 값 포함)
select commission_pct from employees;

-- 실제 월급 계산: 기본급 + (기본급 * 보너스비율)
-- NVL을 사용해서 NULL인 보너스를 0으로 처리
select emp_name,                                      -- 사원 이름
       salary,                                        -- 기본 월급
       nvl(commission_pct,0),                         -- 보너스 비율 (NULL이면 0)
       salary + (salary*nvl(commission_pct,0)) real_salary  -- 실제 월급
from employees;

-- 실제 연봉 계산 문제
-- 실제 연봉 = (기본급 + 보너스) * 12개월
select (salary + (salary*nvl(commission_pct,0))) * 12 from employees; 


select * from employees;

-- 부서번호(department_id) 중복 제거해서 조회
-- DISTINCT는 중복된 값을 하나만 표시합니다
select distinct department_id from employees;

-- 실습 문제: job_id(직급) 중복 제거해서 출력하시오
select distinct job_id from employees;

-- jobs 테이블 (직급 정보 테이블)
select * from jobs;

-------------------------------------------------------
-- 회원 테이블 생성하기
-- zmember 테이블 - 다양한 데이터 타입 활용 예제
-- varchar2: 가변 길이 문자열, char: 고정 길이 문자열, number: 숫자, date: 날짜
create table zmember (
 id varchar2(100),          -- 아이디 (가변 길이)
 pw varchar2(100),          -- 비밀번호
 name varchar2(100),        -- 이름
 email varchar2(50),        -- 이메일
 email_check number(1),     -- 이메일 인증 여부 (0 또는 1)
 zonecode number(5),        -- 우편번호 (5자리 숫자)
 address varchar2(100),     -- 주소
 phone char(13),            -- 휴대폰 번호 (고정 길이, 예: 010-1111-1111)
 phone_check number(1),     -- 휴대폰 인증 여부
 tel char(13),              -- 일반 전화번호
 birth date,                -- 생년월일 (날짜 타입)
 birth_check number(1),     -- 생일 공개 여부
 business number(1)         -- 사업자 여부
);

-- zonecode 컬럼 타입 변경
-- number에서 char로 변경 (우편번호에 0으로 시작하는 경우 대비)
-- 예: 00000 -> number로 저장하면 0이 되지만, char로 저장하면 00000 유지
alter table zmember modify zonecode char(5);

-- 테이블 구조 확인
desc zmember;

-- 회원 데이터 입력
-- char 타입의 경우 001 -> 1로 자동 변환되므로 주의
insert into zmember values (
'aaa','1111','홍길동','aaa@naver.com',1,'00000','서울 강남구','010-1111-1111',0,
'02-1111-1111','2000-01-01',1,0
);

-- 입력한 데이터 확인
select * from zmember;

-- 데이터 저장 확정
commit;


-- 학생 정보 테이블 실습
-- seoul_stu 테이블 작성 (고등학생 정보 저장용)
-- 필요한 컬럼: 학생고유번호, 이름, 학년, 학반, 번호, 전화, 주소, 입학일
create table seoul_stu (
stuno char(5),          -- 학생 고유번호 (예: s0001)
name varchar2(100),     -- 이름
brith date,             -- 생년월일
phone char(13),         -- 전화번호
address varchar2(50),   -- 주소
enroll_date date,       -- 입학일
write_date date         -- 등록일
);

-- 학생 데이터 입력
insert into seoul_stu values(
's0001','홍길동','2000-01-01','010-1111-1111','서울',sysdate,sysdate
);

-- 테이블 삭제 (다시 만들기 위해)
drop table seoul_stu;

-- 학년 정보 업데이트 (이미 삭제된 테이블이므로 실행 안됨)
update seoul_stu set grade=3,grade_no=3,class_no=3 where stuno='s0001';

select * from seoul_stu;
commit;

-- 학년 정보를 별도 테이블로 관리하기
-- seoul_grade 테이블 생성 (학년, 학반, 반번호 정보)
create table seoul_grade (
stuno char(5),        -- 학생 고유번호
grade number(1),      -- 학년 (1, 2, 3)
grade_no number(2),   -- 학반 (몇 반)
class_no number(3)    -- 반 번호 (반에서 몇 번)
);

-- 같은 학생의 여러 학년 정보 입력 (1학년 때, 2학년 때, 3학년 때)
insert into seoul_grade values(
's0001',1,1,1  -- s0001 학생의 1학년 정보
);
insert into seoul_grade values(
's0001',2,2,2  -- s0001 학생의 2학년 정보
);
insert into seoul_grade values(
's0001',3,3,3  -- s0001 학생의 3학년 정보
);

commit;

-- 데이터 확인
select * from seoul_grade;
select * from seoul_stu;

-- 두 테이블 조인하기 (JOIN)
-- seoul_stu와 seoul_grade를 학생번호(stuno)로 연결해서 조회
-- 학생의 기본 정보 + 학년 정보를 함께 출력
select seoul_stu.stuno,       -- 학생번호
       name,                  -- 이름
       brith,                 -- 생년월일
       phone,                 -- 전화번호
       address,               -- 주소
       enroll_date,           -- 입학일
       write_date,            -- 등록일
       grade,                 -- 학년
       grade_no,              -- 학반
       class_no               -- 반번호
from seoul_stu, seoul_grade   -- 두 테이블을 사용
where seoul_stu.stuno = seoul_grade.stuno;  -- 같은 학생번호끼리 연결

------------------------------------------------------------------------

-- WHERE절: 조건절 사용하기
-- 비교 연산자: = (같음), != 또는 <> (다름), >= (크거나 같음), <= (작거나 같음), > (큼), < (작음)
-- 논리 연산자: AND (그리고), OR (또는)
-- 사용법: where 컬럼명 연산자 비교값

-- OR 연산자: 둘 중 하나라도 만족하면 조회
select * from employees where department_id = 30 or department_id = 50;

-- IN 연산자: 여러 값 중 하나와 일치하면 조회 (OR의 간편한 표현)
select * from employees where department_id in (30, 50);

-- AND 연산자: 두 조건을 모두 만족해야 조회
select * from employees where department_id = 30 and manager_id = 100;

-- 같지 않음 (<> 또는 !=)
select * from employees where department_id <> 30;

-- 크다, 작다
select * from employees where department_id > 30;
select * from employees where department_id < 30;

-- 실습 문제1: 월급이 5000 이상인 사원을 출력하시오
select * from employees where salary >= 5000;

-- 월급이 정확히 6000인 사원
select * from employees where salary = 6000;

-- 월급이 5000, 6000, 7000인 사원 (OR 사용)
select * from employees where salary = 5000 or salary=6000 or salary=7000;

-- 월급이 5000, 6000, 7000인 사원 (IN 사용 - 더 간단!)
select * from employees where salary in (5000,6000,7000);

-- 월급이 5000, 6000, 7000이 아닌 사원 (잘못된 예시 - 항상 참)
select * from employees where salary != 5000 or salary!=6000 or salary!=7000;

-- 월급이 5000, 6000, 7000이 아닌 사원 (올바른 방법: NOT IN)
select * from employees where salary not in (5000,6000,7000);

-- 계산된 값으로 조건 검색
-- 연봉이 150,000 이상인 사원 (월급 * 12)
select emp_name, salary, salary*12 from employees
where salary*12 >= 150000;

-- 연산자 우선순위 참고
-- 괄호() > 곱셈/나눗셈 > 덧셈/뺄셈 > 비교연산자 > AND > OR
-- 예시:
-- (10+5)*10/3 = 15*10/3 = 50
-- 10+5*10/3 = 10+50/3 = 10+16.67 = 26.67
-- ((10+3)>(5-2)) or ((10*2)/3)+1-3  -> (13>3) or (20/3)+1-3 -> true or ...

select * from employees;

-- 실습 문제: 월급이 4000 이하인 사원의 사원번호, 이름, 월급 조회
select employee_id, emp_name, salary from employees 
where salary <= 4000;

-- 날짜 비교 연산자
-- 날짜도 >, <, <=, >=, =, != 연산자 사용 가능
select hire_date from employees;

-- 입사일에 100일을 더한 날짜가 2005/01/01 이후인 사원
select hire_date from employees
where hire_date+100 >= '2005/01/01';

-- hire_date와 hire_date+100일 비교
select hire_date, hire_date+100 from employees;

-- 입사일이 2007년 6월 1일 이후인 사원의 이메일과 입사일 조회
select email, hire_date from employees
where hire_date >= '2007-06-01';

-- BETWEEN 연산자: 범위 검색
-- 월급이 7000보다 크고 7500보다 작은 사원 (AND 사용)
select salary from employees
where salary > 7000 and salary < 7500;

-- 월급이 7000 이상 7500 이하인 사원 (BETWEEN 사용)
-- BETWEEN은 경계값을 포함합니다 (>= and <=)
select salary from employees
where salary between 7000 and 7500;

-- 월급이 7000 미만이거나 7500 초과인 사원 (OR 사용)
select salary from employees
where salary < 7000 or salary > 7500;

-- NOT BETWEEN: 범위 밖의 값
select salary from employees
where salary not between 7000 and 7500;

select hire_date from employees;

-- 실습 문제: 2005/01/01 ~ 2007/12/31 사이에 입사한 사원의
-- 사원번호, 사원이름, 부서번호, 입사일을 출력하시오

-- 방법1: AND 연산자 사용
select employee_id, emp_name, department_id, hire_date from employees
where hire_date >= '2005/01/01' and hire_date <= '2007/12/31';

-- 방법2: BETWEEN 연산자 사용 (더 간단!)
select employee_id, emp_name, department_id, hire_date from employees
where hire_date between '2005/01/01' and '2007/12/31';


-- 실습 과제: 상품관리 테이블을 작성하시오.
-- (여기에 직접 작성해보세요!)


-- seoul_stu 테이블 삭제 (새로 시작하기 위해)
drop table seoul_stu;

---------------------------------------------------
-- 대학교 학생 정보 시스템 만들기

-- 대학생 테이블 생성
create table uni_stu (
stuno char(5),              -- 학생 고유번호
name varchar2(100),         -- 이름
major_code varchar2(100),   -- 전공 코드
major_name varchar2(100),   -- 전공 이름
major_date date,            -- 전공 개설일
college varchar2(100)       -- 소속 대학
);

-- 학생 데이터 입력 (모두 같은 전공)
insert into uni_stu values(
's0001','홍길동','com','컴퓨터공학과','2000-01-01','공과대학'
);
insert into uni_stu values(
's0002','유관순','com','컴퓨터공학과','2000-01-01','공과대학'
);
insert into uni_stu values(
's0003','이순신','com','컴퓨터공학과','2000-01-01','공과대학'
);
insert into uni_stu values(
's0004','강감찬','com','컴퓨터공학과','2000-01-01','공과대학'
);
insert into uni_stu values(
's0005','김구','com','컴퓨터공학과','2000-01-01','공과대학'
);
insert into uni_stu values(
's0006','김유신','math','수학과','2002-02-02','인문대학'
);

select * from uni_stu;

-- 전공 정보 테이블 생성 (정규화를 위해 별도 관리)
create table major_collect (
major_code varchar2(100),   -- 전공 코드 (기본키로 사용 가능)
major_name varchar2(100),   -- 전공 이름
major_date date,            -- 전공 개설일
college varchar2(100)       -- 소속 대학
);

-- 전공 정보 입력
insert into major_collect values(
'com','컴퓨터공학과','2000-01-01','공과대학'
);
insert into major_collect values(
'math','수학과','2002-02-02','인문대학'
);
commit;

select * from major_collect;
select * from uni_stu;

-- 두 테이블 조인해서 학생과 전공 정보 함께 조회
-- major_code를 기준으로 연결
select stuno,                    -- 학생번호
       name,                     -- 학생이름
       uni_stu.major_code,       -- 전공코드 (어느 테이블 것인지 명시)
       major_name,               -- 전공명
       major_date,               -- 전공개설일
       college                   -- 소속대학
from uni_stu, major_collect      -- 두 테이블 사용
where uni_stu.major_code = major_collect.major_code;  -- 전공코드로 연결


-- 데이터 정규화: 중복 데이터 제거
-- uni_stu 테이블에서 중복되는 전공 정보 컬럼 삭제
alter table uni_stu drop column major_name;   -- 전공명 삭제
alter table uni_stu drop column major_date;   -- 전공개설일 삭제
alter table uni_stu drop column college;      -- 소속대학 삭제