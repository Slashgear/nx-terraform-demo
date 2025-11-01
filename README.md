
# Managing Terraform Modules with Nx - Demo Project

This project demonstrates how to manage Terraform modules in an Nx monorepo, as described in the [blog post by SlashGear](https://blog.slashgear.dev/posts/managing-terraform-modules-with-nx/).

## What This Demo Shows

This project illustrates how Nx can help manage infrastructure-as-code at scale by:

- **Smart execution**: Only runs tasks on affected modules based on git changes
- **Dependency awareness**: Automatically understands module dependencies
- **Task orchestration**: Executes tasks in the correct order with intelligent caching
- **Parallel execution**: Runs independent tasks concurrently for faster CI/CD

## Project Structure

```
nx-terraform-demo/
├── modules/
│   ├── scw-vpc/              # VPC module (base infrastructure)
│   ├── scw-k8s/              # Kubernetes cluster (depends on VPC)
│   ├── scw-database/         # Database instance (depends on VPC)
│   ├── scw-object-storage/   # S3-compatible storage (independent)
│   ├── scw-registry/         # Container registry (independent)
│   ├── scw-loadbalancer/     # Load balancer (depends on VPC, K8s)
│   └── scw-monitoring/       # Observability stack (depends on K8s)
├── .github/
│   └── workflows/
│       └── ci.yml            # CI workflow using Nx affected commands
├── nx.json                   # Nx workspace configuration
├── .tflint.hcl              # TFLint configuration
└── .checkov.yaml            # Checkov security scanner configuration
```

## Module Dependencies

The modules have the following dependency structure:

```
scw-vpc (base)
  ├── scw-k8s (depends on VPC)
  │   ├── scw-loadbalancer (depends on K8s)
  │   └── scw-monitoring (depends on K8s)
  └── scw-database (depends on VPC)

Independent modules (no dependencies):
  ├── scw-object-storage
  └── scw-registry
```

Nx understands these dependencies through the `implicitDependencies` in each module's `project.json`. When you modify the VPC module, Nx automatically knows to validate all dependent modules (K8s, Database, and transitively LoadBalancer and Monitoring).

## Prerequisites

To run this demo, you need:

- Node.js 18+ and pnpm
- Terraform 1.0+
- TFLint (for linting)
- Checkov (for security scanning)
- Python 3.8+ (for Checkov)

### Quick Setup

```bash
# Install pnpm if not already installed
npm install -g pnpm
# or with corepack (recommended)
corepack enable
corepack prepare pnpm@latest --activate

# Install Node dependencies
pnpm install

# Install TFLint (macOS)
brew install tflint

# Install Checkov
pip install checkov

# Install Terraform (macOS)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

## Code Quality Tools

This project uses multiple tools to ensure code quality:

- **Biome**: Fast formatter and linter for JSON, YAML, and Markdown files
- **Terraform fmt**: Format Terraform files
- **TFLint**: Linter for Terraform
- **Checkov**: Security scanner for infrastructure-as-code

### Biome Commands

Format and check configuration files (JSON, YAML, Markdown):

```bash
# Check formatting and linting
pnpm run biome:check

# Fix formatting and linting issues automatically
pnpm run biome:fix

# Format files only
pnpm run biome:format

# Lint files only
pnpm run biome:lint

# Format all files (Biome + Terraform)
pnpm run format:all
```

## Available Tasks

Each Terraform module has the following tasks configured:

### fmt
Format Terraform files (or check formatting)

```bash
# Check formatting on all modules
pnpm nx run-many -t fmt

# Fix formatting on all modules
pnpm nx run-many -t fmt --configuration=fix

# Check only affected modules
pnpm nx affected -t fmt
```

### validate
Initialize and validate Terraform configuration

```bash
# Validate all modules
pnpm nx run-many -t validate

# Validate only affected modules
pnpm nx affected -t validate
```

### lint
Run TFLint to check for errors and best practices

```bash
# Lint all modules
pnpm nx run-many -t lint

# Lint only affected modules
pnpm nx affected -t lint
```

### security
Run Checkov security scanning

```bash
# Scan all modules
pnpm nx run-many -t security

# Scan only affected modules
pnpm nx affected -t security
```

### docs
Generate module documentation (requires terraform-docs)

```bash
# Generate docs for all modules
pnpm nx run-many -t docs
```

## Nx Affected Commands - The Power of Smart Execution

The key benefit of using Nx is the `affected` command, which only runs tasks on modules that have changed:

```bash
# Run validation only on affected modules and their dependents
pnpm nx affected -t validate

# Run all checks on affected modules
pnpm nx affected -t fmt validate lint security

# See what would be affected (dry run)
pnpm nx affected:graph
```

### How It Works

1. Nx compares your current branch with the base branch (main)
2. It detects which modules have changed
3. It identifies which modules depend on the changed modules
4. It only runs tasks on affected modules and their dependents

This dramatically reduces CI time. Instead of running checks on all modules (which could take 15+ minutes), you only run checks on what changed (typically 1-2 minutes).

## Running Tasks on Specific Modules

You can also run tasks on specific modules:

```bash
# Run validation on the VPC module
pnpm nx run scw-vpc:validate

# Run all checks on the Kubernetes module
pnpm nx run scw-k8s:fmt
pnpm nx run scw-k8s:validate
pnpm nx run scw-k8s:lint
pnpm nx run scw-k8s:security
```

## Visualizing the Project Graph

Nx can generate a visual graph of your modules and their dependencies:

```bash
# Open interactive graph in browser
pnpm nx graph

# Generate static graph file
pnpm nx graph --file=graph.html
```

## Task Pipeline & Caching

Nx automatically orchestrates task execution based on dependencies defined in `nx.json`:

- `fmt` runs first (formatting)
- `validate` runs after `fmt` and after dependencies are validated (`^validate`)
- `lint` runs after `validate`
- `security` runs after `lint`

Results are cached, so if you run a task twice without changes, Nx will use the cached result.

```bash
# First run - executes tasks
pnpm nx affected -t validate

# Second run - uses cache (instant)
pnpm nx affected -t validate
```

## CI/CD Integration

The `.github/workflows/ci.yml` file demonstrates how to use Nx in GitHub Actions:

- Uses `nrwl/nx-set-shas` to determine the correct base/head commits
- Runs Biome checks on all configuration files
- Runs `nx affected` commands to only check changed Terraform modules
- Runs tasks in parallel for faster execution
- Generates and uploads dependency graph as artifact

This approach typically reduces CI time from 15 minutes (checking all modules) to 1-2 minutes (checking only affected modules).

### CI Workflow Steps

1. **Biome Check**: Validates formatting of JSON, YAML, and Markdown files
2. **Terraform Format**: Checks Terraform file formatting on affected modules
3. **Terraform Validate**: Validates Terraform syntax on affected modules
4. **TFLint**: Runs linting on affected modules
5. **Checkov**: Runs security scanning on affected modules

## Example Workflow

1. **Make changes to a module**:
   ```bash
   # Edit the VPC module
   vim modules/scw-vpc/main.tf
   ```

2. **Check what's affected**:
   ```bash
   # See affected projects
   pnpm nx affected:graph

   # Or get a list
   pnpm nx show projects --affected
   ```

3. **Run checks on affected modules**:
   ```bash
   # Format
   pnpm nx affected -t fmt --configuration=fix

   # Validate
   pnpm nx affected -t validate

   # Lint
   pnpm nx affected -t lint

   # Security
   pnpm nx affected -t security
   ```

4. **Push changes**:
   ```bash
   git add .
   git commit -m "Update VPC module"
   git push
   ```

The CI pipeline will automatically run checks only on the affected modules.

## Benefits Demonstrated

1. **Faster CI/CD**: Only affected modules are checked
2. **Dependency Management**: Changes to VPC automatically trigger checks on K8s and Database modules
3. **Task Orchestration**: Tasks run in the correct order automatically
4. **Caching**: Repeated tasks use cached results
5. **Parallel Execution**: Independent modules run tasks concurrently
6. **Developer Experience**: Clear commands and instant feedback

## Module Details

### scw-vpc
Base VPC infrastructure module that creates:
- Scaleway VPC
- Private network

**Dependencies:** None (base module)

### scw-k8s
Kubernetes cluster module that creates:
- Kubernetes cluster attached to the VPC private network
- Node pool with autoscaling

**Dependencies:** scw-vpc

### scw-database
Database module that creates:
- Managed PostgreSQL/MySQL instance attached to the VPC private network
- Initial database

**Dependencies:** scw-vpc

### scw-object-storage
S3-compatible object storage module that creates:
- Storage bucket with versioning
- Lifecycle rules
- ACL configuration

**Dependencies:** None (independent)

### scw-registry
Container registry module that creates:
- Private or public container registry
- IAM policies for access control

**Dependencies:** None (independent)

### scw-loadbalancer
Load balancer module that creates:
- Layer 4/7 load balancer
- Frontend and backend configuration
- Optional SSL/TLS with Let's Encrypt

**Dependencies:** scw-vpc, scw-k8s

### scw-monitoring
Observability stack module that creates:
- Scaleway Cockpit (Grafana, Prometheus, Loki, Tempo)
- Grafana Agent for metrics collection
- Integration with Kubernetes cluster

**Dependencies:** scw-k8s

## Release Management

This project uses [Nx Release](https://nx.dev/features/manage-releases) to manage versions and changelogs.

### Versioning Strategy

- **Independent versioning**: Each module is versioned separately
- **Semantic Versioning**: Follows [SemVer](https://semver.org/) (MAJOR.MINOR.PATCH)
- **Conventional Commits**: Uses [Conventional Commits](https://www.conventionalcommits.org/) for changelog generation
- **Git tags**: Each release creates a git tag (e.g., `scw-vpc-v1.2.3`)

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>
```

**Types:**
- `feat`: New feature (triggers **minor** version bump)
- `fix`: Bug fix (triggers **patch** version bump)
- `docs`: Documentation only
- `refactor`: Code refactoring
- `chore`: Maintenance tasks

**Scopes:** Use module names (`scw-vpc`, `scw-k8s`, etc.) or generic scopes (`ci`, `deps`)

**Examples:**
```bash
feat(scw-vpc): add IPv6 support
fix(scw-k8s): correct autoscaling configuration
docs(scw-database): add backup examples
chore(deps): update Scaleway provider
```

**Breaking changes:** Add `!` after type and `BREAKING CHANGE:` in footer (triggers **major** version bump)
```bash
feat(scw-database)!: change default PostgreSQL version

BREAKING CHANGE: Default version changed from 15 to 16
```

See [COMMIT_CONVENTION.md](./.github/COMMIT_CONVENTION.md) for detailed guidelines.

### Release Commands

**Dry run (preview changes without committing):**
```bash
pnpm run release:dry-run
```

**Create a new release:**
```bash
# Let Nx determine version based on commits
pnpm run release

# Specify version bump explicitly
pnpm run release:version -- --specifier=patch
pnpm run release:version -- --specifier=minor
pnpm run release:version -- --specifier=major

# Only generate/update changelogs
pnpm run release:changelog

# Publish (for future package registry integration)
pnpm run release:publish
```

### GitHub Actions Release Workflow

The project includes a GitHub Actions workflow for automated releases:

1. Go to **Actions** tab in GitHub
2. Select **Release** workflow
3. Click **Run workflow**
4. Choose version bump type (patch/minor/major)
5. Optionally enable dry-run to preview changes

The workflow will:
- Determine affected modules based on commits
- Bump versions according to conventional commits
- Generate/update CHANGELOGs
- Create git tags
- Create GitHub releases
- Push changes to main branch

### Release Process Example

1. **Make changes with conventional commits:**
   ```bash
   git commit -m "feat(scw-vpc): add support for custom DNS"
   git commit -m "fix(scw-k8s): resolve node pool scaling issue"
   ```

2. **Preview the release (dry run):**
   ```bash
   pnpm run release:dry-run
   ```

   This shows you:
   - Which modules will be released
   - What version bumps will occur
   - What will be in the changelog

3. **Create the release:**
   ```bash
   pnpm run release
   ```

4. **Push to remote:**
   ```bash
   git push origin main --follow-tags
   ```

### Version Files

Each module has a `version.json` file tracking its current version:

```json
{
  "version": "1.2.3"
}
```

Nx Release automatically updates these files during releases.

### Changelogs

- **Workspace changelog**: [CHANGELOG.md](./CHANGELOG.md)
- **Module changelogs**: Each module has its own `CHANGELOG.md`

Changelogs are automatically generated from conventional commits with:
- Commit messages grouped by type
- Links to commits and PRs
- Author attribution
- Release dates

### Using Module Versions in Terraform

Reference specific module versions using git tags:

```hcl
module "vpc" {
  source = "git::https://github.com/your-org/nx-terraform-demo.git//modules/scw-vpc?ref=scw-vpc-v1.2.3"

  vpc_name = "production-vpc"
}
```

This ensures you're using a specific, tested version of the module.

## Learn More

- [Original Blog Post](https://blog.slashgear.dev/posts/managing-terraform-modules-with-nx/)
- [Nx Documentation](https://nx.dev)
- [Nx Release Documentation](https://nx.dev/features/manage-releases)
- [Terraform Documentation](https://www.terraform.io/docs)
- [TFLint](https://github.com/terraform-linters/tflint)
- [Checkov](https://www.checkov.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

## License

MIT
