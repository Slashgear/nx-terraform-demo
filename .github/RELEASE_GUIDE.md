# Release Guide

This guide explains how to create releases for the Terraform modules in this monorepo.

## Quick Start

```bash
# Preview what would be released
pnpm run release:dry-run

# Create a release (interactive)
pnpm run release

# Or specify the version bump type
pnpm run release:version -- --specifier=patch
```

## Prerequisites

Before creating a release, ensure:

1. ✅ All changes are committed
2. ✅ Working directory is clean (`git status`)
3. ✅ You're on the `main` branch
4. ✅ All CI checks pass
5. ✅ Commits follow [Conventional Commits](./COMMIT_CONVENTION.md) format

## Release Workflow

### 1. Make Changes with Conventional Commits

Use the correct commit format to enable automatic version bumping:

```bash
# Feature (minor version bump)
git commit -m "feat(scw-vpc): add IPv6 support"

# Bug fix (patch version bump)
git commit -m "fix(scw-k8s): correct node pool scaling"

# Breaking change (major version bump)
git commit -m "feat(scw-database)!: change default PostgreSQL version

BREAKING CHANGE: Default version changed from 15 to 16"
```

### 2. Preview the Release (Dry Run)

Run a dry-run to see what would happen without making any changes:

```bash
pnpm run release:dry-run
```

This will show you:
- Which modules will be released
- What version they will be bumped to
- What will be added to the changelog
- What git tags will be created

### 3. Create the Release

If the dry-run looks good, create the actual release:

```bash
# Let Nx analyze commits and determine versions
pnpm run release

# Or explicitly specify the version bump
pnpm run release:version -- --specifier=patch   # 0.1.0 → 0.1.1
pnpm run release:version -- --specifier=minor   # 0.1.0 → 0.2.0
pnpm run release:version -- --specifier=major   # 0.1.0 → 1.0.0
```

This will:
1. Analyze commits since last release
2. Determine which modules changed
3. Calculate new version numbers
4. Update `version.json` files
5. Generate/update `CHANGELOG.md` files
6. Create git commit with changes
7. Create git tags for each released module

### 4. Review Changes

Before pushing, review what was created:

```bash
# See the commits
git log --oneline -n 5

# See the tags
git tag -l

# See changed files
git show HEAD
```

### 5. Push to Remote

Push both commits and tags:

```bash
git push origin main --follow-tags
```

This will trigger GitHub Actions to create GitHub Releases for each tagged module.

## Version Bump Types

### Patch (0.0.x)

Small backwards-compatible bug fixes:

```bash
fix(scw-vpc): correct CIDR block validation
fix(scw-k8s): resolve node pool timeout issue
```

### Minor (0.x.0)

New features that are backwards-compatible:

```bash
feat(scw-database): add backup retention configuration
feat(scw-loadbalancer): add SSL certificate support
```

### Major (x.0.0)

Breaking changes that are not backwards-compatible:

```bash
feat(scw-vpc)!: remove deprecated vpc_id output

BREAKING CHANGE: The vpc_id output has been removed.
Use network_id instead.
```

## Independent Versioning

Each module is versioned independently:

- `scw-vpc` might be at v2.3.1
- `scw-k8s` might be at v1.0.5
- `scw-database` might be at v0.8.0

This allows modules to evolve at their own pace.

## GitHub Actions Workflow

For convenience, you can use the GitHub Actions workflow:

1. Go to the **Actions** tab
2. Select **Release** workflow
3. Click **Run workflow**
4. Choose:
   - Version bump type (patch/minor/major/prerelease)
   - Dry-run option (to preview without making changes)
5. Click **Run workflow**

The workflow will automatically:
- Create the release
- Push changes
- Create git tags
- Create GitHub Releases

## Troubleshooting

### "No changes detected"

If Nx doesn't detect any changes to release:

1. Check if commits follow conventional format
2. Verify commits affect module files (not just README, etc.)
3. Check if version has already been released for these changes

### "Uncommitted changes"

Nx requires a clean working directory:

```bash
# Stash changes
git stash

# Or commit them
git add .
git commit -m "feat(module): your changes"
```

### "Tag already exists"

If a tag already exists:

```bash
# List existing tags
git tag -l

# Delete local tag
git tag -d scw-vpc-v1.0.0

# Delete remote tag (be careful!)
git push origin :refs/tags/scw-vpc-v1.0.0
```

## Manual Release Steps

If you need to release manually without Nx:

```bash
# 1. Update version.json
echo '{"version": "1.2.3"}' > modules/scw-vpc/version.json

# 2. Update CHANGELOG.md manually

# 3. Commit changes
git add modules/scw-vpc/
git commit -m "chore(release): publish scw-vpc v1.2.3"

# 4. Create tag
git tag scw-vpc-v1.2.3

# 5. Push
git push origin main --tags
```

## Best Practices

1. **Always run dry-run first** to preview changes
2. **Review changelogs** before pushing to ensure they're accurate
3. **Use conventional commits** for automatic version determination
4. **Test modules** before releasing (run `pnpm run affected:all`)
5. **Document breaking changes** clearly in commit messages
6. **Release often** to avoid large, risky releases
7. **Keep commits focused** on single modules when possible

## Examples

### Releasing a Bug Fix

```bash
# Make fix
vim modules/scw-k8s/main.tf

# Commit with conventional format
git add modules/scw-k8s/
git commit -m "fix(scw-k8s): correct autoscaling min_size validation"

# Preview release
pnpm run release:dry-run

# Create release
pnpm run release

# Push
git push origin main --follow-tags
```

### Releasing Multiple Modules

```bash
# Make changes to multiple modules
vim modules/scw-vpc/main.tf
vim modules/scw-k8s/main.tf

# Commit separately (best practice)
git add modules/scw-vpc/
git commit -m "feat(scw-vpc): add IPv6 support"

git add modules/scw-k8s/
git commit -m "feat(scw-k8s): integrate with IPv6 VPC"

# Nx will release both modules
pnpm run release

# Push
git push origin main --follow-tags
```

### Creating a Pre-release

```bash
# Create prerelease version (1.0.0-alpha.1)
pnpm run release:version -- --specifier=prerelease --preid=alpha

# Or use workflow with prerelease option
```

## Additional Resources

- [Nx Release Documentation](https://nx.dev/features/manage-releases)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Commit Convention Guide](./COMMIT_CONVENTION.md)
