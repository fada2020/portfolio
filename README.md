# Full-stack Portfolio (Flutter)

Flutter로 개발된 이중 언어 지원 포트폴리오 웹사이트입니다. 풀스택 개발자의 사례 연구와 프로젝트들을 한국어/영어로 소개하며, Spring Boot 마이그레이션, 공유 플랫폼 설계, Flutter 개발 경험 개선 등의 내용을 담고 있습니다.

A bilingual portfolio built with Flutter Web to showcase full-stack case studies—Spring Boot migrations, shared platform design, and Flutter DX improvements. It ships with internationalized content, Markdown/YAML powered data pipelines, and an interactive OpenAPI explorer.

## 🏗️ 프로젝트 아키텍처 (Project Architecture)

### 📋 핵심 기술 스택 (Core Technology Stack)
- **프론트엔드**: Flutter Web 3.19+
- **상태 관리**: Riverpod (Provider 패턴)
- **라우팅**: GoRouter (선언적 라우팅)
- **다국어 지원**: Flutter l10n (영어/한국어)
- **콘텐츠 관리**: YAML + Markdown
- **스타일링**: Material Design 3 + Custom Themes
- **배포**: GitHub Pages (자동 CI/CD)

### 🗂️ 프로젝트 구조 (Project Structure)
```
📦 portfolio/
├── 📱 lib/                          # Flutter 앱 소스 코드
│   ├── 🏠 main.dart                 # 앱 진입점 (ProviderScope + MaterialApp)
│   ├── 🗺️ router.dart               # GoRouter 라우팅 설정
│   ├── 🌐 l10n/                     # 자동 생성된 다국어 파일
│   ├── 📊 models/                   # 데이터 모델 (Project, Post, Profile 등)
│   ├── 🔄 state/                    # Riverpod 상태 관리
│   │   ├── locale_state.dart        # 언어 설정 상태
│   │   └── theme_state.dart         # 테마 설정 상태
│   ├── 🛠️ services/                 # 비즈니스 로직 서비스
│   │   └── content_loader.dart      # 마크다운/YAML 콘텐츠 로더
│   ├── 📄 features/                 # 기능별 페이지 구성
│   │   ├── common/                  # 공통 컴포넌트
│   │   │   └── widgets/app_shell.dart # 전체 앱 레이아웃
│   │   ├── home/                    # 홈페이지
│   │   ├── projects/                # 프로젝트 목록/상세
│   │   ├── blog/                    # 블로그 목록/상세
│   │   ├── api/                     # API 문서 (OpenAPI)
│   │   ├── resume/                  # 이력서
│   │   └── contact/                 # 연락처
│   └── 🎨 theme/                    # 커스텀 테마 설정
├── 📝 assets/                       # 정적 자산
│   ├── contents/                    # 콘텐츠 파일
│   │   ├── en/                      # 영어 콘텐츠
│   │   └── ko/                      # 한국어 콘텐츠
│   └── openapi/                     # OpenAPI 스펙 파일
├── 🧪 test/                         # 단위/위젯 테스트
├── 🌐 web/                          # 웹 전용 파일 (index.html, 파비콘 등)
└── 🔧 tool/                         # 빌드 도구 (sitemap 생성기)
```

## 🚀 핵심 기능 (Key Features)

### 🌍 다국어 지원 (Internationalization)
- **완전한 이중 언어 지원**: 모든 UI 텍스트와 콘텐츠가 한국어/영어로 제공
- **언어 설정 자동 저장**: 브라우저 localStorage에 언어 선택이 영구 저장
- **URL을 통한 언어 전환**: `?lang=ko` 또는 `?lang=en` 파라미터로 즉시 언어 변경
- **시스템 언어 자동 감지**: 설정이 없을 경우 브라우저/OS 언어 자동 적용

### 📝 콘텐츠 관리 시스템 (Content Management)
- **YAML 기반 메타데이터**: 프로젝트/블로그 정보를 구조화된 YAML로 관리
- **마크다운 본문**: 콘텐츠 작성은 마크다운으로 간편하게
- **언어별 폴더 구조**: `assets/contents/{en,ko}/`로 깔끔한 콘텐츠 분리
- **타입 안전한 모델링**: Dart 클래스로 콘텐츠 구조를 타입 안전하게 정의

### 🔗 API 문서 통합 (OpenAPI Integration)
- **대화형 API 탐색기**: OpenAPI 스펙 파일을 읽어 동적으로 API 문서 생성
- **cURL 명령어 자동 생성**: API 테스트를 위한 인증된 cURL 스니펫 제공
- **검색 및 필터링**: API 엔드포인트를 빠르게 찾을 수 있는 검색 기능
- **Mock 응답 토글**: 개발 중 목업 데이터 사용 여부를 쉽게 전환

