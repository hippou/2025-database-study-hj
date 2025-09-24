/*
	3. 데이터 필터링하기
    3.1 데이터 필터링이란
*/
-- 무엇? 많은 데이터들 중에 원하는 데이터만 골라내는 작업
-- 주로 WHERE 절을 통해 특정 데이터를 추출

-- 예를 들어
-- (a) SELECT문: 데이터 조회
/* SELECT 컬럼명1, 컬럼명2, ...
FROM 테이블명
WHERE 조건; */

-- (b) UPDATE문: 데이터 수정
/*UPDATE 테이블명
SET 컬럼명 = 입력값
WHERE 조건;*/

-- (c) DELETE문: 데이터 삭제
/*DELETE FROM 테이블명
WHERE 조건;*/

-- 실습 데이터 준비
-- 2장에서 만든 맵도날드 DB를 활용
-- DB 진입
USE mapdonalds;

-- burger 테이블 조회
SELECT * FROM burgers;

-- burgers 테이블 생성
CREATE TABLE burgers (
	id INTEGER, 		  -- 아이디(정수형 숫자)
	name VARCHAR(50), -- 이름(문자형: 최대 50자)
	price INTEGER, 		-- 가격(정수형 숫자)
	gram INTEGER, 		-- 그램(정수형 숫자)
	kcal INTEGER, 		-- 열량(정수형 숫자)
	protein INTEGER, 	-- 단백질량(정수형 숫자)
	PRIMARY KEY (id) 	-- 기본키 지정: id
);

-- burgers 데이터 삽입
INSERT INTO burgers (id, name, price, gram, kcal, protein)
VALUES
	(1, '빅맨', 5300, 223, 583, 27),
	(2, '베이컨 틈메이러 디럭스', 6200, 242, 545, 27),
	(3, '맨스파이시 상해 버거', 5300, 235, 494, 20),
	(4, '슈비두밥 버거', 6200, 269, 563, 21),
	(5, '더블 쿼터파운드 치즈', 7700, 275, 770, 50);
    
-- 모든 버거 조회 
SELECT * FROM burgers;

-- 1)비교 연산자 
-- 두 값을 비교하는 연산 기호 
-- WHERE 절에 사용하여 특정 데이터로 필터링 가능 
-- 종류: =, !=, >, >=, <, <=

-- QUIZ: 가격이 5500원 보다 비싼 버거 찾기 
SELECT * 
FROM burgers
WHERE price > 5500;

-- QUIZ: 가격이 5500원 보다 싼 버거 찾기 
SELECT * 
FROM burgers
WHERE price < 5500;

-- QUIZ: 단백질량이 25g 보다 적은 버거 찾기
SELECT *
FROM burgers 
WHERE protien < 25;

-- (참고) NULL 비교에 대해
-- NULL은 데이터베이스에서 '값이 없음'을 나타내는 특별한 상태
-- NULL은 특정값이 아니기 때문에 등호(=)로 비교할 수 없음
INSERT INTO burgers (id, name, price, gram, kcal, protein)
VALUES
	(6, null, 5000, 222, 522, 22);
    
SELECT *
FROM burgers
WHERE name = NULL; 

-- 이런 문제를 해결하기 위해 SQL은 'IS NULL' 이라는 특별한 키워드를 ㅔㅈ공함 
-- IS NULL: 해당 열의 값이 NULL인 행을 찾음 
-- IS NOT NULL: 해당 열의 값이 NULL이 아닌, 즉 데이터가 입력된 행을 찾음
SELECT *
FROM burgers
WHERE name IS NULL; 

SELECT *
FROM burgers
WHERE name IS NOT NULL; 

-- 2) 논리 연산자
-- 조건을 조합하거나 반전하여 새 조건을 만듦
-- 종류: AND, OR, NOT
-- 사용 예
-- 조건A AND 조건B: 조건A와 조건B를 동시에 만족하는 데이터 필터링(교집합)
-- 조건A OR 조건B: 조건A와 조건B 중 하나라도 만족하는 데이터 필터링(합집합)
-- NOT 조건A: 조건A를 만족하지 않는 데이터 필터링(여집합)

-- TRUE/FALSE의 논리 연산
-- TRUE(참: 1), FALSE(거짓: 0)

-- AND 연산: 둘 다 참이여야 참
SELECT TRUE AND TRUE; 
SELECT TRUE AND FALSE;
SELECT FALSE AND TRUE;
SELECT FALSE AND FALSE; 

-- OR 연산: 둘 중 하나만 참이면 참
SELECT TRUE OR TRUE; 
SELECT TRUE OR FALSE;
SELECT FALSE OR TRUE;
SELECT FALSE OR FALSE; 

-- QUIZ: 5500원 보다 싸고, 동시에 단백질량이 25g 보다 많은 버거 
SELECT *
FROM burgers
WHERE price < 5500 AND protein > 25;

-- QUIZ: 5500원 보다 싸거나, 단백질량이 25g 보다 많은 버거 
SELECT *
FROM burgers 
WHERE price < 5500 OR protein > 25;

-- QUIZ: 단백질량이 25g 보다 많지 않은 버거
SELECT *
FROM burgers
WHERE NOT protein > 25;
-- WHERE !(protein > 25); --(참고) **, ||, !는 MYSQL에서만 작동 
-- 가독성과 이식성을 위해서는 AND, OR, NOT을 사용하는 것이 가장 안전

-- 3) 산술 연산자
-- 사칙 연산 등을 위한 수학적 연산 기호
-- WHERE절과 SELECT 절에서 사용 가능 
SELECT 100 + 20; -- 120
SELECT 100 - 20; -- 80
SELECT 100 * 20; -- 2000
SELECT 100 / 20; -- 5.0000
SELECT 100 % 20; -- 0

-- 산술 연산자 활용 예
-- SELECT 문에서의 산술 연산 예시
SELECT *, price / gram *100 AS `price/100g` -- 따옴표나("",'') 또는 백틱(``)으로 감싸기
FROM burgers; 
-- 100g당 가격을 계산하여 price/100g 이라는 별칭(alias)으로 반환함

-- WHERE 절에서 산술 연산 예시
-- 가격에 10%를 더한 값이 6500원을 넘는 버거 조회 
SELECT *
FROM burgers
WHERE price*1.1 > 6500;

-- 짝수 ID를 가진 버거만 조회
SELECT *
FROM burgers
WHERE id%2 = 0 ;

-- UPDATE 문에서 산술 연산 예시
-- ID가 5인 버거의 가격을 500원 인한
UPDATE burgers
SET price = price -500 
WHERE id =5;

-- 4) 연산자의 우선순위
-- 어떤 연산자를 먼저 수행할 것인가의 기준
-- 우선순위가 높은 것부터 낮은 순으로 수행
-- 암기X(쓰다 보면 자연스럽게 익혀짐)
-- 애매하면 최우선 순위 ()를 사용 - 필요하면 우선순위 표를 찾아보면 됨

-- 괄호 > 산술(*,/,%) > 산술(+,-) > 비교 > 논리(AND) > 논리 (OR)

-- Quiz: 다음 쿼리의 수행 결과는?
SELECT 3 + 5 * 2; -- 13
SELECT (3 + 5) * 2; -- 16
SELECT TRUE OR TRUE AND FALSE;  -- 1
SELECT (TRUE OR TRUE) AND FALSE; -- 0