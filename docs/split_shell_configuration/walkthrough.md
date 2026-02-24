# Shell Configuration Split Walkthrough

このドキュメントでは、iTerm2で新規セッションを開いた際に `zsh` と `bash` が複数回行き来して表示される問題を解決するために実施した、シェル設定ファイルのリファクタリング（責務分割）の内容をまとめます。

## 変更内容 (Changes Made)

従来の `.zprofile` および `.bash_profile` には、環境変数の設定だけでなく、インタラクティブシェル（対話型シェル）用の設定（エイリアス、補完、プロンプト表示、ツール初期化など）が混在していました。さらに、これらの Profile ファイルが `~/.zshrc` および `~/.bashrc` の中から再度 `source` されていたため、初期化処理が二重に実行され、外部ツールの実行が一瞬 `bash` として認識される事態を引き起こしていました。

この問題を解決するため、ファイルごとの責務を標準的な方針に従って明確に分割しました。

1. **Profile系の整理 (`.zprofile`, `.bash_profile`)**
   - これらのファイルはログイン時に1回だけ読み込まれる環境変数の定義専用としました。
   - `brew shellenv`, `$PATH` の追加, `.exports` の読み込みのみを残しました。
   - 二重読み込みを防止するためのガード変数 (`ZPROFILE_LOADED`, `BASH_PROFILE_LOADED`) をエクスポートするようにしました。

2. **RC系の整理 (`.zshrc`, `.bashrc`)**
   - 対話型シェルごとに必要な設定をすべてこちらに移行しました。
   - **移行した内容:**
     - インタラクティブな設定 (`setopt`, `shopt`, `bindkey`, `complete` など)
     - ファイルの読み込み (`.zsh_prompt` / `.bash_prompt`, `.aliases`)
     - ツールの初期化 (`anyenv`, `direnv`, `sdkman` など)
   - `.zshrc`, `.bashrc` の先頭で Profile 系のファイルを読み込む処理は、ガード変数をチェックして「未読み込みの場合（非ログインシェルの場合など）のみ」読み込むように修正しました。

## テスト結果 (Testing & Validation Results)

1. エラーなくターミナル（対話型シェル）が起動できることを確認しました。
    - `zsh -i -c 'echo "zsh is working"'` → 成功
    - `bash -i -c 'echo "bash is working"'` → 成功
2. 文法エラーなどが表示されないことを確認しました。

## ユーザー側での確認おねがい (Manual Verification)

iTerm2 で**新規タブまたはウィンドウ**を開き、以下の点をご確認ください。

- タブのタイトル部分で `zsh` と `bash`（またはbrew, sdkmanなどのプロセス名）が何度も行き来する現象がなくなり、起動がスムーズになっているか。
- `brew`, `git`, `anyenv`, `direnv` などの各種コマンドや、その補完機能が従来通りエラーなく動作するか。
- 設定したエイリアス（`.aliases` など）やプロンプト（色がつくなど）が正しく適用されているか。
