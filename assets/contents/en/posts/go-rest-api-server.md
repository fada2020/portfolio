---
title: "Building a Portfolio REST API Server with Go"
date: 2024-09-26
tags: ["Go", "REST API", "Docker", "AWS", "ECS", "Fargate", "CI/CD"]
description: "Building and deploying a Go REST API server for portfolio using Gin framework and AWS Free Tier"
---

# Building a Portfolio REST API Server with Go

To enhance my portfolio, I built a REST API server using Go and deployed it to AWS Free Tier for cost-effective production hosting.

## 🎯 Project Goals

- **High-Performance REST API**: Fast API server using Go and Gin framework
- **Complete CRUD Operations**: User, project, and skills management features
- **Analytics**: Portfolio visit statistics and analysis
- **Cost-Effective Deployment**: Leveraging AWS Free Tier
- **Automation**: CI/CD pipeline with GitHub Actions

## 🏗️ Tech Stack

### Backend
- **Go 1.23**: High performance with clean syntax
- **Gin Framework**: Fast HTTP web framework
- **Swagger/OpenAPI**: Automated API documentation

### DevOps & Deployment
- **Docker**: Containerization for consistent deployment
- **AWS ECS Fargate**: Serverless container execution
- **AWS ECR**: Docker image registry
- **GitHub Actions**: CI/CD automation
- **Terraform**: Infrastructure as Code

## 📁 Project Structure

```
portfolio-api/
├── main.go                 # Application entry point
├── handlers/               # HTTP handlers
├── models/                 # Data models
├── docs/                   # API documentation
├── terraform/              # AWS infrastructure
├── .github/workflows/      # CI/CD pipelines
├── Dockerfile              # Container definition
└── docker-compose.yml      # Local development
```

## 🚀 Key Features

### 1. User Management API
```go
// GET /api/v1/users - List users
// POST /api/v1/users - Create user
// GET /api/v1/users/:id - Get user by ID
// PUT /api/v1/users/:id - Update user
// DELETE /api/v1/users/:id - Delete user
```

### 2. Project Management API
```go
// GET /api/v1/projects - List projects (with filtering)
// POST /api/v1/projects - Create project
// GET /api/v1/projects/:id - Get project by ID
// PUT /api/v1/projects/:id - Update project
// DELETE /api/v1/projects/:id - Delete project
```

### 3. Skills API
```go
// GET /api/v1/skills - List skills (category filtering)
// POST /api/v1/skills - Add skill
// DELETE /api/v1/skills/:id - Remove skill
```

### 4. Analytics API
```go
// GET /api/v1/stats/views - Visit statistics
// GET /api/v1/stats/projects - Project statistics
// POST /api/v1/stats/visit - Record visit
```

## 🐳 Docker Containerization

Optimized container image using multi-stage build:

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

## ☁️ 100% Free Deployment + Supabase

### Deployment Options (All Free!)
1. **Railway** (Recommended): $5 monthly credits, Supabase integration
2. **Render**: 750 hours/month, 15-minute sleep mode
3. **Fly.io**: 1000 hours/month, global edge

### 🚀 Supabase Integration Architecture
```
GitHub → Railway → Supabase PostgreSQL
         ↓              ↓
    Go API Server ← → Real-time Database
                       Auth & RLS
```

**Supabase + Railway Deployment Process**:
1. **Supabase Project** → Free PostgreSQL + Authentication
2. **Connect GitHub** → Select repository
3. **Auto Detection** → Dockerfile-based build
4. **Environment Setup** → Supabase URL/Key integration
5. **Domain Provided** → `portfolio-api.up.railway.app`

## 📊 Performance & Results

### API Response Performance
- **Health Check**: ~1ms
- **Simple Queries**: ~5ms
- **Complex Statistics**: ~15ms

### Cost Efficiency + Supabase Benefits
- **Hosting Cost**: $0/month (Completely free)
- **Database**: $0/month (Supabase PostgreSQL 500MB)
- **Authentication**: $0/month (Unlimited users)
- **Real-time Features**: $0/month (WebSocket free)
- **Storage**: $0/month (1GB file storage)
- **Domain**: $0/month (Subdomain provided)
- **Scalability**: Upgrade to paid plans when needed

## 🔗 Portfolio Integration

Integrated with Flutter portfolio's OpenAPI explorer for real API testing:

```dart
// Added new API spec
const apiSpecs = [
  'assets/openapi/openapi.json',        // Existing demo API
  'assets/openapi/portfolio-api.json',  // New portfolio API
];
```

## 🎓 Lessons Learned

1. **Go's Strengths**: High performance with clean, concise code
2. **Docker Optimization**: Multi-stage builds for minimal image size
3. **AWS Free Tier Value**: Production environment at zero cost
4. **CI/CD Automation**: Improved development productivity
5. **Infrastructure as Code**: Reproducible infrastructure with Terraform

## 🚀 Supabase Core Features

### 🔐 Row Level Security (RLS)
- **Automatic Security**: Table-level access control auto-configured
- **Public/Private**: Profile and project visibility control
- **Data Protection**: SQL-level data access restrictions

### ⚡ Real-time Features
- **Live Updates**: Instant data synchronization
- **WebSocket**: Built-in real-time connections
- **Event Subscriptions**: Track specific table/row changes

### 🎨 Auto-Generated APIs
- **REST API**: Automatic table-based API generation
- **GraphQL**: Complex query support
- **Type Safety**: Automatic TypeScript type generation

## 🔜 Future Improvements

- ✅ **Supabase Integration**: PostgreSQL + RLS + Real-time complete
- **Social Login**: GitHub/Google OAuth integration
- **File Upload**: Supabase Storage for image management
- **Email Authentication**: Automatic email sending system
- **Edge Functions**: Serverless function additions
- **Real-time Chat**: Live visitor communication

## 🔗 Related Links

- [GitHub Repository](https://github.com/hyoukjoolee/portfolio-api)
- [API Documentation](https://api.hyoukjoolee.dev/swagger)
- [Portfolio Website](https://hyoukjoolee.github.io/portfolio)

---

This project demonstrated Go's power and AWS Free Tier's potential. I'll continue adding features and evolving my portfolio with new capabilities.