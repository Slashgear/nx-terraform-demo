# Commit Message Convention

This project follows [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (formatting, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools

## Scope

The scope should be the name of the module affected:

- `scw-vpc`
- `scw-k8s`
- `scw-database`
- `scw-object-storage`
- `scw-registry`
- `scw-loadbalancer`
- `scw-monitoring`

Or use generic scopes:

- `ci`: Changes to CI configuration
- `release`: Release-related changes
- `deps`: Dependency updates

## Examples

### Feature

```
feat(scw-vpc): add support for IPv6

Add IPv6 CIDR block configuration to VPC module.
This allows users to enable dual-stack networking.

Closes #123
```

### Bug Fix

```
fix(scw-k8s): correct node pool autoscaling configuration

The min_nodes parameter was not being applied correctly,
causing the cluster to scale down below the specified minimum.
```

### Breaking Change

```
feat(scw-database)!: change default PostgreSQL version to 16

BREAKING CHANGE: The default PostgreSQL version has been changed
from 15 to 16. Existing deployments will need to be upgraded
manually or specify version = "PostgreSQL-15" explicitly.
```

### Documentation

```
docs(scw-loadbalancer): add SSL/TLS setup examples

Add detailed examples showing how to configure Let's Encrypt
certificates with the load balancer module.
```

### Chore

```
chore(deps): update Scaleway provider to 2.30.0
```

## Breaking Changes

To indicate a breaking change:

1. Add `!` after the type/scope: `feat(scw-vpc)!: ...`
2. Add `BREAKING CHANGE:` in the footer

## How This Affects Releases

- `feat`: Triggers a **minor** version bump (0.1.0 → 0.2.0)
- `fix`: Triggers a **patch** version bump (0.1.0 → 0.1.1)
- `BREAKING CHANGE`: Triggers a **major** version bump (0.1.0 → 1.0.0)
- Other types: No version bump, but included in changelog

## Tips

- Use present tense: "add feature" not "added feature"
- Use imperative mood: "move cursor to..." not "moves cursor to..."
- Don't capitalize first letter of subject
- No period (.) at the end of subject
- Limit subject line to 72 characters
- Use body to explain what and why, not how
