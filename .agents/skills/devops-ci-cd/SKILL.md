---
name: devops-ci-cd
description: GitHub Actions CI/CD workflows, automated build/test pipelines for .NET, React, Flutter, and LangGraph, and conventional commit standards.
---

# GitHub Actions CI/CD & Git Workflow Skill

## CI/CD Standards
1. **GitHub Actions Workflows**:
   - `dotnet-ci.yml`: Build, format check, and run xUnit test suite on pull requests.
   - `frontend-ci.yml`: Lint, type-check, and run React tests.
   - `flutter-ci.yml`: Flutter analyze, unit/widget testing.
   - `ai-agent-ci.yml`: Pytest and evaluation validation.

2. **Branching & Git Strategy**:
   - `main`: Production-ready release branch.
   - `develop`: Integration branch for sprint development.
   - Feature branches:
     - `feature/prop-lease-upamada`
     - `feature/tenant-screening-nethmi`
     - `feature/maintenance-hashini`

3. **Conventional Commits**:
   - `feat(module): description`
   - `fix(module): description`
   - `chore(deps): description`
   - `docs(readme): description`
   - `test(module): description`
