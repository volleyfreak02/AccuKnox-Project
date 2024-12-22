# Cow wisdom web server

## Prerequisites

```
sudo apt install fortune-mod cowsay -y
```

## How to use?

1. Run `./wisecow.sh`
2. Point the browser to server port (default 4499)

## What to expect?
![wisecow](https://github.com/nyrahul/wisecow/assets/9133227/8d6bfde3-4a5a-480e-8d55-3fef60300d98)

# Problem Statement
Deploy the wisecow application as a k8s app

# Wisecow Application CI/CD Pipeline

This repository contains the CI/CD pipeline configuration for deploying the Wisecow application to AWS EKS using GitHub Actions. The application is containerized using Docker and deployed using Kubernetes resources.

## Prerequisites

- AWS Account with appropriate permissions
- AWS CLI configured with your credentials
- ECR (Elastic Container Registry) repository created
- EKS (Elastic Kubernetes Service) cluster created and configured
- Kubernetes CLI (`kubectl`) installed
- GitHub repository with configured secrets for AWS

## GitHub Actions Configuration

The GitHub Actions workflow is defined in `.github/workflows/docker-image.yml`. It contains two main jobs: `build` and `deploy`.

### Build Job

The build job performs the following steps:

1. **Checkout the code**: Uses the `actions/checkout@v4` action.
2. **Configure AWS credentials**: Uses the `aws-actions/configure-aws-credentials@v1` action to configure AWS credentials.
3. **Login to Amazon ECR**: Uses the `aws-actions/amazon-ecr-login@v1` action to log in to Amazon ECR.
4. **Build, tag, and push Docker image**: Builds the Docker image, tags it, and pushes it to the Amazon ECR repository.

### Deploy Job

The deploy job performs the following steps:

1. **Checkout the code**: Uses the `actions/checkout@v4` action.
2. **Configure AWS credentials**: Uses the `aws-actions/configure-aws-credentials@v1` action to configure AWS credentials.
3. **Install `kubectl`**: Uses the `azure/setup-kubectl@v2.0` action to install `kubectl`.
4. **Update Kubernetes configuration**: Updates the kubeconfig to use the specified EKS cluster.
5. **Substitute variables in YAML files**: Uses `envsubst` to replace placeholders in the Kubernetes resource files.
6. **Deploy to EKS**: Applies the Kubernetes resource files to the EKS cluster using `kubectl`.

## Secrets Configuration

The following secrets need to be configured in your GitHub repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_ACCOUNT_ID`
- `EKS_CLUSTER_NAME`

## Dockerfile

This Dockerfile builds an image based on Ubuntu, installs necessary packages, copies the application script, and runs the default command.

## Deployment

wisecow-deployment.yml: Manages the deployment of application pods. It ensures that the specified number of replicas (1) are running and up-to-date. The container runs the Docker image built from the ECR repository and exposes port 4499

## Service

service.yml: Exposes the deployment to other services within the cluster. It creates a stable endpoint (wisecow-svc) that routes traffic to the wisecow-app pods on port 4499.

## Ingress

wisecow-ingress.yml: Manages external access to services within the cluster. It uses AWS ALB (Application Load Balancer) to route HTTP and HTTPS traffic to the wisecow-svc service based on the domain 'wisecow.opsminds.in'. The ALB listens on ports 80 and 443 and uses an SSL certificate for secure connections.

## Usage

1. **Clone the repository**: Clone this repository to your local machine.
2. **Configure GitHub secrets**: Add the required secrets (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ACCOUNT_ID, EKS_CLUSTER_NAME) in your GitHub repository settings.
3. **Push changes**: Push any changes to the main branch to trigger the CI/CD pipeline.
4. **Monitor GitHub Actions**: Monitor the GitHub Actions tab in your repository to track the progress of the CI/CD pipeline.

## Conclusion

This setup provides a robust CI/CD pipeline for deploying the Wisecow application to AWS EKS using GitHub Actions. By following the steps outlined in this README, you can automate the build, push, and deployment process, ensuring a smooth and efficient workflow.
