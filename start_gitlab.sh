#!/bin/bash

source gitlab.conf

echo [$(date "+%Y/%m/%d %H:%M:%S")] GitLab を起動します。
docker compose up -d
if [ "$?" != "0" ]; then
    echo GitLab を起動できませんでした。
    exit 1
fi

echo [$(date "+%Y/%m/%d %H:%M:%S")] GitLab の起動を待機します（※数分掛かります）。
while true
do
    curl -s -I -L http://${GITLAB_IP}:${GITLAB_PORT}/ | grep "HTTP/1.1 200 OK" > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        break
    fi
    sleep 1
done

echo [$(date "+%Y/%m/%d %H:%M:%S")] GitLab を以下の URL で起動しました。
echo http://${GITLAB_IP}:${GITLAB_PORT}/

if [ -z "$RUNNER_REGISTRATION_TOKEN" ]; then
    echo
    docker compose exec -T gitlab cat /etc/gitlab/initial_root_password | grep Password:

    cat << EOL
上記のパスワードを使い以下の URL に root ユーザでログインし、パスワードを再設定してください。リポジトリへのアクセスにも使えます。
http://${GITLAB_IP}:${GITLAB_PORT}/-/profile/password/edit

以下のページの「Register an instance runner」を押下し「Registration token」を取得し、gitlab.conf の「RUNNER_REGISTRATION_TOKEN」に設定してください。
http://${GITLAB_IP}:${GITLAB_PORT}/admin/runners

以下のページで api へのアクセスを有効にした Personal Access Token を取得し、gitlab.conf の「PERSONAL_ACCCESS_TOKEN」に設定してください。
http://${GITLAB_IP}:${GITLAB_PORT}/-/profile/personal_access_tokens
EOL
fi
