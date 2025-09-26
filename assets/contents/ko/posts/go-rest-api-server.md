---
title: "Go로 포트폴리오 REST API 서버 구축하기"
date: 2024-09-26
tags: ["Go", "REST API", "Docker", "AWS", "ECS", "Fargate", "CI/CD"]
description: "Gin 프레임워크를 사용해 포트폴리오용 Go REST API 서버를 구축하고 AWS Free Tier에 배포하는 과정"
---

# Go로 포트폴리오 REST API 서버 구축하기

포트폴리오를 더욱 풍부하게 만들기 위해 Go로 REST API 서버를 구축하고 AWS Free Tier에 배포해보았습니다.

## 🎯 프로젝트 목표

- **고성능 REST API**: Go와 Gin 프레임워크로 빠른 API 서버 구축
- **완전한 CRUD**: 사용자, 프로젝트, 기술스택 관리 기능
- **통계 분석**: 포트폴리오 방문 통계 및 분석 기능
- **무료 배포**: AWS Free Tier를 활용한 비용 효율적 배포
- **자동화**: GitHub Actions를 통한 CI/CD 파이프라인

## 🏗️ 기술 스택

### Backend
- **Go 1.23**: 높은 성능과 간결한 문법
- **Gin Framework**: 빠른 HTTP 웹 프레임워크
- **Swagger/OpenAPI**: API 문서화 자동화

### DevOps & 배포
- **Docker**: 컨테이너화로 일관된 배포 환경
- **AWS ECS Fargate**: 서버리스 컨테이너 실행
- **AWS ECR**: Docker 이미지 저장소
- **GitHub Actions**: CI/CD 자동화
- **Terraform**: Infrastructure as Code

## 📁 프로젝트 구조

```
portfolio-api/
├── main.go                 # 애플리케이션 진입점
├── handlers/               # HTTP 핸들러
├── models/                 # 데이터 모델
├── docs/                   # API 문서
├── terraform/              # AWS 인프라 설정
├── .github/workflows/      # CI/CD 파이프라인
├── Dockerfile              # 컨테이너 정의
└── docker-compose.yml      # 로컬 개발 환경
```

## 🚀 주요 기능

### 1. 사용자 관리 API
```go
// GET /api/v1/users - 사용자 목록 조회
// POST /api/v1/users - 새 사용자 생성
// GET /api/v1/users/:id - 특정 사용자 조회
// PUT /api/v1/users/:id - 사용자 정보 수정
// DELETE /api/v1/users/:id - 사용자 삭제
```

### 2. 프로젝트 관리 API
```go
// GET /api/v1/projects - 프로젝트 목록 (필터링 지원)
// POST /api/v1/projects - 새 프로젝트 생성
// GET /api/v1/projects/:id - 특정 프로젝트 조회
// PUT /api/v1/projects/:id - 프로젝트 정보 수정
// DELETE /api/v1/projects/:id - 프로젝트 삭제
```

### 3. 기술 스택 API
```go
// GET /api/v1/skills - 기술 목록 (카테고리별 필터링)
// POST /api/v1/skills - 새 기술 추가
// DELETE /api/v1/skills/:id - 기술 제거
```

### 4. 통계 및 분석 API
```go
// GET /api/v1/stats/views - 방문 통계
// GET /api/v1/stats/projects - 프로젝트 통계
// POST /api/v1/stats/visit - 방문 기록
```

## 🐳 Docker 컨테이너화

멀티스테이지 빌드로 최적화된 컨테이너 이미지 생성:

```dockerfile
# Build stage
FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Production stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]
```

## ☁️ 100% 무료 배포 + Supabase

### 배포 옵션 (모두 무료!)
1. **Railway** (추천): 매월 $5 크레딧, Supabase 연동
2. **Render**: 750시간/월, 15분 슬립모드
3. **Fly.io**: 1000시간/월, 글로벌 엣지

