# Scripts リファクタリング 実行計画

dotfiles/scripts 内の4つのシェルスクリプトを、最新のBashベストプラクティスに従ってリファクタリングする。

---

## 変更内容

### 共通ライブラリ

#### [NEW] [common.sh](file:///Users/mt-kage/dotfiles/scripts/lib/common.sh)

全スクリプトから共通関数を切り出した共通ライブラリ。以下を含む：

- **`DOTFILES_DIR`** — スクリプトの位置から自動解決（ハードコード排除）
- **`SCRIPT_DIR`** — 同上
- **カラーログ関数** — `log_info`（青）, `log_success`（緑）, `log_warn`（黄）, `log_error`（赤）
- **`exists_command`** — コマンド存在チェック（3ファイルで重複していたものを統一）
- **`execute`** — サブスクリプト実行（2ファイルで重複していたものを統一）

```bash
#!/usr/bin/env bash
# 共通ライブラリ - 直接実行しない

readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly SCRIPT_DIR="${DOTFILES_DIR}/scripts"

# カラーコード
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

exists_command() { type -a "$1" >/dev/null 2>&1; }

execute() {
  log_info "[${SCRIPT_DIR}/${1}.sh] START"
  /bin/bash "${SCRIPT_DIR}/${1}.sh"
}
```

---

### deploy.sh

#### [MODIFY] [deploy.sh](file:///Users/mt-kage/dotfiles/scripts/deploy.sh)

主な変更：
- Shebang → `#!/usr/bin/env bash`、`set -euo pipefail` 追加
- `common.sh` を `source` し、ローカルの定数定義を `DOTFILES_DIR` ベースに簡略化
- **`KARAVINER_DIR` → `KARABINER_DIR`** typo修正
- 全変数展開にダブルクォート追加
- ログ出力を `log_info` / `log_success` に置換
- **`--dry-run` オプション追加**：引数に `--dry-run` を渡すとリンク作成をプレビューのみ

```diff
-#!/bin/bash
+#!/usr/bin/env bash
+set -euo pipefail
+source "$(dirname "$0")/lib/common.sh"

-readonly DOTFILES_DIR="$(dirname $(cd $(dirname $0); pwd))"
-readonly CONFIGS_DIR="$DOTFILES_DIR/configs"
-readonly VIM_DIR="$DOTFILES_DIR/vim"
-readonly KARAVINER_DIR="$DOTFILES_DIR/karabiner"
+readonly CONFIGS_DIR="${DOTFILES_DIR}/configs"
+readonly VIM_DIR="${DOTFILES_DIR}/vim"
+readonly KARABINER_DIR="${DOTFILES_DIR}/karabiner"
+readonly DRY_RUN="${1:-}"
```

---

### initialize.sh

#### [MODIFY] [initialize.sh](file:///Users/mt-kage/dotfiles/scripts/initialize.sh)

主な変更：
- Shebang・`set -euo pipefail`・`common.sh` source
- バッククォート → `$()` 置換
- `exists_command` を共通ライブラリから使用（ローカル定義削除）
- `rm` → `rm -f`（`.localized` ファイルが無い場合のエラー回避）
- `mkdir` → `mkdir -p`（既存ディレクトリでのエラー回避）
- **`anyenv` → `mise`** への移行

```diff
-readonly UNAME=`uname -m`
+readonly UNAME="$(uname -m)"

-  rm ~/Applications/.localized
+  rm -f ~/Applications/.localized

-  mkdir ~/Projects
+  mkdir -p ~/Projects

-function initialize_anyenv() {
-  if exists_command "anyenv"; then
-    anyenv init
+function initialize_mise() {
+  if exists_command "mise"; then
+    eval "$(mise activate bash)"
```

---

### install.sh

#### [MODIFY] [install.sh](file:///Users/mt-kage/dotfiles/scripts/install.sh)

主な変更：
- Shebang・`set -euo pipefail`・`common.sh` source
- `exists_command` / `execute` のローカル定義を削除（共通ライブラリから使用）
- 全変数にダブルクォート追加
- `cd` にエラーハンドリング追加
- `trap` による一時ファイルクリーンアップ追加
- ログをカラー出力に置換

```diff
-  cd ${DOTFILES_DIR}
+  cd "${DOTFILES_DIR}" || exit 1
```

---

### update.sh

#### [MODIFY] [update.sh](file:///Users/mt-kage/dotfiles/scripts/update.sh)

主な変更：
- Shebang・`set -euo pipefail`・`common.sh` source
- `exists_command` / `execute` のローカル定義を削除
- 全変数にダブルクォート追加
- `cd` にエラーハンドリング追加
- ログをカラー出力に置換

---

## ユーザー確認事項

> [!IMPORTANT]
> **`anyenv` → `mise` への移行について**
> `initialize.sh` 内の `initialize_anyenv` を `initialize_mise` に変更する予定です。
> 現在 `anyenv` で管理している言語ランタイム（Ruby, Node.js等）がある場合、`mise` への移行手順が別途必要になります。
> この変更を含めてよいですか？それとも `anyenv` のまま残しますか？

> [!WARNING]
> **`set -euo pipefail` 導入の影響**
> 未定義変数（`set -u`）でスクリプトが停止するようになるため、`${変数:-デフォルト値}` 構文でのデフォルト値指定が必要な箇所がないか注意します。

---

## 検証計画

### 自動テスト

ShellCheck による静的解析で全スクリプトの品質を検証：

```bash
# ShellCheckがインストールされていない場合
brew install shellcheck

# 全スクリプトを検証
shellcheck scripts/lib/common.sh scripts/deploy.sh scripts/initialize.sh scripts/install.sh scripts/update.sh
```

### 手動検証

1. **`deploy.sh --dry-run` の動作確認**
   - `bash scripts/deploy.sh --dry-run` を実行
   - シンボリックリンクが実際に作成されず、プレビューのみ表示されることを確認

2. **`deploy.sh` の通常実行**
   - `bash scripts/deploy.sh` を実行
   - configs内のドットファイルが `$HOME` に正しくシンボリックリンクされることを確認
   - `ls -la ~/ | grep "^l"` でリンク先が正しいことを確認
