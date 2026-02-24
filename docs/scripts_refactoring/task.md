# Scripts リファクタリング タスクリスト

## Phase 1: 共通ライブラリの作成
- [x] `scripts/lib/common.sh` を新規作成
  - [x] カラー出力用のログ関数（`log_info`, `log_success`, `log_error`, `log_warn`）
  - [x] `exists_command` 関数
  - [x] `execute` 関数
  - [x] `DOTFILES_DIR` の統一的な解決ロジック

## Phase 2: 各スクリプトのリファクタリング
- [x] `deploy.sh` のリファクタリング
  - [x] `set -euo pipefail` 追加
  - [x] Shebang を `#!/usr/bin/env bash` に変更
  - [x] `common.sh` を source
  - [x] 変数クォーティングの修正
  - [x] `KARAVINER_DIR` → `KARABINER_DIR` typo修正
  - [x] `--dry-run` オプションの追加
- [x] `initialize.sh` のリファクタリング
  - [x] `set -euo pipefail` 追加
  - [x] Shebang を `#!/usr/bin/env bash` に変更
  - [x] `common.sh` を source
  - [x] バッククォート → `$()` 置換
  - [x] 変数クォーティングの修正
  - [x] `rm` → `rm -f` に変更
  - [x] `mkdir` → `mkdir -p` に変更
  - [x] `anyenv` 未インストール時の挙動を `exit 1` → `warn` に変更
- [x] `install.sh` のリファクタリング
  - [x] `set -euo pipefail` 追加
  - [x] Shebang を `#!/usr/bin/env bash` に変更
  - [x] ローカル関数定義（初回実行時は common.sh が存在しないため）
  - [x] 変数クォーティングの修正
  - [x] `cd` のエラーハンドリング
  - [x] `trap` によるクリーンアップ追加
- [x] `update.sh` のリファクタリング
  - [x] `set -euo pipefail` 追加
  - [x] Shebang を `#!/usr/bin/env bash` に変更
  - [x] `common.sh` を source（重複関数を削除）
  - [x] 変数クォーティングの修正
  - [x] `cd` のエラーハンドリング

## Phase 3: 検証
- [x] ShellCheck で全スクリプトを静的解析 — warning/error ゼロ ✅
- [ ] `deploy.sh --dry-run` の動作確認（ユーザーに委任）
