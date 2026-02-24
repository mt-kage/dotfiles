# Shell Configuration Split Task List

- [ ] `configs/.zprofile` の責務分割
  - [ ] 環境変数・パス設定 (`brew shellenv`, `.path`, `.exports`) を残す
  - [ ] インタラクティブな設定（履歴、補完、キーバインドなど）を削除
- [ ] `configs/.zshrc` の構築
  - [ ] `.zprofile` からインタラクティブな設定（履歴、補完、キーバインドなど）を移行
  - [ ] `.aliases`, `.zsh_prompt` の読み込みを移行
  - [ ] `anyenv`, `direnv`, `sdkman` などの初期化処理を移行
  - [ ] `source ~/.zprofile` の読み込み処理を削除（ただし、非ログインシェル用に環境変数が必要な場合のガード処理は検討）
- [ ] `configs/.bash_profile` の責務分割
  - [ ] 環境変数・パス設定 (`brew shellenv`, `.path`, `.exports`) を残す
  - [ ] インタラクティブな設定（履歴設定、shopt、補完など）を削除
- [ ] `configs/.bashrc` の構築
  - [ ] `.bash_profile` からインタラクティブな設定を移行
  - [ ] `.aliases`, `.bash_prompt` の読み込みを移行
  - [ ] `anyenv`, `direnv`, `sdkman` などの初期化処理を移行
  - [ ] `source ~/.bash_profile` の読み込み処理を削除
