# GitHub Actions Workflows

This directory contains GitHub Actions workflows for CI/CD pipeline:

- `ci.yml`: Handles code quality checks and testing on all branches
- `deployment.yml`: Handles deployment to Vercel for main and dev branches
- `db-migrations.yml`: Handles database migrations using Prisma

## Required GitHub Secrets

For the deployment workflow to function correctly, you need to set up the following GitHub secrets:

### Vercel Deployment Secrets

1. **VERCEL_TOKEN**
   - A personal access token from Vercel
   - Get it from: https://vercel.com/account/tokens

2. **VERCEL_ORG_ID**
   - Your Vercel organization ID
   - Find it in your Vercel dashboard under Settings → General → Organization ID

3. **VERCEL_APP_PROJECT_ID**
   - The project ID for your main app (`apps/app`)
   - Find it in Vercel project settings under Settings → General → Project ID

4. **VERCEL_WEB_PROJECT_ID**
   - The project ID for your web app (`apps/web`)
   - Find it in Vercel project settings under Settings → General → Project ID

5. **VERCEL_API_PROJECT_ID**
   - The project ID for your API app (`apps/api`)
   - Find it in Vercel project settings under Settings → General → Project ID

6. **DATABASE_URL**
   - Your Neon PostgreSQL connection string for database migrations

## Setting Up Vercel Projects for next-forge Monorepo

Since next-forge uses a monorepo structure with multiple apps, you need to create a separate Vercel project for each app:

1. **Create Vercel Projects**:
   - Go to your Vercel dashboard and add a new project for each app
   - Import your GitHub repository for each project
   - For each project, set the "Root Directory" to the appropriate app directory:
     - `apps/app` for the main application
     - `apps/web` for the web (marketing/landing) site
     - `apps/api` for the backend API functions

2. **Configure Environment Variables**:
   - Add environment variables for each project
   - Consider using Vercel's "Team Environment Variables" feature to share common variables

3. **Get Project IDs**:
   - Once projects are created, get the Project ID from each project's settings
   - Add these IDs as GitHub Secrets (VERCEL_APP_PROJECT_ID, VERCEL_WEB_PROJECT_ID, VERCEL_API_PROJECT_ID)

## Setting Up GitHub Secrets

1. Go to your GitHub repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each secret with its corresponding value
4. Ensure all secrets are set before pushing to the main or dev branches

## How These Workflows Work

### CI Workflow
- Triggered on all pull requests and pushes to main/dev
- Runs linting, type checking, and tests
- Fails if any check doesn't pass

### Deployment Workflow
- Triggered on pushes to main/dev
- Deploys each app (app, web, api) to its respective Vercel project
- Pulls environment variables from Vercel for each project
- Builds the projects using Turborepo with app-specific filters
- Deploys to production if the branch is main, preview if the branch is dev

### Database Migration Workflow
- Triggered when schema changes or manually dispatched
- Runs migrations for the specified environment
- Verifies migration success

## Troubleshooting

If deployment fails, check:
1. GitHub Actions logs for specific errors
2. Vercel dashboard for deployment status
3. Ensure your Vercel secrets are correctly set
4. Verify that each Vercel project has the correct "Root Directory" setting
5. Make sure the correct environment variables are set for each project 