# Project Overview (프로젝트 요약)

ONMATOUT은 요가 입문자와 중급자를 위한 모바일 요가 수련 앱입니다. 사용자는 300개의 요가 아사나 카드를 탐색하고, 오늘 수련한 아사나를 선택하여 기록을 남기며, 감정/에너지 상태를 함께 기록하여 요가를 일상의 습관으로 만들 수 있도록 유도합니다. 또한, 주변 요가원 정보를 탐색할 수 있으며, 앱 내 예약 기능은 제공하지 않습니다.

# Core Functionalities (핵심 기능)

## 1. 아사나 탐색 (Asanas)

* 총 300개의 요가 아사나 카드 제공
* 아사나 검색 (한글/영어 이름)
* 카테고리 및 난이도 필터링 기능
* 즐겨찾기 기능
* 아사나 상세 페이지 제공

  * 이미지, 이름, 설명, 주요 효과, 카테고리, 난이도 등 포함

## 2. 수련 기록 (Record)

* 오늘 수련한 아사나 기록 기능
* 감정 상태 (이모지), 에너지/집중도 선택 기능
* 자유 메모 작성 기능
* 수련 히스토리 확인 가능

## 3. 수련 통계 (Statistics)

* 누적 수련 횟수 표시
* 연속 수련 일수 계산
* 감정/에너지 상태 통계 시각화 (그래프)

## 4. 요가원 정보 탐색 (Studios)

* 지역 기반 요가원 목록 제공
* 상세 정보:

  * 센터명, 위치(GPS/지도 연동), 수련 스타일, 운영 시간, 연락처, 웹사이트, 내부 이미지
* 앱 내 예약 기능 없음 (외부 연락 유도)

## 5. 사용자 경험 (User Experience)

* 직관적인 반응형 UI/UX
* 다크 모드 지원
* 바텀탭 내비게이션:

  * 홈 / 아사나 / 기록 / 요가원 / 프로필

# Doc (참고 문서)

* Flutter 공식 문서
* Supabase Authentication 가이드
* Supabase Database 가이드

# Current File Structure (현재 파일 구조)

```
ONMATOUT/
│── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   ├── asana_detail_screen.dart
│   │   ├── record_screen.dart
│   │   ├── stats_screen.dart
│   │   ├── studio_screen.dart
│   │   ├── studio_detail_screen.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── asana_model.dart
│   │   ├── record_model.dart
│   │   ├── studio_model.dart
│   ├── viewmodels/
│   │   ├── auth_viewmodel.dart
│   │   ├── asana_viewmodel.dart
│   │   ├── record_viewmodel.dart
│   │   ├── studio_viewmodel.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── database_service.dart
│   ├── widgets/
│   │   ├── asana_card.dart
│   │   ├── record_entry.dart
│   │   ├── studio_card.dart
│   │   └── common/
│── pubspec.yaml
│── README.md
```
