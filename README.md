# Conversational CV

[![CI](https://github.com/diegopamio/conversational-cv/actions/workflows/ci.yml/badge.svg)](https://github.com/diegopamio/conversational-cv/actions/workflows/ci.yml)
[![Deploy](https://github.com/diegopamio/conversational-cv/actions/workflows/deployment.yml/badge.svg)](https://github.com/diegopamio/conversational-cv/actions/workflows/deployment.yml)
[![Database Migrations](https://github.com/diegopamio/conversational-cv/actions/workflows/db-migrations.yml/badge.svg)](https://github.com/diegopamio/conversational-cv/actions/workflows/db-migrations.yml)

A modern, AI-powered application for managing and presenting your professional experience through natural conversation.

## Project Overview

This project implements a conversational interface for career profiles and resumes. Built with a Next.js monorepo architecture, it allows users to interact with professional information in a natural, conversational format.

## Key Features

- Interactive conversational interface for exploring resume information
- LinkedIn integration for data import
- Interview session feature for practice
- Multi-tenant architecture for multiple user profiles
- Modern UI with responsive design

## Technology Stack

- **Frontend:** Next.js, React, TypeScript
- **Database:** PostgreSQL with Prisma ORM
- **Authentication:** Clerk
- **Deployment:** Vercel + GitHub Actions
- **Infrastructure:** Monorepo using Turborepo

## Repository Structure

```
conversational-cv/
├── apps/                  # Application code
│   ├── app/               # Main application (dashboard, user interface)
│   ├── api/               # API service
│   └── web/               # Marketing/landing website
├── packages/              # Shared libraries
│   ├── database/          # Prisma schema, migrations
│   ├── auth/              # Authentication components/logic
│   ├── design-system/     # UI component library
│   └── ... (other shared packages)
└── scripts/               # Build and deployment scripts
```

## Deployment Strategy

We use a hybrid approach combining GitHub Actions with Vercel for deployments. This section explains our reasoning and setup.

### Why GitHub Actions + Vercel?

While Vercel offers built-in deployment capabilities directly from GitHub repositories, we've chosen to use GitHub Actions to orchestrate our deployments for several key reasons:

1. **Monorepo Control**: Our monorepo contains multiple applications (app, api, web) that deploy to different Vercel projects. GitHub Actions provides better coordination for deploying these interconnected services.

2. **Database Migrations**: Our deployment process includes database migration steps, which Vercel's standard deployment doesn't handle. GitHub Actions lets us run migrations before deployment to ensure data consistency.

3. **Advanced Testing**: GitHub Actions runs comprehensive test suites before deployment, preventing broken code from reaching production.

4. **Conditional Deployments**: We can implement logic to only deploy specific apps when their code changes, improving efficiency.

5. **Deployment Orchestration**: GitHub Actions allows us to coordinate multiple deployment targets and stages with appropriate dependencies between them.

### GitHub Environments for Multi-Stage Deployments

We leverage GitHub Environments to properly separate deployment targets and their configurations:

1. **Environment Structure**:
   - **Development**: For development/feature branch deployments
   - **Staging**: For pre-production testing
   - **Production**: For live deployments
   
   For each app in our monorepo, we have app-specific environments:
   - **Development-web**, **Development-app**, **Development-api**
   - **Staging-web**, **Staging-app**, **Staging-api**
   - **Production-web**, **Production-app**, **Production-api**

2. **Environment-Specific Secrets**:
   - Each environment has its own set of secrets
   - Production environments have added protection rules like required approvals and wait timers
   - Base environments hold shared secrets, while app-specific environments hold app-specific secrets

3. **Workflow Integration**:
   Our GitHub Actions workflows use the `environment` directive to select the appropriate environment:
   ```yaml
   jobs:
     deploy-web:
       # ...
       environment: Production-web
       # This will use the secrets from the Production-web environment
   ```

### Setting Up GitHub Environments

We've created a script to automatically set up all GitHub environments for the project:

```bash
./scripts/setup-github-environments.sh <github-username/repo-name>
```

This script will:
1. Create all necessary environments (Development, Staging, Production) for each app
2. Set appropriate protection rules for production environments
3. Configure environment-specific secrets from your existing secrets
4. Optionally update your GitHub Action workflow files to use these environments

### How Our CI/CD Pipeline Works

Our CI/CD pipeline follows these steps:

1. **Code Push**: Developer pushes code to GitHub
2. **GitHub Actions Triggers**: Workflows start based on branch or PR events
3. **Testing & Validation**: Run tests, linting, and type checking
4. **Database Migrations**: Apply database schema changes if needed
5. **Build**: Build applications for deployment
6. **Deploy to Vercel**: Use Vercel API to deploy each application to the appropriate environment

### Key Workflow Files

- `ci.yml`: Testing, linting, type checking
- `deployment.yml`: Deploys applications to Vercel
- `db-migrations.yml`: Handles database schema changes

## Getting Started

### Prerequisites

- Node.js 18+
- pnpm 8+
- PostgreSQL database

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/diegopamio/conversational-cv.git
   cd conversational-cv
   ```

2. Install dependencies:
   ```bash
   pnpm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   ```
   Then edit `.env.local` with your configuration.

4. Set up the database:
   ```bash
   pnpm db:push
   ```

5. Start the development server:
   ```bash
   pnpm dev
   ```

### Deployment Setup

We provide two scripts for setting up deployments:

1. **Basic Vercel + GitHub setup**:
   ```bash
   ./scripts/deploy-setup.sh [username/repo-name]
   ```
   This script extracts Vercel credentials and environment variables, then uploads them as GitHub secrets.

2. **Complete GitHub Environments setup**:
   ```bash
   ./scripts/setup-github-environments.sh [username/repo-name]
   ```
   This script creates proper GitHub environments with environment-specific secrets and protection rules.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
