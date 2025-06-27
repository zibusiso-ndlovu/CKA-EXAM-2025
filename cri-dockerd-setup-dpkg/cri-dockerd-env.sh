#!/bin/bash

set -e

PROFILE="cka-q15"

function setup_env() {
  echo "🧹 Cleaning up old Minikube cluster..."
  minikube delete -p $PROFILE || true

  echo "🚀 Starting Minikube with Docker runtime..."
  minikube start -p $PROFILE \
    --driver=docker \
    --container-runtime=docker \
    --cpus=2 \
    --memory=4g \
    --kubernetes-version=stable \
    --no-vtx-check

  echo "🚜 Cleaning cri-dockerd and sysctl params from node..."
  minikube ssh -p $PROFILE <<'EOF'
    sudo systemctl stop cri-docker.service cri-docker.socket 2>/dev/null || true
    sudo systemctl disable cri-docker.service cri-docker.socket 2>/dev/null || true
    sudo rm -f /usr/bin/cri-dockerd
    sudo rm -f /etc/systemd/system/cri-docker.*
    sudo rm -f /etc/systemd/system/sockets.target.wants/cri-docker.socket

    sudo sysctl -w net.bridge.bridge-nf-call-iptables=0 || true
    sudo sysctl -w net.ipv6.conf.all.forwarding=0 || true
    sudo sysctl -w net.ipv4.ip_forward=0 || true
    sudo sysctl -w net.netfilter.nf_conntrack_max=65536 || true
    sudo rm -f /etc/sysctl.d/99-kubernetes.conf

    rm -f ~/cri-dockerd_*.deb
EOF

  echo "✅ Setup complete! SSH in with: minikube ssh -p $PROFILE"
}

function reset_env() {
  echo "🔁 Resetting Minikube node '$PROFILE'..."
  minikube ssh -p $PROFILE <<'EOF'
    sudo systemctl stop cri-docker.service cri-docker.socket 2>/dev/null || true
    sudo systemctl disable cri-docker.service cri-docker.socket 2>/dev/null || true
    sudo rm -f /usr/bin/cri-dockerd
    sudo rm -f /etc/systemd/system/cri-docker.*
    sudo rm -f /etc/systemd/system/sockets.target.wants/cri-docker.socket

    sudo sysctl -w net.bridge.bridge-nf-call-iptables=0 || true
    sudo sysctl -w net.ipv6.conf.all.forwarding=0 || true
    sudo sysctl -w net.ipv4.ip_forward=0 || true
    sudo sysctl -w net.netfilter.nf_conntrack_max=65536 || true
    sudo rm -f /etc/sysctl.d/99-kubernetes.conf

    rm -f ~/cri-dockerd_*.deb
EOF

  echo "✅ Reset complete. Node is clean and ready for another run."
}

function usage() {
  echo "Usage: $0 [--setup | --reset]"
  echo "  --setup   Create a clean CKA Q-15 practice environment"
  echo "  --reset   Reset the Minikube node for a new practice run"
  exit 1
}

case "$1" in
  --setup)
    setup_env
    ;;
  --reset)
    reset_env
    ;;
  *)
    usage
    ;;
esac
