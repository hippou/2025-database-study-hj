/*
	5. 다양한 자료형 활용하기
	5.1 자료형이란
*/
-- 무엇? 데이터의 형태(data type)
-- 관리하고 싶은 데이터에 맞게 자료형이 필요
-- 그래야 저장 공간을 효율적으로 사용하고 데이터의 정확성을 높일 수 있음
-- 자료형을 잘못 지정할 경우, 메모리 공간의 낭비와 연산에 제약이 생길 수 있음

-- DB의 자료형은 크게 숫자형, 문자형, 날짜 및 시간형이 있음

-- 선행학습
-- 컴퓨터의 저장 단위와 자료형의 크기
-- 단위            | 크기        | 저장 예
-- 비트(Bit)         1Bit         True 또는 false 저장(0 또는 1을 저장)
-- 바이트(Byte)       8bit         알파벳 한 개 저장
-- 킬로바이트(KB)      1,024Byte    몇 개의 문단 저장
-- 메가바이트(MB)      1,024KB      1분 길이의 MP3 파일 저장
-- 기가바이트(GB)      1,024MB      30분 가량의 HD 영화 저장
-- 테라바이트(TB)      1,024GB      약 200편의 FHD 영화 저장

-- 자료형의 종류
-- 1. 숫자형
-- 숫자를 저장하기 위한 데이터 타입
-- 크게 정수형, 실수형으로 나뉨

-- 1) 정수형
-- 소수점이 없는 수 저장: -2, -1, 0, 1, 2, ...
-- 세부 타입이 존재: 차지하는 메모리 크기에 따른 분류
-- 종류: TINYINT, SMALLINT, MEDIUMINT, INTEGER(또는 INT)*, BIGINT

-- UNSIGNED(언사인드) 제약 조건 부여 가능: 음수 값을 허용하지 않는 정수 
-- 유효성 보장: 나이는 0~255의 유효한 값만 저장 
CREATE TABLE users (
  age TINYINT UNSIGNED 
);
-- 안전성 보장: 재고는 음수가 될 수 없음 
CREATE TABLE products (
  stock INT UNSIGNED
);

-- 2) 실수형
-- 소수점을 포함하는 수 저장: 3.14, -9.81, ...
-- 부동 소수점(floating-point): 가수부와 지수부를 통해 소수점 위치를 변경(FLOAT, DOUBLE)
-- 고정 소수점(fixed-point): 자릿수가 고정된 실수를 저장(DECIMAL)

-- 부동 소수점 vs 고정 소수점
-- 부동 소수점: 넓은 범위를 표현 가능, 숫자 계산에 오차 발생(2진수 기반이라서)
-- FLOAT과 DOUBLE 타입은 0.1을 정확히 저장하지 않고 근사값으로 저장(왜? 0.1은 2진수로 무한 소수)
-- FLOAT: 약 7자리 정확도
-- DOUBLE: 약 15~17자리 정확도
-- 아주 높은 정밀도가 필요 없는 계산, 통계 데이터, 측정값 등에 사용

-- 고정 소수점: 특정 범위 안에서 정확한 연산을 수행(10진수 기반이라서)
-- DECIMAL 타입은 0.1을 근사값이 아니라 정확하게 저장
-- 정확한 소수값이 필요하면 DECIMAL을 사용
-- 예를 들어 금융 데이터(돈, 환율, 회계)와 같이 오차가 허용되지 않는 정확한 계산이 필요할 때 사용

-- 정수형 vs 실수형
-- 정수형: 연산이 빠르고 정확하지만 범위 한정
-- 실수형(FLOAT, DOUBLE): 정확도가 낮은 대신 표현 범위가 넓음
-- DECIMAL: 정확하지만 성능 희생

-- 실습: 숫자형 사용하기
-- 학생 기록(student_records) 테이블을 만들어 다음 데이터를 저장한다면?
-- (학년은 초등학교 1학년부터 고등학교 3학년까지를 숫자 1~12로 표현할 것)

-- 아이디  | 학년 | 평균 점수   | 수업료
-- ----------------------------------
-- 1     | 3   | 88.75   | 50000.00
-- 2     | 6   | 92.5    | 100000.00

-- data_type DB 생성 및 진입
CREATE DATABASE data_type;
USE data_type;
SELECT DATABASE(); -- 확인

