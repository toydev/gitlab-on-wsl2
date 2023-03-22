# 概要

WSL2 の Ubuntu 22.04 上で以下を動かします。

- GitLab
- GitLab Runner - Kubernetes executor

# インストール

- 前準備をする。

前提ソフトウェア（docker / kubectl / minikube / helm）をインストールします。
一般ユーザで実行してください。whoami でユーザ名を参照している処理があります。必要な個所は sudo で実行しているので求められたらパスワードを入力してください。

```
./setup.sh
```

- WSL のターミナルを開きなおす（一般ユーザの docker へのアクセスを有効にするため）。

- docker サービスを起動する。

```
sudo service docker start
```

- gitlab.conf.default を gitlab.conf にコピーして編集する。

- GitLab を起動する。

docker で GitLab を起動します。

```
./start_gitlab.sh
```

起動後、以下の通り GitLab へのログインや GitLab Runner 用の設定に関する情報が出力されるので、
それに従い gitlab.conf を設定してください。

```
[2023/03/20 22:35:00] GitLab を起動します。
[+] Running 4/4
Started
[2023/03/20 22:35:01] GitLab の起動を待機します（※数分掛かります）。
[2023/03/20 22:37:51] GitLab を以下の URL で起動しました。
http://xxx.xxx.xxx.xxx:xxx/

Password: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

上記のパスワードを使い以下の URL に root ユーザでログインし、パスワードを再設定してください。設定したパスワードはリポジトリへのアクセスにも使えます。
http://xxx.xxx.xxx.xxx:xxx/-/profile/password/edit

以下のページの「Register an instance runner」を押下し「Registration token」を取得し、gitlab.conf の「RUNNER_REGISTRATION_TOKEN」に設定してください。
http://xxx.xxx.xxx.xxx:xxx/admin/runners

以下のページで api へのアクセスを有効にした Personal Access Token を取得し、gitlab.conf の「PERSONAL_ACCCESS_TOKEN」に設定してください。
http://${GITLAB_IP}:${GITLAB_PORT}/-/profile/personal_access_tokens
```

- GitLab Runner を起動する。

```
./start_gitlab_runner.sh
```

# PC の再起動時

docker サービスを起動してください。

```
sudo service docker start
```

次に GitLab と GitLab Runner を起動してください。

```
./start_gitlab.sh
./start_gitlab_runner.sh
```
