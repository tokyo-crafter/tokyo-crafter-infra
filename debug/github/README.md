# Github Workflow のデバッグ

[nektos/act](https://github.com/nektos/act) を使うと、Github Actionsのworkflowをローカル実行出来る。

TODO

* [ ] Github Actions では Terraform Cloudを使っているが、無料版だと5人までなのと、ローカル実行時と環境を分けたい。

## [nektos/act](https://github.com/nektos/act) をインストール

* Homebrew
* Chocolatey
* Scoop
* (bash script)

などから、 `act` コマンドをインストールする。

## secrets を設定

secrets ファイルを作成,編集する。

```bash
cp act.secrets.sample act.secrets
vi act.secrets  
``` 

## 実行

`act` コマンドを実行して、Github Actions をローカル実行する。

```bash
# push 時の Github Actions を実行
act push --secret-file act.secrets
```
