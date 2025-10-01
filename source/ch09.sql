/* 
	9. 서브쿼리 활용하기 
    9.1 서브쿼리란
*/
-- 왜 필요할까?
-- JOIN 만으로는 한 번에 답하기 어려운, 여러 단계의 질의를 거쳐야 하는 문제들도 있음 
-- 예: 쇼핑몰에서 판매하는 상품들의 평균 가격보다 비싼 상품은? 
-- 두 단계로 나누어 생각할 수 있음 
-- 1단계: 전체 상품의 평균 가격을 구함 => AVG()사용
-- 2단계: 그 평균 가격보다 비싼 상품을 찾음 => WHERE절 사용

-- 위 두 단계를 하나의 작업 단위로 묶고 싶을 때 사용하는 기술이 바로 서브쿼리

-- 무엇? 하나의 쿼리문 안에 포함된 또 다른 SELECT 쿼리
-- 안쪽 서브쿼리 실행 결과를 받아 바깥쪽 메인쿼리가 실행됨 

-- 서브쿼리 실습: 다음 학생 중 성적이 평균보다 높은 학생은?
-- students
-- ----------------------
-- id  | name    | score
-- ----------------------
-- 1   | 엘리스    | 85
-- 2   | 밥       | 78
-- 3   | 찰리     | 92
-- 4   | 데이브    | 65
-- 5   | 이브     | 88

-- sub_query DB 생성 및 진입
CREATE DATABASE sub_query;
USE sub_query;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	name VARCHAR(30), 			-- 이름
	score INTEGER, 				-- 성적
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (name, score)
VALUES
	('엘리스', 85),
	('밥', 78),
	('찰리', 92),
	('데이브', 65),
	('이브', 88);
    
-- 확인
SELECT DATABASE();
SHOW TABLES;
SELECT * FROM students;

-- 평균 점수보다 더 높은 점수를 받은 학생 조회
SELECT *
FROM students
WHERE score > (평균_점수); -- () 괄호 안이 서브쿼리로 작성할 부분

-- 평균 점수 계산
SELECT AVG(score) 
FROM students;

-- 위 쿼리를 서브쿼리로 사용 
-- 메인쿼리
SELECT *
FROM students
WHERE score > (
	-- 서브쿼리: 평균 점수 계산
    SELECT AVG(score) 
    FROM students
);

-- 서브쿼리의 특징 5가지 
-- 1) 중첩 구조 
-- 메인쿼리 내부에 중첩하여 작성
SELECT 컬럼명1, 컬럼명2, ... 
FROM 테이블명 
WHERE 컬럼명 연산자(
	서브쿼리
);

-- 2) 메인쿼리와는 독립적으로 실행됨
-- 서브쿼리 우선 실행 후 
-- 그 결과를 받아 메인쿼리가 수행됨 

-- 3) 다양한 위치에서 사용 가능 
-- SELECT 
-- FROM/JOIN 
-- WHERE/HAVING 등

-- 4) 단일 값 또는 다중 값을 반환
-- 단일 값 서브쿼리: 특정 값을 반환하는 서브쿼리(1행 1열)
-- 다중 값 서브쿼리: 여러 레코드를 반환하는 서브쿼리 (N행 M열) 
-- 가상의 테이블로 쓰이거나 IN, ANY, ALL, EXISTS 연산자와 함께 필터링에 사용됨

-- 5) 복잡하고 정교한 데이터 분석에 유용
-- 필터링 조건 추출  =>  WHERE/HAVING 절에서 사용
-- 데이터 집계 결과 추출 => FROM/JOIN 절에서 사용 

-- Quiz
-- 1. 다음 설명이 맞으면 O, 틀리면 X를 표시하세요.
-- ① 서브쿼리는 메인쿼리 내부에 중첩해 작성한다. (  )
-- ② 서브쿼리는 다양한 위치에서 사용할 수 있다. (  )
-- ③ 서브쿼리는 단일 값만 반환한다. (  )

-- 정답: O,O,X

/*
	9.2 다양한 위치에서 서브쿼리 
*/ 
-- 8장 마켓 DB를 기반으로 다양한 서브쿼라를 연습!
use market;

-- 1. SELECT 절에서의 서브쿼리
-- 1X1 단입값만 반환하는 서브쿼리(스칼라 서브쿼리)만 사용 가능 
-- 이유? 여러 행 또는 여러 칼럼을 반환하면 SQL이 어떤 값을 선택해야 할 지 몰라 에러 발생

-- 모든 결제 정보에 대한 평균 결제 금액과의 차이는?
SELECT 
 payment_type AS '결제 유형',
 amount AS '결제 금액',
 amount - (평균결제금액) AS '평균 결제 금액과의 차이'
FROM payments;

-- 평균 결제 금액 
SELECT AVG(amount) 
FROM payments;

-- ()괄호 안에 넣기
SELECT 
 payment_type AS '결제 유형',
 amount AS '결제 금액',
 amount - (SELECT AVG(amount) FROM payments) AS '평균 결제 금액과의 차이'
FROM payments;

-- 잘못된 사용 예
SELECT 
 payment_type AS '결제 유형',
 amount AS '결제 금액',
 amount - (SELECT AVG(amount), '123' FROM payments) AS '평균 결제 금액과의 차이'
FROM payments;
-- Error Code: 1241. Operand should contain 1 column(s)