-- 학생 기록 (student_records) 테이블 생성
CREATE TABLE student_records( 
	id INT, -- 아이디 (표준 정수)
    grade TINYINT UNSIGNED, -- 학년(부호가 없는 매우 작은 정수), 0~255
    average_score FLOAT, -- 평균 점수 (부동 소수점 방식의 실수)
    tuition_fee DECIMAL(8,2), -- 수업료(고정 소수점 방식의 실수), 돈계산 관련은 정확하게, 전체 10자리, 소수점 이하 2자리 
    PRIMARY KEY(id)
);

-- 학생 기록 데이터 삽입 
INSERT INTO 
	student_records (id, grade, average_score, tuition_fee)
VALUES
 (1, 3, 88.75, 50000.00),
 (2, 6, 92.5, 100000.00);
 
-- 데이터 조회
SELECT *
FROM student_records;

-- grade 컬럼에 자료형 범위를 벗어난 값을 입력
INSERT INTO 
	student_records (id, grade, average_score, tuition_fee)
VALUES
 (3, -2, 66.5, 20.00);
 
INSERT INTO 
	student_records (id, grade, average_score, tuition_fee)
VALUES
 (4, 256, 66.5, 20.00);
 
INSERT INTO 
	student_records (id, grade, average_score, tuition_fee)
VALUES
 (5, 2, 66.5, 200000000000.00);


-- 2. 문자형
-- 한글, 영어, 기호 등의 문자 저장을 위한 타입
-- 다양한 세부 타입이 존재
-- 종류: CHAR, VARCHAR*, TEXT, BLOB, ENUM 등

-- 1) CHAR vs VARCHAR
-- CHAR: 고정 길이(최대 255자)
-- VARCHAR: 가변 길이(최대 65,535자)
-- (참고) VARCHAR는 UTF-8과 같은 멀티바이트 문자셋 사용 시, 실제 저장 가능 글자 수는 줄어듦
-- => VARCHAR(65535)는 현실적으로 불가능하고 VARCHAR(16383) 정도가 안전한 최대치

-- VARCHAR(n): 최대 n 글자까지 저장되는 가변 길이 문자열
-- 이름, 주소처럼 길이가 제각각인 데이터에 사용하면 저장 공간을 효율적으로 쓸 수 있음
-- '홍길동'(3글자)을 VARCHAR(10)에 저장하면 실제 데이터 길이인 3글자만큼의 공간만 차지
-- '김아무개'(4글자)을 VARCHAR(10)에 저장하면 실제 데이터 길이인 4글자만큼의 공간만 차지
-- 데이터의 길이 확인을 위해 추가로 1~2바이트의 길이 정보 저장 공간 필요

-- CHAR(n): 항상 n 글자 길이를 차지하는 고정 길이 문자열
-- '남'(1글자)을 CHAR(2)에 저장하면, 나머지 1글자는 공백으로 채워져 무조건 2글자의 공간을 차지
-- 성별 코드('M'/'F')나 우편번호, 국가 코드('KR'/'US')처럼 항상 길이가 정해져 있는 데이터에 사용하면, VARCHAR 보다 아주 약간의 이점을 가질 수 있음
-- 길이가 항상 같으니, 데이터를 찾기 위해 길이를 확인할 필요가 없기 때문

-- CHAR와 VARCHAR 자료형의 사용예 
CREATE TABLE addresses (
	post_code CHAR(5), -- 우편번호(고정 길이 문자: 5자)
    -- 문자를 3개만 넣는 경우, 자동으로 공백 문자를 채움(예: 'abc ')
    street_address VARCHAR(100) -- 도로명 주소 (가변 길이 문자: 최대 100자)
    -- 최대 100글자 저장 가능하지만, 사용 메모리는 입력된 문자만큼만 사용(예: 'abc') 
);

-- 실무에서는 보편적으로 VARCHAR 사용
-- 과거에는 "길이가 고정적이면 CHAR, 가변적이면 VARCHAR" 라는 원칙이 강조되었지만, 
-- 현재 빨라진 환경에서는 VARCHAR를 우선적으로 고려

