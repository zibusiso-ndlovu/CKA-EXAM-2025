# Install cri-dockerd using dpkg

## Prerequisites
Minikube 

## cri-dockerd repo

https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb


## Usage

```sh
chmod +x cka-q15-env.sh
./cka-q15-env.sh --setup    # Create a fresh practice environment
./cka-q15-env.sh --reset    # Reset the environment for another run
```
 ### View clusters
```sh
  minikube profile list
```
sample output


|---------|-----------|---------|--------------|------|---------|--------|-------|----------------|--------------------|
| Profile | VM Driver | Runtime |      IP      | Port | Version | Status | Nodes | Active Profile | Active Kubecontext |
|---------|-----------|---------|--------------|------|---------|--------|-------|----------------|--------------------|
| cka-q15 | docker    | docker  | 192.168.49.2 | 8443 | v1.33.1 | OK     |     1 |                | *                  |
|---------|-----------|---------|--------------|------|---------|--------|-------|----------------|--------------------|

### ssh to the cluster node
```sh
minikube ssh -p cka-q15

```

### Clean Up 

```sh
minikube delete --profile cka-q15
```