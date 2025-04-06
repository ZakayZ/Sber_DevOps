#!/bin/bash

# Build the Docker image
echo "Building Docker image..."
docker build -t custom-app:latest ./app

# Load image to minikube (if using minikube)
if command -v minikube &> /dev/null; then
  echo "Loading image to minikube..."
  minikube image load custom-app:latest
fi

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f deploy/configmap.yaml
kubectl apply -f deploy/deployment.yaml
kubectl apply -f deploy/service.yaml
kubectl apply -f deploy/daemonset.yaml
kubectl apply -f deploy/cronjob.yaml

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/app-deployment --timeout=90s

# Get service URL
echo "Service URL:"
if command -v minikube &> /dev/null; then
  minikube service app-service --url
else
  kubectl get service app-service
fi

echo "Deployment complete!"