-- 2) TEXT
-- 긴 문자열 저장을 위한 타입
-- CHAR/VARCHAR로는 감당하기 어려운 매우 긴 텍스트 데이터를 저장하기 위해 존재
-- 예: VARCHAR는 최대 약 65KB 정도까지만 저장 가능(이마저도 문자셋에 따라 줄어듦)
-- => 그 이상을 저장하려면 TEXT가 필요
-- 주로 상품의 상세 설명, 장문의 리뷰, 블로그 게시글 본문처럼 긴 글 작성에 적합
-- 세부 타입 종류: TINYTEXT, TEXT*, MEDIUMTEXT, LONGTEXT
-- TEXT 자료형의 사용 예
CREATE TABLE articles (
	title VARCHAR(200), -- 제목(가변 길이 문자: 최대 200자)
    short_description TINYTEXT, -- 짧은 설명(최대 255Byte)
    comments TEXT, -- 댓글(최대 64KB)
    content MEDIUMTEXT, -- 본문(최대 16MB)
    additional_info LONGTEXT -- 추가 정보(최대 4GB)
);

-- (참고)
-- 자바 웹 개발을 포함한 대부분의 애플리케이션에서는 이미지나 동영상 같은 대용량 파일을 
-- 데이터베이스에 직접 저장하지 않고, 클라우드 스토리지나 파일 서버 등에 저장한 뒤, 
-- 그 경로나 URL만 데이터베이스에 저장하는 방식이 사실상 표준

-- 왜 DB에 직접 저장하지 않을까? 
-- DB부하가 큼, 성능이 느림, 백업/복구 어려움 등 


-- 3) BLOB(잘 쓰지 않음)
-- 크기가 큰 파일 저장을 위한 타입
-- 이미지, 오디오, 비디오 등의 저장에 사용
-- 세부 타입 종류: TINYBLOB, BLOB, MEDIUMBLOB, LONGBLOB
-- BLOB 자료형의 사용 예
CREATE TABLE files (
	file_name VARCHAR(200), -- 파일명(가변 길이 문자: 최대 200자)
    small_thumbnail TINYBLOB, -- 작은 이미지 파일(최대 255Byte)
    document BLOB, -- 일반 문서 파일(최대 64KB)
    video MEDIUMBLOB, -- 비디오 파일(최대 16MB)
    large_data LONGBLOB -- 대용량 파일(최대 4GB)
);


-- 4) ENUM(잘 쓰지 않음)
-- 주어진 목록 중 하나만 선택할 수 있는 타입
-- 입력 가능한 목록을 제한하여, 잘못된 입력을 예방
-- ENUM 자료형의 사용 예
CREATE TABLE memberships (
	name VARCHAR(100), -- 회원명(가변 길이 문자: 최대 100자)
    level ENUM('bronze', 'silver', 'gold') -- 회원 레벨(선택 목록 중 택1)
);


-- 실습: 문자형 사용하기
-- 다음 데이터를 사용자 프로필(user_profiles) 테이블로 만들어 저장하려면?

-- 아이디  | 이메일                  | 전화번호          | 자기소개     | 프로필 사진   | 성별
-- -------------------------------------------------------------------------------
-- 1     | geoblo@naver.com      | 012-3456-7890  | 안녕하십니까!  | NULL      | 남
-- 2     | hongsoon@example.com  | 098-7654-3210  | 반갑습니다요!  | NULL      | 여

-- Quiz: 사용자 프로필(user_profiles) 테이블 생성
CREATE TABLE user_profiles(
 id INT PRIMARY KEY, -- 아이디(표준 정수)
 email VARCHAR(255), -- 이메일(가변 길이 문자: 최대 255자)
 phone_number CHAR(13), -- 전화번호(고정 길이 문자: 13자)
 self_introduction TEXT, -- 자기소개(긴 문자열: 최대 64KB)
 profile_picture MEDIUMBLOB, -- 프로필 사진(파일: 최대 16MB)
 gender ENUM ('남','여') -- 성별(선택 목록 중 택 1)
);

-- 3. 날짜 및 시간형
-- 날짜와 시간 값 저장을 위한 타입
-- 종류: DATE, TIME, DATETIME*, YEAR 등
-- 날짜와 시간을 저장할 때, 저장 형식 자체는 직접 지정할 수 없음(변경 불가! 데이터는 항상 같은 형식으로 저장됨)
-- 대신 출력 시 DATE_FORMAT() 함수 등을 사용해 표시 형식을 바꿀 수 있음

-- 1) DATE
-- 날짜 저장을 위한 타입
-- YYYY-MM-DD 형식으로 저장
-- 예: '1919-03-01', '2025-12-25'
-- 유효 범위: '1000-01-01' ~ '9999-12-31'

