# Changelog

This file contains the version history and changes for all Terraform modules in this monorepo.

All notable changes to this project will be documented in this file. See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## How Versioning Works

This project uses [Nx Release](https://nx.dev/features/manage-releases) with independent versioning:

- Each module is versioned independently
- Versions follow [Semantic Versioning](https://semver.org/)
- Changelogs are generated automatically from conventional commits
- GitHub releases are created automatically

## Module Changelogs

Each module has its own changelog:

- [scw-vpc](./modules/scw-vpc/CHANGELOG.md)
- [scw-k8s](./modules/scw-k8s/CHANGELOG.md)
- [scw-database](./modules/scw-database/CHANGELOG.md)
- [scw-object-storage](./modules/scw-object-storage/CHANGELOG.md)
- [scw-registry](./modules/scw-registry/CHANGELOG.md)
- [scw-loadbalancer](./modules/scw-loadbalancer/CHANGELOG.md)
- [scw-monitoring](./modules/scw-monitoring/CHANGELOG.md)

## Unreleased Changes

Changes that have not yet been released will appear here after running `pnpm release:changelog`.
