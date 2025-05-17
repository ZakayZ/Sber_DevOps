#!/bin/bash

echo "Building Docker image..."
docker build -t custom-app:latest ./app

echo "Loading image to minikube..."
minikube image load custom-app:latest

echo "Setting up Istio..."
istioctl install --set profile=demo -y

echo "Adding Istio sidecar..."
kubectl label namespace default istio-injection=enabled

echo "Applying Kubernetes manifests..."
kubectl apply -f deploy/configmap.yaml
kubectl apply -f deploy/pod.yaml
kubectl apply -f deploy/deployment.yaml
kubectl apply -f deploy/service.yaml
kubectl apply -f deploy/daemonset.yaml
kubectl apply -f deploy/cron.yaml

echo "Applying Istio manifests..."
kubectl apply -f deploy/istio-gateway.yaml
kubectl apply -f deploy/istio-virtualservice.yaml 
kubectl apply -f deploy/istio-destination.yaml   

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/app-deployment --timeout=90s

echo "Service URL:"
# minikube service app-service --url
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80

echo "Deployment complete!"
