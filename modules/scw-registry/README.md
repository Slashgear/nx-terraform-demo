# Scaleway Container Registry Module

This module creates a Scaleway Container Registry namespace for storing Docker images.

## Features

- Private or public container registry
- Optional IAM policy for push access
- Compatible with Docker and Kubernetes

## Usage

```hcl
module "registry" {
  source = "./modules/scw-registry"

  registry_name      = "my-app-registry"
  description        = "Container images for my application"
  is_public          = false
  create_push_policy = true
}
```

## Docker Usage

After creating the registry, you can push images:

```bash
# Login to registry
docker login rg.fr-par.scw.cloud/my-app-registry -u nologin -p $SCW_SECRET_KEY

# Tag and push image
docker tag my-app:latest rg.fr-par.scw.cloud/my-app-registry/my-app:latest
docker push rg.fr-par.scw.cloud/my-app-registry/my-app:latest
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| registry_name | Name of the container registry namespace | string | n/a | yes |
| description | Description of the registry | string | "Container registry managed by Terraform" | no |
| is_public | Whether the registry is publicly accessible | bool | false | no |
| create_push_policy | Create IAM policy for push access | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| registry_id | ID of the registry namespace |
| registry_name | Name of the registry namespace |
| registry_endpoint | Endpoint of the registry |
| registry_url | Full URL of the registry |
