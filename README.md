# DBT 강의 - [기초]

## 00. DBT SETTING 및 빅쿼리와 연결

- 참고 URL: [https://docs.getdbt.com/tutorial/setting-up](https://docs.getdbt.com/tutorial/setting-up)

### 1) 자격증명 생성

- 참고 URL : [https://console.cloud.google.com/apis/credentials/wizard?previousPage=%2Fapis%2Fcredentials%3Fhl%3Dko%26project%3Dmaderi-cdp&hl=ko&project=maderi-cdp](https://console.cloud.google.com/apis/credentials/wizard?previousPage=%2Fapis%2Fcredentials%3Fhl%3Dko%26project%3Dmaderi-cdp&hl=ko&project=maderi-cdp)
- 빅쿼리 이동 경로 : API 및 서비스 → 사용자인증정보 → 사용자인증정보 만들기 → 사용자인증정보 선택 도움말
- 선택항목 
 - 엑세스 데이터 유형 → 애플리케이션 데이터
 - 이 API를 Compute Engine, Kubernetes Engine, App Engine 또는 Cloud Functions에서 사용할 계획인가요? → 아니요
 - 엑세스 권한 부여 역할 → bigquery 관리자, bigquery 작업 사용자, bigquery 사용자, bigquery 데이터 편집자 (*확실하지 않음)
- 키 생성 후 json으로 다운로드

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/91ae91a0-7a88-467b-b4ff-1d1bb83deb27/Untitled.png)

### 2) dbt와 연결

- 다운로드받은 키를 업로드 후 test 및 continue
- repository 는 dbt클라우드 또는 깃허브 repository에 저장
(*깃허브의 경우 자신의 계정 허용 필요)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/35ce85a0-f5d1-40dc-aeac-1428e37cf196/Untitled.png)

** dbt cloud 저장소를 사용할 예정이라면 3) 생략 가능

** dbt cloud를 repository로 사용할 예정이라면 4) 또한 생략 가능

### 3) 아톰 설치 가이드

- [https://digiconfactory.tistory.com/entry/atom-editor-아톰-에디터-설치-가이드-HTML-기본-플러그인-설치-에밋emmet-외-윈도우10](https://digiconfactory.tistory.com/entry/atom-editor-%EC%95%84%ED%86%B0-%EC%97%90%EB%94%94%ED%84%B0-%EC%84%A4%EC%B9%98-%EA%B0%80%EC%9D%B4%EB%93%9C-HTML-%EA%B8%B0%EB%B3%B8-%ED%94%8C%EB%9F%AC%EA%B7%B8%EC%9D%B8-%EC%84%A4%EC%B9%98-%EC%97%90%EB%B0%8Bemmet-%EC%99%B8-%EC%9C%88%EB%8F%84%EC%9A%B010)

### 4) git 설치 가이드

- [https://goddaehee.tistory.com/216](https://goddaehee.tistory.com/216)
- 초보자를 위한 git 사용법 : [https://nevertrustbrutus.tistory.com/m/153](https://nevertrustbrutus.tistory.com/m/153)

## 01. 분석 엔지니어란?

- 기존의 ETL 과정에서 데이터 웨어하우스가 생김에 따라 ELT가 가능해져
‘데이터 엔지니어링’ 과 ‘데이터 분석가’ 사이의 ‘분석 엔지니어’라는 롤이 추가가 되었음

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5fe76eab-29fb-47d8-ba5b-9bcae4fc16dc/Untitled.png)

## 02 Modern Data Stack에서의 dbt

- 우리의 목표: fivetran(loarders)과 함께 dbt를 사용하여 빅쿼리(data platcroms)에 변환된 데이터를 넣는 것

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5673d19e-d473-447e-9cd4-0e429c1c13f2/Untitled.png)

## 03. Model

### 1) 개요

- modeling : raw data를 원하는 데이터 모형으로 변환하는 과정
- dbt에서 model 
: raw data를 변환 table로 만들기 위해 SQL 문으로 이루어진 각 모델들이 서로 연결되어 있음
- 빅쿼리에 연결되어있는 테이블 사용 방법 : ‘프로젝트명.데이터set명.’.테이블명
- dbt에서 테이블을 만드는 명령문 : {{ config (materialized="table”)}}
→빅쿼리 내에서도 테이블 형식으로 보임
- 하나의 모델만 run할 수 있는 dbt 명령어 : dbt run -m dim_customers
- modularity 방식 : 한꺼번에 조립하는 것이 아니라 하나씩 조립하는 방식
→ 조립식 건물을 짓듯이, 데이터를 하나씩 모아 마지막 데이터를 만들어야 함
(각 모델은 재사용 가능)
- 다른 모델을 reference 하는 함수 : {{ ref('모델명)}}  (ref하는 순간 dbt 내에서 파일명이 변환됨)
* ref 하기 전 각 모델 run 해야 함

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d98ddcc7-40f2-4bcf-96f3-084615a9fd42/Untitled.png)

### 2) 모델링 및 모델의 종류

- Traditional 모델링 : star schema, kimball, data vault 등으로 데이터의 중복성을 제거하기 위해 구성됨
- Denormalized 모델링 : agile analytics, ad hoc analytics 등으로 modern data stack이 있기 때문에 구성 가능함 
→ dbt는 denormalized에 초점을 두지만, traditional 모델링도 가능함

### 참고)

- CTE SQL 문 : 공통 테이블 변환식으로 임시 명명된 결과 집합을 지정함
(SELECT, INSERT, UPDATE, DELETE, MERGE 문의 실행범위 내에서 지정됨)
- 참고) 위치 에러 메세지 (not found: dataset was not found in location us) → dbt 프로젝트 위치 US로 설정 필요
