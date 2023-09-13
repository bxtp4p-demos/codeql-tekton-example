#!/bin/bash

echo "Start Minikube"
minikube start

echo "Install Tekton Pipelines"

kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "Install Tekton Triggers"

kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

echo "Install Tekton Dashboard"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml
