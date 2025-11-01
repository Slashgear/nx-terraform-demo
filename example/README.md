# Example Usage

This directory contains an example of how to use all seven Terraform modules together to create a complete infrastructure stack on Scaleway.

## What Gets Created

This example creates a full-stack infrastructure:

1. **VPC** (via `scw-vpc` module):
   - A Scaleway VPC
   - A private network within the VPC

2. **Kubernetes Cluster** (via `scw-k8s` module):
   - A Kubernetes cluster connected to the VPC private network
   - A node pool with 3 nodes and autoscaling (2-5 nodes)

3. **Database** (via `scw-database` module):
   - A PostgreSQL 15 database instance connected to the VPC private network
   - Automatic backups enabled

4. **Object Storage** (via `scw-object-storage` module):
   - S3-compatible storage bucket
   - Versioning and lifecycle rules enabled

5. **Container Registry** (via `scw-registry` module):
   - Private container registry for Docker images

6. **Load Balancer** (via `scw-loadbalancer` module):
   - Load balancer connected to the VPC private network
   - Frontend and backend configuration

7. **Monitoring Stack** (via `scw-monitoring` module):
   - Scaleway Cockpit with Grafana, Prometheus, Loki, Tempo
   - Grafana Agent deployed to Kubernetes for metrics collection

## Prerequisites

1. **Scaleway Account**: You need a Scaleway account and API credentials
2. **Terraform**: Installed on your system
3. **Scaleway Credentials**: Set as environment variables

## Setup

### 1. Set Scaleway Credentials

```bash
export SCW_ACCESS_KEY="<your-access-key>"
export SCW_SECRET_KEY="<your-secret-key>"
export SCW_DEFAULT_PROJECT_ID="<your-project-id>"
export SCW_DEFAULT_REGION="fr-par"
export SCW_DEFAULT_ZONE="fr-par-1"
```

### 2. Create terraform.tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set the required values:

```hcl
db_password         = "your-secure-password-here"
scaleway_project_id = "your-project-id-here"
```

You can get your project ID from the Scaleway console or with:

```bash
scw config get default-project-id
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

This will create all the infrastructure. Review the plan and type `yes` to confirm.

## Accessing Your Resources

### Kubernetes Cluster

After the apply completes, you can get the kubeconfig:

```bash
terraform output -raw kubeconfig > kubeconfig.yaml
export KUBECONFIG=$(pwd)/kubeconfig.yaml
kubectl get nodes
```

### Database

Get the database endpoint:

```bash
terraform output database_endpoint
```

Connect using your database client:

```bash
psql "postgresql://dbadmin:<password>@<endpoint-ip>:<port>/app"
```

### Object Storage

Get the storage bucket endpoint:

```bash
terraform output storage_bucket_endpoint
```

Access using the AWS CLI or any S3-compatible tool:

```bash
export AWS_ACCESS_KEY_ID=$SCW_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$SCW_SECRET_KEY
aws s3 ls --endpoint-url <bucket-endpoint>
```

### Container Registry

Get the registry URL:

```bash
terraform output registry_url
```

Login and push images:

```bash
docker login <registry-url> -u nologin -p $SCW_SECRET_KEY
docker tag myapp:latest <registry-url>/myapp:latest
docker push <registry-url>/myapp:latest
```

### Load Balancer

Get the load balancer IP:

```bash
terraform output loadbalancer_ip
```

Point your DNS records to this IP.

### Monitoring

Get the Grafana URL:

```bash
terraform output grafana_url
```

Access Grafana using your Scaleway credentials to view metrics, logs, and traces from your Kubernetes cluster.

## Cleanup

To destroy all created resources:

```bash
terraform destroy
```

Review the plan and type `yes` to confirm.

## Cost Warning

Running this example will incur costs on your Scaleway account:

- Kubernetes cluster with 3 nodes (most expensive)
- Database instance
- Load balancer
- Object storage (storage + requests)
- Container registry (storage)
- Monitoring/Cockpit
- VPC resources (usually free)

**Estimated monthly cost: €150-200 depending on usage**

Make sure to destroy the resources when you're done testing.

## Module Dependencies

This example demonstrates how the modules depend on each other:

```
VPC Module (base)
  ↓ (provides private_network_id)
  ├→ Kubernetes Module
  │   ↓ (provides cluster config)
  │   ├→ Load Balancer Module
  │   └→ Monitoring Module
  └→ Database Module

Independent Modules:
  ├→ Object Storage Module
  └→ Container Registry Module
```

This dependency structure is managed by Nx:
- Changes to the **VPC module** will trigger validation of K8s, Database, LoadBalancer, and Monitoring
- Changes to the **K8s module** will trigger validation of LoadBalancer and Monitoring
- Changes to **Object Storage** or **Registry** only affect themselves

This is why Nx's affected command is so powerful for managing these complex dependencies!
