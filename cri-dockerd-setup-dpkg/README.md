# Install cri-dockerd using dpkg

## Prerequisites
Minikube 

## cri-dockerd repo

https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.1/cri-dockerd_0.3.1.3-0.ubuntu-focal_amd64.deb


## Usage

```sh
chmod +x cka-q15-env.sh
./cka-q15-env.sh --setup    # Create a fresh practice environment
./cka-q15-env.sh --reset    # Reset the environment for another run

minikube ssh -p cka-q15
```