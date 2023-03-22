#!/bin/bash

source gitlab.conf

docker --version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo "[$(date "+%Y/%m/%d %H:%M:%S")] Docker をインストールします。"

    ## Docker Engine をインストールする。
    # https://docs.docker.com/engine/install/ubuntu/
    sudo apt-get -y install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    USERNAME=$(whoami)
    sudo usermod -aG docker $USERNAME
fi

kubectl version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo "[$(date "+%Y/%m/%d %H:%M:%S")] kubectl をインストールします。"

    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    pushd /tmp
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    kubectl version --client --output=yaml    
    popd
fi

minikube version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo "[$(date "+%Y/%m/%d %H:%M:%S")] minikube をインストールします。"

    # https://minikube.sigs.k8s.io/docs/start/
    pushd /tmp
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    popd
fi

helm version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo "[$(date "+%Y/%m/%d %H:%M:%S")] Helm をインストールします。"

    # https://helm.sh/docs/intro/install/
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
fi
