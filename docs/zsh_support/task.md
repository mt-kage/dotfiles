# dotfiles zsh対応タスク

## 計画
- [x] 既存のbash設定ファイルの調査
- [x] 実装計画の作成・レビュー

## 実装
- [x] `.zprofile` の新規作成（`.bash_profile` をベースに）
- [x] `.zshrc` の新規作成（`.bashrc` をベースに）
- [x] `.zsh_prompt` の新規作成（`.bash_prompt` をベースに）
- [x] `.exports` のシェル互換性対応（bash固有部分の条件分岐）
- [x] `deploy.sh` の更新（zsh対応の追加）
- [x] `initialize.sh` の更新（chsh削除でbash/zsh両対応）

## 検証
- [x] 新規ファイルの構文チェック（全パス）
- [ ] ユーザーによる動作確認
