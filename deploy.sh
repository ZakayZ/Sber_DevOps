#!/bin/bash

echo "Building Docker image..."
docker build -t custom-app:latest ./app

echo "Loading image to minikube..."
minikube image load custom-app:latest

echo "Applying Kubernetes manifests..."
kubectl apply -f deploy/configmap.yaml
kubectl apply -f deploy/pod.yaml
kubectl apply -f deploy/deployment.yaml
kubectl apply -f deploy/service.yaml
kubectl apply -f deploy/daemonset.yaml
kubectl apply -f deploy/cron.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/app-deployment --timeout=90s

echo "Service URL:"
minikube service app-service --url

echo "Deployment complete!"