### 🚀 Supabase 통합 아키텍처
```
GitHub → Railway → Supabase PostgreSQL
         ↓              ↓
    Go API 서버 ← → 실시간 데이터베이스
                     인증 & RLS
```

**Supabase + Railway 배포 과정**:
1. **Supabase 프로젝트** → 무료 PostgreSQL + 인증
2. **GitHub 연결** → 저장소 선택
3. **자동 감지** → Dockerfile 기반 빌드
4. **환경변수 설정** → Supabase URL/Key 자동 연동
5. **도메인 제공** → `portfolio-api.up.railway.app`

## 📊 성능 및 결과

### API 응답 성능
- **Health Check**: ~1ms
- **단순 조회**: ~5ms
- **복잡한 통계**: ~15ms

### 비용 효율성 + Supabase 혜택
- **호스팅 비용**: $0/월 (완전 무료)
- **데이터베이스**: $0/월 (Supabase PostgreSQL 500MB)
- **인증 시스템**: $0/월 (무제한 사용자)
- **실시간 기능**: $0/월 (WebSocket 무료)
- **스토리지**: $0/월 (1GB 파일 저장)
- **도메인**: $0/월 (서브도메인 제공)
- **확장성**: 필요 시 유료 플랜으로 업그레이드

## 🔗 포트폴리오 연동

Flutter 포트폴리오의 OpenAPI 탐색기에서 실제 API를 테스트할 수 있도록 연동:

```dart
// 새로운 API 스펙 추가
const apiSpecs = [
  'assets/openapi/openapi.json',        // 기존 데모 API
  'assets/openapi/portfolio-api.json',  // 새 포트폴리오 API
];
```

## 🎓 배운 점

1. **Go의 장점**: 간결한 코드로 높은 성능 달성
2. **Docker 최적화**: 멀티스테이지 빌드로 이미지 크기 최소화
3. **무료 호스팅 활용**: Railway, Render, Fly.io 등으로 비용 없는 배포
4. **자동 배포**: GitHub 연동으로 푸시만으로 배포 완료
5. **PostgreSQL 무료 활용**: 실제 데이터베이스를 무료로 사용

## 🚀 Supabase 핵심 기능

### 🔐 Row Level Security (RLS)
- **자동 보안**: 테이블별 접근 권한 자동 설정
- **공개/비공개**: 프로필과 프로젝트의 공개 설정 제어
- **데이터 보호**: SQL 레벨에서 데이터 접근 제한

### ⚡ 실시간 기능
- **실시간 업데이트**: 데이터 변경 시 즉시 반영
- **WebSocket**: 추가 설정 없이 실시간 연결
- **이벤트 구독**: 특정 테이블/행 변경 감지

### 🎨 자동 API 생성
- **REST API**: 테이블 기반 자동 API 생성
- **GraphQL**: 복잡한 쿼리 지원
- **타입 안정성**: TypeScript 타입 자동 생성

## 🔜 향후 개선 계획

- ✅ **Supabase 연동**: PostgreSQL + RLS + 실시간 완료
- **소셜 로그인**: GitHub/Google OAuth 연동
- **파일 업로드**: Supabase Storage로 이미지 관리
- **이메일 인증**: 자동 이메일 발송 시스템
- **Edge Functions**: 서버리스 함수 추가
- **실시간 채팅**: 방문자와 실시간 소통

## 🔗 관련 링크

- [GitHub Repository](https://github.com/hyoukjoolee/portfolio-api)
- [API 문서](https://api.hyoukjoolee.dev/swagger)
- [포트폴리오 웹사이트](https://hyoukjoolee.github.io/portfolio)

---

이번 프로젝트를 통해 Go의 강력함과 AWS Free Tier의 활용 가능성을 확인할 수 있었습니다. 앞으로도 더 많은 기능을 추가하며 포트폴리오를 발전시켜 나갈 예정입니다.