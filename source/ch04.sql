/*
	4. 데이터 집계하기
	4.1 집계 함수(Aggregate Function)란
*/
-- 무엇? 통계적 계산을 간편하게 수행하도록 돕는 기능
-- 종류: MAX(), MIN(), COUNT(), SUM(), AVG()

-- 데이터를 가져와서 개발 코드에서 반복문 돌면서 직접 계산하는 것이 아니라
-- 데이터를 가져올 때 부터 계산된 값을 가져올 수 있음
-- 사용 예: 
-- MAX(): 특정 컬럼의 가장 큰 값(최대값) 반환
-- MIN(): 특정 컬럼의 가장 작은 값(최소값) 반환
-- COUNT(): 행(row, 레코드, 튜플)의 개수 반환(예: 학생 테이블에 총 학생이 몇 명이 있는지 셀 때)
-- SUM(): 합계 반환(예: 장바구니에 담긴 모든 아이템들의 가격 총합을 계산할 때)
-- AVG(): 평균 반환(예: 학생들의 수학 점수의 평균을 구할 때)

-- 실습 데이터 준비
-- 3장에서 연습한 맵도날드 DB를 활용
-- mapdonalds DB 진입
USE mapdonalds;

-- 가장 비싼 비거와 가장 싼 버거의 가격? 
-- 최대값, 최소값 구하기
SELECT MAX(price), MIN(price) 
FROM burgers;

-- (참고)
SELECT*, MAX(price), MIN(price) 
FROM burgers;
-- 이 둘은 동시에 쓸 수 없음, 왜냐하면 집계는 그룹 단위 연산이고 *는 행 단위 열람이기 때문
-- "어떤 행의 값을 보여줄지?" MYSQL이 결정할 수 없어서 에러를 뱉음
-- 집계 함수를 다른 일반 컬럼들과 함께 사용할 때는 GROUP BY가 필요

-- 해결 방법
-- 1: 집계되지 않은 일반 컬럼은 제거

-- 2: 그룹별로 집계(예: 카테고리별 - 소고기,치킨 등)
SELECT category, MAX(price), MIN(price)
FROM burgers
GROUP BY category;
-- category 별로 그룹을 묶고, 각 그룹에서 가격의 최대값/최소값을 구함 

-- 3: 서브쿼리를 활용하여 최대/최소 가격을 가진 버거 정보까지 보고 싶을 때
SELECT * 
FROM burgers
WHERE price = (SELECT MAX(price) FROM burgers) 
   OR price = (SELECT MIN(price) FROM burgers) ;  
-- 가격이 가장 높거나 가장 낮은 버거의 모든 정보를 가져옴

-- 무게가 240g을 초과하는 버거의 개수?
-- 레코드(row)의 개수 세기 
SELECT COUNT(*)
FROM burgers 
WHERE gram > 240;

-- 주의! 
-- COUNT() 함수는 입력에 따라 다른 결과를 만듦
-- COUNT(*): 전체 레코드의 수를 반환
-- COUNT(컬럼): 해당 컬럼이 null이 아닌 레코드의 수 

-- 테스트 
-- employees 테이블 생성
CREATE TABLE employees (
	id INTEGER,              -- 아이디(정수형 숫자)
	name VARCHAR(50),        -- 직원명(문자형: 최대 50자)
	department VARCHAR(200), -- 소속 부서(문자형: 최대 200자)
	PRIMARY KEY (id)         -- 기본키 지정: id
);

DESC employees;

-- employees 데이터 삽입
INSERT INTO employees (id, name, department)
VALUES
	(1, 'Alice', 'Sales'),
	(2, 'Bob', 'Marketing'),
	(3, 'Carol', NULL),
	(4, 'Dave', 'Marketing'),
	(5, 'Joseph', 'Sales');

-- 잘 들어갔는지 일단 확인
SELECT * FROM employees;

-- 모든 직원 수 세기 
SELECT COUNT(*)
FROM employees;

-- 부서가 있는 직원 수 세기
SELECT COUNT(department)
FROM employees;

-- 모든 종류의 버거를 다 사면 얼마? 
-- 합계 구하기 
SELECT SUM(price)
FROM burgers; 

-- 버거의 평균 가격은?
-- 평균 구하기 
SELECT AVG(price)
FROM burgers;
-- (참고) 계산 과정에서 NULL은 자동으로 제외함(NULL을 0으로 취급하지 않음)


-- Quiz
-- 1. burgers 테이블에 다음 쿼리를 실행했을 때, 
-- 결과 테이블 1~3에 들어갈 값을 쉼표로 구분하여 적으시오. (예: 123, 45, 67890)

-- burgers
-- id | name              | price  | gram  | kcal  | protein
-- ---------------------------------------------------------
-- 1    빅맨                 5300     223     583      27
-- 2    베이컨 틈메이러 디럭스   6200     242     545      27
-- 3    맨스파이시 상해 버거     5300     235     494      20
-- 4    슈비두밥 버거          6200     269     563      21
-- 5    더블 쿼터파운드 치즈     7700     275     770      50

-- SELECT MAX(kcal), MIN(protein), SUM(price)
-- FROM burgers
-- WHERE price < 6000;

-- 결과 테이블
-- ---------------------------------------
-- MAX(kcal)  | MIN(protein)  | SUM(price)
-- ---------------------------------------
-- ①          | ②             | ③

-- 정답: 583-20-10600원


/*
	4.2 집계 함수 실습: 은행 DB
*/
-- 데이터 셋 만들기: 은행 계좌 거래 내역
-- bank DB 생성 및 진입
CREATE DATABASE bank;
USE bank;

-- transactions 테이블 생성
CREATE TABLE transactions (
	id INTEGER, 			-- 아이디
	amount DECIMAL(12, 2), 	-- 거래 금액(12자릿수: 정수 10자리까지, 소수점 이하는 2자리까지 허용)
	msg VARCHAR(15), 		-- 거래처
	created_at DATETIME, 	-- 거래 일시
	PRIMARY KEY (id) 		-- 기본키 지정: id
);

-- transactions 데이터 삽입
INSERT INTO transactions (id, amount, msg, created_at)
VALUES
	(1, -24.20, 'Google', '2024-11-01 10:02:48'),
	(2, -36.30, 'Amazon', '2024-11-02 10:01:05'),
	(3, 557.13, 'Udemy', '2024-11-10 11:00:09'),
	(4, -684.04, 'Bank of America', '2024-11-15 17:30:16'),
	(5, 495.71, 'PayPal', '2024-11-26 10:30:20'),
	(6, 726.87, 'Google', '2024-11-26 10:31:04'),
	(7, 124.71, 'Amazon', '2024-11-26 10:32:02'),
	(8, -24.20, 'Google', '2024-12-01 10:00:21'),
	(9, -36.30, 'Amazon', '2024-12-02 10:03:43'),
	(10, 821.63, 'Udemy', '2024-12-10 11:01:19'),
	(11, -837.25, 'Bank of America', '2024-12-14 17:32:54'),
	(12, 695.96, 'PayPal', '2024-12-27 10:32:02'),
	(13, 947.20, 'Google', '2024-12-28 10:33:40'),
	(14, 231.97, 'Amazon', '2024-12-28 10:35:12'),
	(15, -24.20, 'Google', '2025-01-03 10:01:20'),
	(16, -36.30, 'Amazon', '2025-01-03 10:02:35'),
	(17, 1270.87, 'Udemy', '2025-01-10 11:03:55'),
	(18, -540.64, 'Bank of America', '2025-01-14 17:33:01'),
	(19, 732.33, 'PayPal', '2025-01-25 10:31:21'),
	(20, 1328.72, 'Google', '2025-01-26 10:32:45'),
	(21, 824.71, 'Amazon', '2025-01-27 10:33:01'),
	(22, 182.55, 'Coupang', '2025-01-27 10:33:25'),
	(23, -24.20, 'Google', '2025-02-03 10:02:23'),
	(24, -36.30, 'Amazon', '2025-02-03 10:02:34'),
	(25, -36.30, 'Notion', '2025-02-03 10:04:51'),
	(26, 1549.27, 'Udemy', '2025-02-14 11:00:01'),
	(27, -480.78, 'Bank of America', '2025-02-14 17:30:12');

-- 잘 들어갔나 확인
SELECT * FROM transactions;

-- 거래 금액의 총합 구하기 
SELECT SUM(amount)
FROM transactions;
-- 구글과 거래한 금액의 총합은? 
SELECT SUM(amount)
FROM transactions
WHERE msg = 'Google';

-- 거래 금액의 최대값/최소값 구하기 
SELECT 
	MAX(amount) AS `최대 거래금액`, 
	MIN(amount) AS `최소 거래금액`
FROM transactions; 

-- 페이팔과 거래한 금액의 최대값/최소값 구하기 
SELECT 
	MAX(amount) AS `최대 거래금액`, 
    MIN(amount) As `최소 거래금액`
FROM transactions
WHERE msg = 'paypal';

-- 전체 거래 횟수 세기 
SELECT COUNT(*)
FROM transactions;

-- 쿠팡 및 아마존과 거래한 횟수는? 
SELECT COUNT(*)
FROM transactions
WHERE msg = 'Coupang' OR msg = 'Amazon';

-- 위 커리를 IN 연산자(목록에 포함된 값 찾기)를 활용한 버전으로 다시 작성한다면? 
SELECT COUNT(*)
FROM transactions
WHERE msg IN ('Coupang', 'Amazon');
-- IN 의미: msg가 ( )안에 포함이 되어 있다면 TRUE
-- IN 연산자를 사용하면 훨씬 더 직관적이고 편리함
-- (참고) NOT IN: 목록에 포함되지 않은 값 찾기

-- 입금 금액의 평균 구하기
SELECT AVG(amount)
FROM transactions 
WHERE amount > 0;

-- 구글과 아마존에서 입금받은 금액의 평균은? 
SELECT AVG(amount)
FROM transactions
WHERE msg IN('Google','Amazon') AND amount > 0;