-- 2) TIME
-- 시간 저장을 위한 타입
-- hh:mm:ss 형식으로 저장
-- 예: '08:50:25', '22:07:02'
-- 유효 범위: '-838:59:59' ~ '838:59:59' (<- 시간을 표현할 뿐만 아니라 두 시점 간 시간 차이도 표현하기 때문)
-- 추가 옵션: 밀리초 또는 마이크로초까지 저장 가능

-- 3) DATETIME
-- 날짜와 시간을 함께 저장하는 타입
-- YYYY-MM-DD hh:mm:ss 형식으로 저장
-- 예: '2025-05-31 19:30:00'
-- 유효 범위: '1000-01-01 00:00:00' ~ '9999-12-31 23:59:59'
-- 추가 옵션: 밀리초 또는 마이크로초까지 저장 가능

-- (번외) TIMESTAMP(현재에는 잘 안씀)
-- 날짜 + 시간
-- YYYY-MM-DD hh:mm:ss
-- 1970-01-01 00:00:01 UTC ~ 2038-01-19 03:14:07 UTC (범위를 넘어가면 오버플로우 현상 발생)
-- 타임존 정보를 가짐(조회 시 현재 세션의 타임존에 따라 자동 변환됨)
-- 장점: 자동 생성 및 업데이트 기능 제공

-- 4) YEAR
-- 4자리 연도 저장을 위한 타입
-- YYYY 형식으로 저장
-- 예: '2002'
-- 유효 범위: '1901' ~ '2155', '0000'(비표준) -> 미정을 표현하고 싶다면: NULL을 사용

-- 실습: 날짜 및 시간형 사용하기
-- 다음 데이터 이벤트(events)를 테이블로 저장하려면?

-- 아이디 | 이벤트명          | 이벤트 일자    | 이벤트 시간  | 이벤트 등록 일시         | 이벤트 연도
-- -------------------------------------------------------------------------------------
-- 111   | Music Festival  | 2024-10-04  | 17:55:00   | 2024-09-04 10:25:30  | 2024
-- 222   | Art Exhibition  | 2024-11-15  | 12:00:00   | 2024-09-05 11:30:00  | 2024

-- Quiz: 이벤트(events) 테이블 생성
CREATE TABLE events (
	id INT, 			        -- 아이디(표준 정수)
	event_name VARCHAR(100) , 	-- 이벤트명(가변 길이 문자: 최대 100자)
	event_date DATE , 	        -- 이벤트 일자(YYYY-MM-DD)
	start_time TIME , 			-- 이벤트 시간(hh:mm:ss)
	created_at DATETIME , 		-- 이벤트 등록 일시(YYYY-MM-DD hh:mm:ss)
	event_year YEAR, 			-- 이벤트 연도(YYYY)
	PRIMARY KEY (id) 			-- 기본키 지정: id
);


-- 이벤트(events) 데이터 삽입
INSERT INTO 
	events (id, event_name, event_date, start_time, created_at, event_year)
VALUES
	(111, 'Music Festival', '2024-10-04', '17:55:00', '2024-09-04 10:25:30', '2024'),
	(222, 'Art Exhibition', '2024-11-15', '12:00:00', '2024-09-05 11:30:00', '2024');
    
-- 데이터 조회
SELECT *
FROM events;

-- Quiz
-- 1. 다음은 orders(주문)테이블을 생성하는 쿼리이다. 바르게 설명한 것을 모두 고르세요.

CREATE TABLE orders (
	id INTEGER,              -- 아이디
	name VARCHAR (255), 	 -- 상품명
	price DECIMAL(10, 2),    -- 가격
	quantity INTEGER,        -- 주문 수량
	customer_name CHAR(100), -- 고객명
	shipping_address TEXT,   -- 배송 주소
	created_at DATETIME,     -- 주문 일시
	PRIMARY KEY (id)
);

-- ① id는 기본키로 선언됐다.
-- ② name은 최대 255자까지 저장할 수 있다.
-- ③ price에 저장할 수 있는 최댓값은 9,999,999,999이다.
-- ④ customer_name이 100자보다 짧으면, 고객명을 저장하고 남은 만큼의 메모리 공간이 절약된다.
-- ⑤ created_at에는 날짜와 시간 값을 모두 저장할 수 있다.

-- 정답: 1, 2, 5

