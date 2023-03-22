#!/bin/bash

source gitlab.conf

minikube status | grep Running > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo [$(date "+%Y/%m/%d %H:%M:%S")] minikube を起動します。
    minikube start --auto-update-drivers=false
fi

echo [$(date "+%Y/%m/%d %H:%M:%S")] 準備します。
helm repo add gitlab https://charts.gitlab.io
kubectl delete namespace $GITLAB_RUNNER_NAMESPACE --force
kubectl create namespace $GITLAB_RUNNER_NAMESPACE
curl -s --header "PRIVATE-TOKEN: $PERSONAL_ACCCESS_TOKEN" "http://$GITLAB_IP:$GITLAB_PORT/api/v4/runners/all" \
    | jq '.[].id' | xargs -I runner_id curl -s --request DELETE --header "PRIVATE-TOKEN: $PERSONAL_ACCCESS_TOKEN" "http://$GITLAB_IP:$GITLAB_PORT/api/v4/runners/runner_id"

cp gitlab_runner.template.yaml gitlab_runner.yaml
sed -i -e s/@GITLAB_IP/$GITLAB_IP/ gitlab_runner.yaml
sed -i -e s/@GITLAB_PORT/$GITLAB_PORT/ gitlab_runner.yaml
sed -i -e s/@RUNNER_REGISTRATION_TOKEN/$RUNNER_REGISTRATION_TOKEN/ gitlab_runner.yaml
sed -i -e s/@GITLAB_RUNNER_TAGS/$GITLAB_RUNNER_TAGS/ gitlab_runner.yaml

echo [$(date "+%Y/%m/%d %H:%M:%S")] Gitlab Runner を起動します。 
helm install --namespace $GITLAB_RUNNER_NAMESPACE gitlab-runner -f gitlab_runner.yaml gitlab/gitlab-runner

rm gitlab_runner.yaml

cat << EOL

以下のページで Online の Runner が１つあることを確認できれば成功です。
http://${GITLAB_IP}:${GITLAB_PORT}/admin/runners
EOL
