# Scripts リファクタリング 完了報告

## 変更したファイル

| ファイル | 種別 | 主な変更 |
|---------|------|---------|
| [common.sh](file:///Users/mt-kage/dotfiles/scripts/lib/common.sh) | 新規 | 共通関数（ログ、`exists_command`、`execute`、`is_arm`、`show_banner`） |
| [deploy.sh](file:///Users/mt-kage/dotfiles/scripts/deploy.sh) | 修正 | `--dry-run`追加、`KARAVINER`→`KARABINER` typo修正 |
| [initialize.sh](file:///Users/mt-kage/dotfiles/scripts/initialize.sh) | 修正 | `rm -f`、`mkdir -p`、`~/`→`$HOME`、anyenvのexit→warn |
| [install.sh](file:///Users/mt-kage/dotfiles/scripts/install.sh) | 修正 | `trap`によるクリーンアップ追加 |
| [update.sh](file:///Users/mt-kage/dotfiles/scripts/update.sh) | 修正 | 重複関数削除、`common.sh` source |

## 全ファイル共通の変更

- `#!/bin/bash` → `#!/usr/bin/env bash`
- `set -euo pipefail` 追加
- 全変数展開にダブルクォート追加
- `echo` → カラーログ関数（`log_info`, `log_success`, `log_warn`, `log_error`）

## 各ファイルの diff

render_diffs(file:///Users/mt-kage/dotfiles/scripts/lib/common.sh)

render_diffs(file:///Users/mt-kage/dotfiles/scripts/deploy.sh)

render_diffs(file:///Users/mt-kage/dotfiles/scripts/initialize.sh)

render_diffs(file:///Users/mt-kage/dotfiles/scripts/install.sh)

render_diffs(file:///Users/mt-kage/dotfiles/scripts/update.sh)

## ShellCheck 検証結果

```
✅ warning/error: 0件
ℹ️ info (SC1091): 2件 — 動的sourceパスの静的解析不可（想定内）
```
