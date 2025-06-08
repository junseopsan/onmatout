# ONMATOUT - 프론트엔드 개발 문서

# [진행상황]

- [v] 1단계: 회원가입/로그인 요구사항 및 전체 구조 설계 완료 (2024-06-13)
- [v] 2단계: user_model.dart 설계 및 구현 완료 (2024-06-13)
- [v] 3단계: auth_service.dart 설계 및 구현 완료 (2024-06-13)
- [v] 4단계: auth_viewmodel.dart 설계 및 구현 완료 (2024-06-13)
- [v] 5단계: register_screen.dart 설계 및 구현 완료 (2024-06-13)
- [v] 6단계: login_screen.dart 설계 및 구현 완료 (2024-06-13)
- [v] 7단계: asana_model.dart 설계 및 구현 완료 (2024-06-13)
- [v] 8단계: asana_viewmodel.dart 설계 및 구현 완료 (2024-06-13)
- [v] 9단계: asana_card.dart 설계 및 구현 완료 (2024-06-13)
- [v] 10단계: record_model.dart 설계 및 구현 완료 (2024-06-13)
- [v] 11단계: record_viewmodel.dart 설계 및 구현 완료 (2024-06-13)
- [v] 12단계: record_entry.dart 설계 및 구현 완료 (2024-06-13)
- [v] 13단계: record_screen.dart 설계 및 구현 완료 (2024-06-13)
- [v] 14단계: stats_model.dart 설계 및 구현 완료 (2024-06-13)
- [v] 15단계: stats_viewmodel.dart 설계 및 구현 완료 (2024-06-13)
- [v] 16단계: stats_screen.dart 설계 및 구현 완료 (2024-06-13)
- [v] 17단계: studio_model.dart 설계 및 구현 완료 (2024-06-13)
- [v] 18단계: studio_viewmodel.dart 설계 및 구현 완료 (2024-06-13)
- [v] 19단계: studio_card.dart 설계 및 구현 완료 (2024-06-13)
- [v] 20단계: studio_screen.dart 설계 및 구현 완료 (2024-06-13)
- [v] 21단계: studio_detail_screen.dart 설계 및 구현 완료 (2024-06-13)

---

**모든 주요 화면/모델/뷰모델/위젯 설계 및 구현이 완료되었습니다.**

## #project-overview (프로젝트 개요)

ONMATOUT은 요가 입문자와 중급자를 위한 모바일 요가 수련 앱으로, 300개의 요가 아사나 카드를 기반으로 루틴 생성, 수련 기록, 수련 통계, 요가원 탐색 기능을 제공합니다. 사용자는 수련 후 감정/에너지 상태를 기록하며 수련 루틴을 습관화할 수 있고, 주변 요가원을 탐색할 수 있습니다.

## #feature-requirements (기능 요구사항)

### ✅ 아사나 기능 (asanas)

* 전체 300개의 아사나 카드 제공
* 아사나 검색 (한글/영어 이름)
* 필터링 (카테고리, 난이도)
* 즐겨찾기 기능
* 아사나 상세 페이지:

  * 이미지, 이름, 설명, 효과, 카테고리, 난이도 표시

### ✅ 수련 기록 (record)

* 오늘의 수련 기록 작성 (아사나 목록)
* 감정/에너지/집중도 상태 선택
* 메모 작성 기능
* 수련 히스토리 확인

### ✅ 수련 통계

* 누적 수련 횟수
* 연속 수련 일수
* 감정/에너지 통계 시각화

### ✅ 요가원 정보(studio) 탐색

* 지역 기반 요가원 목록 조회
* 요가원 상세 정보 표시 (지도, 운영시간, 연락처 등)
* 예약 기능 없음

### ✅ UI/UX

* 직관적이고 반응형 인터페이스
* 다크모드 지원
* 바텀탭 기반 내비게이션 구조:
  * 홈 / 아사나 / 기록 / 요가원 / 프로필

## #relevant-codes (관련 코드)

### Screens

* `home_screen.dart`: 오늘의 루틴/수련 기록 진입점
* `asana_detail_screen.dart`: 아사나 상세
* `record_screen.dart`: 수련 기록
* `stats_screen.dart`: 통계 차트 및 수치
* `studio_screen.dart`: 요가원 리스트
* `studio_detail_screen.dart`: 요가원 상세 정보

### ViewModels

* `asana_viewmodel.dart`
* `record_viewmodel.dart`
* `studio_viewmodel.dart`

### Models

* `asana_model.dart`
* `record_model.dart`
* `studio_model.dart`
* `user_model.dart`

### Widgets

* `asana_card.dart`
* `record_entry.dart`
* `studio_card.dart`
* 공통 위젯 (버튼, 인디케이터 등)

### Services

* `auth_service.dart`: 인증
* `database_service.dart`: Supabase 연동

## #Current-file-instruction (현재 파일 구조)

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

## #rules (규칙)

1. MVVM 패턴을 엄격히 준수
2. 모든 코드는 Dart 린트 규칙을 준수
3. 모든 위젯은 반응형으로 구현
4. 모든 문자열은 상수로 관리
5. 모든 에러는 적절히 처리
6. 모든 비동기 작업은 적절히 처리
7. 모든 데이터는 적절히 검증
8. 모든 UI는 직관적이고 사용자 친화적
9. 모든 기능은 테스트 가능하게 구현
10. 모든 코드는 문서화
