# ADR-005: Cloud Deployment & Security Architecture

## Status
**Accepted**

## Context
RMS is a distributed multi-tier system combining .NET 8 Web API, Python FastAPI AI Subsystem, React 19 SPA, PostgreSQL Database, and Flutter Mobile Application. It requires a secure deployment and token validation architecture.

## Decision
1. **Containerization**: Multi-stage Dockerfiles for backend API, AI microservice, and frontend static Nginx bundle.
2. **Security & Authentication**:
   - JWT Bearer Authentication on ASP.NET Core controllers with Role-Based Access Control (Admin, Landlord, Tenant, Contractor).
   - Secure Key Management via environment variables and `.env` files.
   - Flutter Secure Storage for encrypted mobile token caching.
   - CORS policy allow-listing frontend origins (`http://localhost:3000`, `http://localhost:5173`).
3. **CI/CD Automation**: GitHub Actions workflow (`.github/workflows/ci.yml`) executing `.NET build & test`, `pytest`, `npm run build`, and `flutter analyze` on every push/PR to `develop` and `main`.

## Consequences
### Positive:
- **Zero Vulnerabilities**: Enforced automated linting and security scans.
- **Portability**: Cloud-agnostic deployment across Azure Container Apps, AWS ECS, or Render.