### 🎨 반응형 디자인 (Responsive Design)
- **모바일 퍼스트**: 720px 기준점으로 모바일/데스크톱 최적화
- **적응형 네비게이션**: 모바일에서는 햄버거 메뉴, 데스크톱에서는 수평 네비게이션
- **다크/라이트 테마**: 시스템 테마 자동 감지 및 수동 전환 지원
- **부드러운 애니메이션**: 테마 전환과 페이지 이동에 자연스러운 애니메이션 적용

### ♿ 접근성 (Accessibility)
- **키보드 네비게이션**: 모든 UI 요소에 키보드로 접근 가능
- **스크린 리더 지원**: 시맨틱 마크업과 ARIA 속성으로 스크린 리더 최적화
- **포커스 관리**: 드로어 열기/닫기 시 논리적인 포커스 이동
- **고대비 지원**: 다크 테마에서 충분한 색상 대비 확보

### 🔍 SEO 최적화 (SEO Optimization)
- **메타 태그 최적화**: 페이지별 title, description, 키워드 설정
- **Open Graph 지원**: 소셜 미디어 공유 시 리치 프리뷰 제공
- **자동 사이트맵 생성**: 빌드 시 sitemap.xml과 robots.txt 자동 생성
- **시맨틱 HTML**: 검색 엔진 크롤링에 최적화된 구조적 마크업

## 🚀 개발 시작하기 (Getting Started)

### 📋 개발 환경 요구사항 (Development Requirements)
- **Flutter SDK**: 3.19.0 이상
- **Dart SDK**: 3.3.0 이상
- **Chrome 브라우저**: 웹 개발 및 디버깅용
- **Git**: 버전 관리 및 GitHub Pages 배포용

### ⚡ 빠른 시작 (Quick Start)
```bash
# 1. 저장소 클론
git clone https://github.com/your-username/portfolio.git
cd portfolio

# 2. 의존성 설치
flutter pub get

# 3. 웹에서 앱 실행 (개발 모드)
flutter run -d chrome

# 4. 코드 품질 검사
dart format .            # 코드 포맷팅
flutter analyze          # 정적 분석 (린트 검사)
flutter test             # 단위/위젯 테스트 실행
```

### 🛠️ 개발 명령어 모음 (Development Commands)
```bash
# === 기본 개발 명령어 ===
flutter run -d chrome                    # 개발 서버 시작
flutter run -d chrome --hot-reload       # 핫 리로드로 실행
flutter run -d chrome --release          # 릴리즈 모드로 실행

# === 빌드 명령어 ===
flutter build web                        # 로컬 빌드 (개발용)
flutter build web --release              # 프로덕션 빌드
flutter build web --base-href /portfolio/  # GitHub Pages용 빌드

# === 품질 관리 ===
dart format .                            # 전체 코드 포맷팅
flutter analyze                          # 정적 분석 실행
flutter test                             # 모든 테스트 실행
flutter test test/specific_test.dart     # 특정 테스트 파일만 실행
flutter test --coverage                  # 테스트 커버리지 생성

# === 다국어 지원 ===
flutter gen-l10n                         # 번역 파일 생성 (ARB → Dart)

# === 배포 관련 ===
dart run tool/sitemap.dart --out build/web  # 사이트맵 생성

# === 정리 명령어 ===
flutter clean                            # 빌드 파일 정리
flutter pub get                          # 의존성 재설치
```

## 🔄 애플리케이션 플로우 (Application Flow)

### 📱 앱 시작 흐름 (App Startup Flow)
```
1. main.dart
   ├─ ProviderScope 초기화 (Riverpod 상태 관리 시작)
   └─ PortfolioApp 실행

2. PortfolioApp (main.dart)
   ├─ 언어 설정 복원 (localStorage → savedLocaleProvider)
   ├─ 테마 설정 복원 (localStorage → savedThemeModeProvider)
   ├─ GoRouter 설정 로드 (router.dart)
   └─ MaterialApp.router 생성

3. GoRouter (router.dart)
   ├─ ShellRoute로 모든 페이지를 AppShell로 감싸기
   └─ 각 경로별 페이지 위젯 매핑

4. AppShell (app_shell.dart)
   ├─ URL 쿼리 파라미터 언어 처리 (?lang=ko|en)
   ├─ 반응형 레이아웃 결정 (720px 기준)
   ├─ 네비게이션 바/드로어 렌더링
   └─ 하위 페이지 콘텐츠 표시
```

