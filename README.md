# DBT 강의 - [기초]
* 아래 내용은 dbt learn의 강의를 토대로 작성함 (출처: https://courses.getdbt.com/collections)

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


### 2) dbt와 연결

- 다운로드받은 키를 업로드 후 test 및 continue
- repository 는 dbt클라우드 또는 깃허브 repository에 저장
(*깃허브의 경우 자신의 계정 허용 필요)


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


- 우리의 목표: fivetran(loarders)과 함께 dbt를 사용하여 빅쿼리(data platcroms)에 변환된 데이터를 넣는 것


## 02. Model

### 1) 개요

- modeling : raw data를 원하는 데이터 모형으로 변환하는 과정
- dbt에서 model 
: raw data를 변환 table로 만들기 위해 SQL 문으로 이루어진 각 모델들이 서로 연결되어 있음
- 빅쿼리에 연결되어있는 테이블 사용 방법 : ‘프로젝트명.데이터set명.’.테이블명
- modularity 방식 : 한꺼번에 조립하는 것이 아니라 하나씩 조립하는 방식
→ 조립식 건물을 짓듯이, 데이터를 하나씩 모아 마지막 데이터를 만들어야 함
(각 모델은 재사용 가능)

### 2) 모델링 및 모델의 종류

- Traditional 모델링 : star schema, kimball, data vault 등으로 데이터의 중복성을 제거하기 위해 구성됨
- Denormalized 모델링 : agile analytics, ad hoc analytics 등으로 modern data stack이 있기 때문에 구성 가능함 
→ dbt는 denormalized에 초점을 두지만, traditional 모델링도 가능함
- Staging 모델 : 소스 데이터와 1-1 매칭 됨 (모든 컬럼)
- Intermediate 모델 : staging 모델과 final모델 사이에 있는 모델로 staging 모델을 참조한다.
- Fact 모델 : events, click 등 행위로부터 발생되는 데이터로 이루어진 모델
- Dimension 모델 : 사람, 장소, 기업 등 존재하는 것들에 대한 데이터로 이루어진 모델


### 3) 실습

- 하나의 모델만 run할 수 있는 dbt 명령어 : dbt run -m dim_customers
- 다른 모델을 reference 하는 함수 : {{ ref('모델명)}}  (ref하는 순간 dbt 내에서 파일명이 변환됨)
* ref 하기 전 각 모델 run 해야 함


- dbt run --full-refresh : 이미 테이블이 존재하는데 또 테이블을 만들 경우 dbt run 만 실행하면 중복 오류가 뜸
- dbt에서 테이블을 만드는 명령문 (빅쿼리 내에서도 테이블 형식으로 보임)
1. {{ config (materialized="table”)}} : sql 파일 내 입력
2. +matarialized : table : dbt_project.yml파일에 입력 (경로에 있는 모든 파일에 적용됨)

### 참고)

- CTE SQL 문 : 공통 테이블 변환식으로 임시 명명된 결과 집합을 지정함
(SELECT, INSERT, UPDATE, DELETE, MERGE 문의 실행범위 내에서 지정됨)
    
- 위치 에러 메세지 (not found: dataset was not found in location us) → dbt 프로젝트 위치 US로 설정 필요
    - account setting → 프로젝트명 → connection → location 설정
    
    
- Source : 로드된 raw data

## 03. Sources

### 1) 개요

- Source(raw data)는 ‘프로젝트명.데이터set명.’.테이블명 식으로 구성되기 때문에 location이 수정되면 Source가 사용된 모든 파일을 수정해야 되는 불편함이 있음
→ yml파일에서 Source function으로 한 번에 관리할 수 있음
- Source function : {{ source( 소스명, 테이블명)}}
- Source freshness : raw data가 언제 로드 되었는지 저장하는 컬럼이 있다면, 로드된 시간에 따라 warn 또는 error 표시를 해주는 기능을 제공함 
* sample 데이터에는 created 가 시간단위가 아닌 일자 단위임 
** 명령어 : dbt source freshness
    
    freshness:
    
    warn_after: {count: 12, period: hour}
    
    error_after: {count: 24, period: hour}}
    
- *주의) yml 파일은 compile 대상이 아니므로 오류 메세지가 떠도 상관없음*
- source function 사용시 lineage graph에서 초록색 노드로 raw data 확인 가능
    
    

## 04. Test

### 1) 개요

- test 사용 이유: 각 모델(변경된 데이터)들이 대시보드에 들어가거나 다운로드 받기 전 
믿을 수 있는 데이터인지 검사하기 위함
- dbt project에 Test를 추가하면 project의 models들이 올바르게 작동하는지 확인할 수 있음
- 데이터의 무결성(integrity)을 지키기 위한 일종의 검사. 데이터 무결성에 대한 내용은 아래 링크 참고
    
    참고: 데이터 무결성 - [https://azurecourse.tistory.com/556](https://azurecourse.tistory.com/556)
    
- 코드를 작성하는 도중 test를 통해 모듈이 잘 돌아가는지 검사할 수 있음
- 테스트를 언제 실행할 지 예약할 수 도 있음
- 명령어 ‘dbt test’ 실행 후 모든 test가 passed인지 확인

### 2) Generic tests

- generic tests : unique, not_null, accepted_values, relationships 등이 전반적인 모델에 적용되고 있는지 확인
- models 디렉토리에 YAML 파일 생성 (ex: models/schema.yml)
- accepted_values:모든 컬럼에 있는 값이 미리 정의한 값 내에 있는지
- relationship: 모든 컬럼에 있는 값이 다른 테이블에 있는 컬럼 값 안에 있는지
- dbt test --select test_type:generic : generic test만 실행되는 명령어
- YAML 파일에 아래와 같이 입력하면 코드가 의미하는 바는 ‘customers’ model의 ‘customer_id’의 column값이 unique하고 null값이 아닌지 확인
    
    
    - YAML 파일 입력 시 ‘version: 2’ 꼭 추가
- relationship 코드 참고
    
    tests:
    - relationships:
    to: ref('stg_customers')
    field: customer_id
    
- accepted_values 코드 참고
    
    tests:
    - accepted_values:
    values:
    - completed
    - shipped
    - returned
    - return_pending
    - placed
    

### 3) Singular tests

- singular tests : 1~2개에 모델에 적용하며, 특정 로직이 모델에 적용되고 있는지 확인
- tests 파일에 sql 파일 생성
- dbt test --select test_type:singular : singular test만 실행되는 명령어

### 4) Testing Sources

- 소스.yml 파일에 tests 문을 추가할 수 있음
- 명령어 : dbt test —select source:소스명

## 05. Documentation

### 1) 개요

- dbt는 database model에 대해 documentation, 즉 문서화 기능을 제공함
- documentation을 통해 model에 대한 설명을 입력할 수 있고 협업 시 정보 공유에 유용함
- documentation 기능은 데이터베이스 테이블의 모든 column값과 model의 관계를 자동으로 문서화 해줌
- 사용자는 테이블의 column에 대한 설명이나 model에 대한 설명을 입력하면 됨
- DAG : raw data부터 final data가 되기까지 데이터의 흐름을 자동으로 보여줌

### 2) Documentation 실행 가이드

- 위 Test의 코드에 아래와 같이 description 코드를 추가하면 documentation 기능 활성화
    
    
- 명령어 ‘dbt docs generate’ 실행 시 문서화 진행
- documentation을 확인하기 위한 두 가지 방법
    - dbt Cloud IDE 좌측 상단 햄버거 메뉴 목록 중 ‘Develop’에서 다음과 같이 빨간 박스 부분 ‘view docs’에서 확인 가능
    
    
    - dbt Cloud IDE 좌측 상단 햄버거 메뉴 목록 중 ‘Run History’에서도 확인 가능. 단, deployment 과정 진행 후 확인 가능. Deployment는 06번 항목에서 확인 가능
    
- documentation을 할 수 있는 또 다른 방법은 md 파일을 만들어 YAML 파일로 참조하는 것
- 아래와 같은 코드를 새로운 md 파일에 입력 (ex: models/customers.md)
    
    {% docs **문서명** %}  * 해당 문서명을 yml 파일에서 참조
    
    ========================================
    
    {% docs customers %}                      /* customers model에 대한 documentation 시작 */
    
    This is the customers model.           
    
    Here is a [link]([google.com](http://google.com))             /* [link](google.com) : google.com 하이퍼링크 생성 *
    
    * and a bullet point                            /*  * 입력시 bullet point 생성 *
    
    ****bold**** *_italic_*                      
    
    {% enddocs %}                                   /* customers model에 대한 documentation 끝 */
    
- 생성한 md 파일을 {{ doc(’md파일이름’) }}을 사용하여 다음과 같이 YAML 파일에 연결할 수 있음
    
    
    - md 파일을 이용하면 긴 설명글을 입력하기 용이함
    

## 06. Deployment

### 1) 개요

- Project가 커지면서 데이터베이스도 커지면 테이블을 주기적으로 업데이트해야함
- 이를 ‘deploying a project’ 혹은 ‘running a project in production’을 의미함.
- deployment는 수동적으로 데이터베이스를 업데이트하지 않고 타이머를 맞춰놓으면 자동으로 타이머에 따라 업데이트 진행할 수 있게 해줌. (자동화 기능)

### 2) Deployment 실행 가이드

- Deployment environment 만들기
    - 좌측 상단 햄버거 메뉴 목록 중 ‘Environment’
    - ‘New Environment’ 버튼 클릭
    - Name 입력, Type은 Deployment로 지정, 타겟 dataset을 dataset 항목에 입력
- Job 만들고 실행하기
    - job: 주기적으로 실행할 dbt 명령어의 집합 (ex: dbt run, dbt test)
    - 좌측 상단 햄버거 메뉴 목록 중 ‘Jobs’
    - ‘New job’ 버튼 클릭
    - Name 입력, Environment 선택
    - ‘Generate docs’ 체크박스 체크
    - dbt run, dbt test 등 add command
    - Triggers란에서는 Schedule, Webhooks(git 자동 연동), API 설정 가능
    - save 후 Run now 실행
