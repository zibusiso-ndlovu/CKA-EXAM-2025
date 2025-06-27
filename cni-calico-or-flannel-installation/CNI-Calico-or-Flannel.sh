#!/bin/bash

set -e

PROFILE="cka-q5"
CNI=$1

function usage() {
  echo "Usage: $0 [flannel|calico]"
  echo "  flannel - Start env ready to install Flannel v0.26.1"
  echo "  calico  - Start env ready to install Calico v3.28.2"
  exit 1
}

function setup_minikube() {
  echo "🧹 Cleaning up old Minikube cluster..."
  minikube delete -p $PROFILE || true

  echo "🚀 Starting Minikube without CNI..."
  minikube start -p $PROFILE \
    --driver=docker \
    --container-runtime=docker \
    --cpus=2 \
    --memory=4096 \
    --kubernetes-version=stable \
    --network-plugin=cni \
    --cni=false \
    --no-vtx-check

  echo "✅ Minikube started with no CNI. Pods will be Pending until CNI is installed."
}

function suggest_manifest() {
  echo ""
  if [[ "$CNI" == "flannel" ]]; then
    echo "📦 Install Flannel v0.26.1 using:"
    echo "  kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml"
  elif [[ "$CNI" == "calico" ]]; then
    echo "📦 Install Calico v3.28.2 using:"
    echo "  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml"
  fi

  echo ""
  echo "🔍 To test:"
  echo "  kubectl get pods -A"
  echo "  kubectl run testpod --image=nginx -- sleep 3600"
  echo "  kubectl describe pod testpod"
  echo ""
  echo "SSH into node if needed: minikube ssh -p $PROFILE"
}

if [[ "$CNI" != "flannel" && "$CNI" != "calico" ]]; then
  usage
fi

setup_minikube
suggest_manifest