### 🔄 상태 관리 구조 (State Management Architecture)

#### Riverpod Provider 계층구조
```
📊 Global State
├── 🌐 selectedLocaleProvider (현재 세션 언어)
├── 💾 savedLocaleProvider (저장된 언어 설정)
├── 🎨 selectedThemeModeProvider (현재 세션 테마)
├── 💾 savedThemeModeProvider (저장된 테마 설정)
├── 🗺️ routerProvider (GoRouter 인스턴스)
└── 📄 contentProvider (비동기 콘텐츠 로딩)

📄 Page-specific State
├── 📝 projectsProvider (프로젝트 목록)
├── 📋 projectFilterProvider (프로젝트 필터)
├── ✍️ postsProvider (블로그 포스트 목록)
└── 🔍 searchProvider (검색 기능)
```

#### 상태 변화 흐름
```
사용자 액션 → Provider 업데이트 → UI 자동 재렌더링

예시: 언어 전환
1. 사용자가 언어 메뉴 클릭
2. setLocale() 함수 호출
3. selectedLocaleProvider 상태 업데이트
4. localStorage에 언어 설정 저장
5. MaterialApp이 자동으로 locale 변경 감지
6. 모든 위젯이 새로운 언어로 재렌더링
```

### 📄 콘텐츠 로딩 플로우 (Content Loading Flow)
```
앱 시작
├─ ContentLoader.loadProjects()
│  ├─ assets/contents/{locale}/projects.yaml 읽기
│  ├─ 각 프로젝트의 마크다운 파일 로드
│  └─ Project 모델 객체 생성
├─ ContentLoader.loadPosts() (블로그 포스트)
├─ ContentLoader.loadProfile() (프로필 정보)
└─ OpenAPILoader.load() (API 스펙 파일)

결과 → FutureProvider로 캐싱 → UI에서 사용
```

### 🗂️ 디렉토리 구조 상세 (Detailed Directory Structure)
| Path | Description |
| --- | --- |
| `lib/` | Flutter 애플리케이션 코드 (기능별 폴더 구조) |
| `lib/state/` | Riverpod Provider들과 상태 관리 로직 |
| `lib/services/` | 콘텐츠 로더 (YAML/Markdown), 로컬 스토리지, 유틸리티 |
| `assets/contents/{en,ko}/` | 언어별 콘텐츠 파일 (YAML 메타데이터 + Markdown 본문) |
| `assets/openapi/openapi.json` | API 탐색기에서 사용하는 OpenAPI 스펙 |
| `test/` | 단위/위젯 테스트 (기능 구조와 동일하게 구성) |
| `web/` | 웹 전용 파일 (HTML 셸, 매니페스트, 파비콘, 공유 이미지) |

## ✏️ 콘텐츠 편집 가이드 (Content Editing Guide)

### 📁 콘텐츠 파일 구조
```
assets/contents/
├── en/                          # 영어 콘텐츠
│   ├── profile.yaml            # 프로필 정보
│   ├── projects.yaml           # 프로젝트 목록 메타데이터
│   ├── posts.yaml              # 블로그 포스트 목록 메타데이터
│   ├── projects/               # 프로젝트 상세 마크다운
│   │   ├── spring-migration.md
│   │   └── flutter-dx.md
│   └── posts/                  # 블로그 포스트 마크다운
│       └── my-first-post.md
└── ko/                          # 한국어 콘텐츠 (동일 구조)
```

### 📝 새 프로젝트 추가하기
1. **메타데이터 추가**: `assets/contents/{언어}/projects.yaml`에 프로젝트 정보 추가
```yaml
- id: "new-project"
  title: "새 프로젝트"
  description: "프로젝트 간단 설명"
  tech: ["Flutter", "Firebase"]
  status: "completed"
  links:
    github: "https://github.com/user/repo"
    demo: "https://demo.com"
```

2. **상세 내용 작성**: `assets/contents/{언어}/projects/new-project.md` 파일 생성
```markdown
---
title: "새 프로젝트 상세"
date: "2024-01-01"
---

# 프로젝트 상세 설명
상세한 프로젝트 설명을 마크다운으로 작성...
```

### 🌐 다국어 번역 추가하기
1. **UI 텍스트**: `lib/l10n/app_ko.arb`와 `app_en.arb`에 새 키 추가
2. **번역 생성**: `flutter gen-l10n` 실행하여 Dart 파일 자동 생성
3. **콘텐츠 번역**: `assets/contents/` 폴더에서 언어별로 동일한 구조로 파일 생성

## 🧪 테스트 & 품질 보증 (Testing & QA)

### 테스트 구조
```
test/
├── unit/                        # 단위 테스트
│   ├── services/
│   │   └── content_loader_test.dart  # 콘텐츠 로더 테스트
│   └── models/                  # 데이터 모델 테스트
├── widget/                      # 위젯 테스트
│   ├── features/
│   │   ├── contact/
│   │   └── projects/
│   └── common/
└── integration/                 # 통합 테스트 (향후 추가)
```

### 테스트 실행
```bash
# 모든 테스트 실행
flutter test

# 커버리지 포함 테스트
flutter test --coverage

# 특정 테스트만 실행
flutter test test/unit/services/content_loader_test.dart
```

## 🚀 배포 & CI/CD (Deployment & CI/CD)

### GitHub Actions 워크플로우
`.github/workflows/deploy-pages.yml`에서 자동 배포 파이프라인 관리:

```
1. 코드 푸시 (main 브랜치)
   ↓
2. Flutter 환경 설정
   ↓
3. 의존성 설치 (flutter pub get)
   ↓
4. 정적 분석 (flutter analyze)
   ↓
5. 테스트 실행 (flutter test)
   ↓
6. 웹 빌드 (flutter build web)
   ↓
7. 사이트맵 생성 (dart run tool/sitemap.dart)
   ↓
8. GitHub Pages 배포
```

### 로컬 빌드 및 배포
```bash
# GitHub Pages용 빌드 (저장소 이름을 본인 것으로 변경)
flutter build web --base-href /your-repo-name/

# 사이트맵 및 robots.txt 생성
dart run tool/sitemap.dart --out build/web

# 빌드 결과 확인
cd build/web && python3 -m http.server 8000
```

## 🎓 Flutter 초보자를 위한 학습 리소스 (Learning Resources for Flutter Beginners)

### 핵심 개념 이해하기
1. **Widget Tree**: Flutter의 모든 것은 위젯(Widget)으로 구성됨
2. **State Management**: Riverpod으로 앱 전체 상태 관리
3. **Hot Reload**: 코드 변경사항을 즉시 반영하는 Flutter의 핵심 기능
4. **Responsive Design**: 다양한 화면 크기에 대응하는 적응형 UI

### 이 프로젝트에서 배울 수 있는 패턴
- ✅ **Provider 패턴**: Riverpod을 사용한 상태 관리
- ✅ **Repository 패턴**: ContentLoader를 통한 데이터 계층 분리
- ✅ **Feature-based Architecture**: 기능별 폴더 구조
- ✅ **Responsive Layout**: LayoutBuilder와 MediaQuery 활용
- ✅ **Internationalization**: 다국어 지원 구현
- ✅ **Asset Management**: 정적 자산과 콘텐츠 관리

### 추천 학습 순서
1. 📖 `lib/main.dart` - 앱 진입점과 기본 설정 이해
2. 🗺️ `lib/router.dart` - 페이지 라우팅 시스템 이해
3. 🏠 `lib/features/common/widgets/app_shell.dart` - 공통 레이아웃 패턴 학습
4. 🔄 `lib/state/` - Riverpod 상태 관리 패턴 학습
5. 📄 `lib/features/` - 각 기능별 페이지 구현 방법 학습

### 유용한 Flutter 리소스
- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Riverpod 공식 문서](https://riverpod.dev/)
- [GoRouter 공식 문서](https://pub.dev/packages/go_router)
- [Flutter Web 가이드](https://docs.flutter.dev/platform-integration/web)

## 🔧 문제 해결 (Troubleshooting)

### 자주 발생하는 문제들
1. **번역 파일이 생성되지 않을 때**: `flutter gen-l10n` 실행
2. **Hot Reload가 작동하지 않을 때**: `flutter clean` 후 재시작
3. **의존성 충돌 발생 시**: `flutter pub deps` 명령으로 의존성 트리 확인
4. **빌드 오류 발생 시**: `flutter doctor` 명령으로 환경 상태 확인

### 디버깅 팁
- Chrome DevTools를 활용한 웹 디버깅
- `print()` 대신 `debugPrint()` 사용 권장
- Riverpod DevTools 확장 프로그램 활용
- Flutter Inspector로 위젯 트리 분석

---

이 프로젝트는 실무에서 사용되는 Flutter Web 개발 패턴들을 종합적으로 보여주는 예제입니다. 코드의 주석과 이 문서를 함께 읽으며 학습하시면 Flutter Web 개발에 대한 전반적인 이해를 얻으실 수 있습니다.
