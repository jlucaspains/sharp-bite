---
title: "Project Setup"
work-item-url: https://github.com/jlucaspains/sharp-bite/issues/65
status: draft
authors: lpains
version: 1.0
---

# Project Setup Spec

## 1. Overview

This spec defines the initial project scaffolding for SharpBite: the directory structure, toolchain, and CI/CD pipeline that all subsequent features will build upon.

## 2. Tech Stack

| Concern | Choice |
|---------|--------|
| Framework | React |
| Language | TypeScript |
| Package manager | npm |
| Unit testing | Vitest |
| E2E testing | Playwright |
| Hosting | Azure Static Web Apps |

## 3. Directory Structure

```
sharp-bite/
├── src/                    # Application source code
│   ├── assets/             # Static assets (images, fonts, icons)
│   ├── components/         # Reusable UI components
│   ├── pages/              # Page-level components / route targets
│   ├── hooks/              # Custom React hooks
│   ├── services/           # Business logic and data access
│   ├── types/              # Shared TypeScript type definitions
│   └── main.tsx            # Application entry point
├── tests/
│   ├── unit/               # Vitest unit tests mirroring src/ structure
│   └── e2e/                # Playwright end-to-end tests
├── docs/                   # Project documentation and ADRs
├── public/                 # Static files served at root (manifest, icons)
├── .github/
│   └── workflows/          # GitHub Actions workflow files
├── index.html
├── package.json
├── tsconfig.json
├── vite.config.ts
└── playwright.config.ts
```

## 4. GitHub Actions – PR Validation Workflow

A workflow triggered on every pull request to `main` must run all three stages in order. The PR must not be mergeable if any stage fails.

### Trigger

```
on:
  pull_request:
    branches: [main]
```

### Stages

| Stage | Tool | Pass Criteria |
|-------|------|---------------|
| **Build** | `npm run build` | Exit code 0; build artifacts produced in `dist/` |
| **Unit tests** | `npx vitest run` | All tests pass; no test failures |
| **E2E tests** | `npx playwright test` | All scenarios pass against the built artefact |

### Notes
- E2E tests run against the production build (`dist/`) using a local static server (e.g. `npx serve dist`), not a dev server.
- The workflow must cache `node_modules` keyed on `package-lock.json` to keep run times short.
- Test results and the Playwright HTML report are uploaded as workflow artefacts on failure for debugging.

## 5. Staging Deployment

Deployment artefacts from a merged PR are automatically pushed to a staging slot on **Azure Static Web Apps** for human validation before production promotion.

### Trigger

```
on:
  push:
    branches: [main]
```

### Deployment steps

1. Build the project (`npm run build`).
2. Deploy `dist/` to the Azure Static Web App staging environment using the [Azure Static Web Apps GitHub Action](https://github.com/Azure/static-web-apps-deploy).
3. The action posts the staging URL as a comment on the merged PR for easy access.

### Configuration

| Item | Detail |
|------|--------|
| Azure resource | Azure Static Web App (staging slot or preview environment) |
| Secret name | `AZURE_STATIC_WEB_APPS_API_TOKEN` stored as a GitHub repository secret |
| Build output path | `dist/` |
| App location | `/` (repo root) |

## 6. Acceptance Criteria

| # | Criterion | Verifiable by |
|---|-----------|---------------|
| AC1 | Repository contains the directory structure defined in §3 with placeholder files where necessary | Code review |
| AC2 | `npm run build` completes without errors | CI log |
| AC3 | `npx vitest run` passes with at least one smoke-test | CI log |
| AC4 | `npx playwright test` passes with at least one smoke-test | CI log |
| AC5 | A GitHub Actions workflow runs build → unit tests → E2E tests on every PR to `main` | Workflow file + CI run |
| AC6 | Merging to `main` triggers an automatic deployment to the Azure Static Web Apps staging environment | Deployment log + staging URL |

## 7. Out of Scope

- Production deployment and promotion strategy.
- Environment-specific configuration management (`.env` handling) beyond what the scaffolding requires.
- Authentication or access control for the staging environment.
