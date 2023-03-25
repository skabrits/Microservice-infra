#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

kubectl create namespace argocd
kubectl apply -n argocd -f "$SCRIPTPATH/../manifests/argocd.yaml"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "ClusterIP"}}'
kubectl apply -f "$SCRIPTPATH/../manifests/argo-cm.yaml"
kubectl -n argocd rollout restart deploy argocd-repo-server

kubectl apply -f "$SCRIPTPATH/../manifests/ingress.yaml"
kubectl apply -f "$SCRIPTPATH/../manifests/argocd"