SELECT 
 payment_type AS '결제 유형',
 amount AS '결제 금액',
 amount - (SELECT amount FROM payments) AS '평균 결제 금액과의 차이'
FROM payments;
-- Error Code: 1242. Subquery returns more than 1 row

-- 2. FROM 절에서의 서브쿼리
-- NxM 반환하는 행과 컬럼의 개수에 제한이 없음
-- 서브쿼리를 이용해 가상의 테이블(view)을 만들어 사용하기에 테이블 서브쿼리라고 부름 
-- 단, 서브쿼리에 별칭 지정 필수 

-- 1회 주문시 평균 상품 개수는? (장바구니 상품 포함)
-- 일단 먼저 1회 주문 당 상품 개수 집계 구하기
-- 주문별(order_id)로 그룹화 -> count 집계: SUM() -> 재집계: AVG()
SELECT 
	order_id, 
    SUM(count) AS total_count
FROM order_details 
GROUP BY order_id; -- 서브쿼리로 사용

-- 메인쿼리: 1회 주문시 평균 상품 개수 집계
SELECT AVG(sub.total_count) AS '1회 주문시 평균 상품 개수'
FROM (
	-- 서브쿼리
	SELECT 
	order_id, 
    SUM(count) AS total_count  -- 집계 함수 결과에 별칭 필수 (컬럼명이 아니라 계산된 값을 반환하기 때문에)
	FROM order_details 
	GROUP BY order_id
) AS sub; -- 별칭 필수(AS는 생략 가능)

-- 3. JOIN 절에서의 서브쿼리
-- NxM 반환하는 행과 컬럼의 개수에 제한이 없음
-- 서브쿼리를 이용해 가상의 테이블(view)을 만들어 사용하기에 테이블 서브쿼리라고 부름 
-- 단, 서브쿼리에 별칭 지정 필수 

-- 상품별 주문 개수를 '배송 완료'와 '장바구니'에 상관없이 상품명과 주문 개수를 조회한다면?
-- 일단 먼저 상품 아이디별 주문 개수 집계 구하기 
SELECT 
	product_id, 
    SUM(count) AS total_count
FROM order_details 
GROUP BY product_id; -- 서브쿼리로 이용

-- 메인쿼리: 상품명을 포함한 상품별 주문 개수 집계
SELECT  
	p.name AS 상품명,
    sub.total_count AS '주문 개수' -- 서브쿼리에서 구한 데이터를 가져다 씀
FROM products p
JOIN (
	-- 서브 쿼리
	SELECT 
		product_id, 
		SUM(count) AS total_count
	FROM order_details 
	GROUP BY product_id
) AS sub ON p.id = sub.product_id;

-- (참고) 또 다른 방법: 일단 필요한 테이블을 붙여놓고 그룹화 및 집계

SELECT 
	p.name AS 상품명, -- GROUP BY의 p.id가 와야하지만 편의상 봐주는거다
    SUM(count) AS '주문 개수'
FROM products p
JOIN order_details od ON p.id = od.product_id
GROUP BY p.id;

-- 4.WHERE 절에서의 서브쿼리 
-- 1X1, Nx1 반환하는 서브쿼리만 사용가능 
-- 필터링 조건으로 값 또는 값의 목록을 사용하기 때문

-- WHERE price > 5000; -- 1x1
-- WHERE category IN ('도서','전자기기','식품); -- Nx1

-- 평균 가격보다 비싼 상품을 조회하려면? 
SELECT *
FROM products
WHERE price>(
	-- 서브쿼리:평균 가격
	SELECT AVG(price) AS '평균 가격'
	FROM products
);

-- 평균 가격을 서브쿼리로 구해서 넣으면 됨
SELECT AVG(price) AS '평균 가격'
FROM products;

-- 5.HAVING 절에서의 서브쿼리 
-- 1X1, Nx1 반환하는 서브쿼리만 사용가능 
-- 필터링 조건으로 값 또는 값의 목록을 사용하기 때문

-- 크림 치즈보다 매출이 높은 상품은? (장바구니 상품 포함)
-- 상품X주문상세 조인해서 -> 상품명으로 그룹화 -> 상품별로 매출을 집계 
-- 메인쿼리: 전체 상품의 매출을 조회 
SELECT 
	p.name AS 상품명, 
    SUM(price*count) AS 매출
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY p.name; 

-- => 크림 치즈보다 매출이 높은 상품 조회로 변경
SELECT 
	p.name AS 상품명, 
    SUM(price*count) AS 매출
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY p.name
HAVING SUM(price*count) > (
	-- 서브쿼리: 크림 치즈의 매출(=8720)
    SELECT SUM(price*count) 
    FROM order_details od
	JOIN products p ON od.product_id = p.id
    WHERE name='크림 치즈' 
); 

-- Quiz
-- 2. 다음 설명이 맞으면 O, 틀리면 X를 표시하세요.
-- ① SELECT 절의 서브쿼리는 단일 값만 반환해야 한다. ( o )
-- ② FROM 절과 J0IN 절의 서브쿼리는 별칭을 지정해야 한다. ( o )
-- ③ WHERE 절과 HAVING 절의 서브쿼리는 단일 값 또는 다중 행의 단일 칼럼을 반환할 수 있다. ( o )

-- 정답: o,o,o