# dotfiles zsh対応 実装計画

bashのみ対応していたdotfilesにzshサポートを追加する。既存のbash設定を参考にzsh用の設定ファイルを作成し、共通ファイル（`.exports`, `.aliases`）はbash/zsh両対応にする。

---

## 変更内容

### 新規ファイル

#### [NEW] [.zprofile](file:///Users/mt-kage/dotfiles/configs/.zprofile)

`.bash_profile` に相当するzshのログインシェル設定ファイル。以下を含む：

- `~/bin`, `~/.local/bin`, `~/.opencode/bin` のPATH追加
- Homebrew shellenv（arm64/x86判定）
- 共通dotfiles（`.path`, `.zsh_prompt`, `.exports`, `.aliases`）の読み込み
- zsh固有のシェルオプション設定（`nocaseglob` → `NO_CASE_GLOB` 等）
- 補完システムの初期化（`compinit`）
- Google Cloud SDK補完（zsh版）
- anyenv / direnv の初期化（zsh版フック）
- Python自動activate関数（`precmd` フック）
- SDKMAN初期化

#### [NEW] [.zshrc](file:///Users/mt-kage/dotfiles/configs/.zshrc)

`.bashrc` に相当するzshの設定ファイル。ログインシェルの場合に `.zprofile` を読み込む（`.bashrc` と同じ構造）。

#### [NEW] [.zsh_prompt](file:///Users/mt-kage/dotfiles/configs/.zsh_prompt)

`.bash_prompt` をベースにしたzsh用プロンプト設定。以下の変更を含む：

- `prompt_git()` 関数はそのまま流用（POSIX互換のため）
- `PS1` をzshの `PROMPT` 形式に変換
  - `\u` → `%n`, `\w` → `%~`, `\$` → `%#` 等
  - `\[...\]` → `%{...%}` でエスケープ
- `PS2` → `PROMPT2`
- 色定義は `tput` ベースのまま維持

---

### 既存ファイル修正

#### [MODIFY] [.exports](file:///Users/mt-kage/dotfiles/configs/.exports)

- `BASH_SILENCE_DEPRECATION_WARNING=1` をbash実行時のみに条件分岐
- `HISTFILESIZE` を条件分岐（zshでは `SAVEHIST` を使用）
- `HISTCONTROL` を条件分岐（zshでは `setopt` で制御）
- zsh用のヒストリ関連設定を追加

```diff
-# Increase Bash history size. Allow 32³ entries; the default is 500.
-export HISTSIZE='32768';
-export HISTFILESIZE="${HISTSIZE}";
-# Omit duplicates and commands that begin with a space from history.
-export HISTCONTROL='ignoreboth';
+# Increase history size. Allow 32³ entries.
+export HISTSIZE='32768';
+if [ -n "$BASH_VERSION" ]; then
+  export HISTFILESIZE="${HISTSIZE}";
+  # Omit duplicates and commands that begin with a space from history.
+  export HISTCONTROL='ignoreboth';
+elif [ -n "$ZSH_VERSION" ]; then
+  export SAVEHIST="${HISTSIZE}";
+fi
```

```diff
-# bash waring disable for macOS.
-export BASH_SILENCE_DEPRECATION_WARNING=1
+# bash warning disable for macOS.
+if [ -n "$BASH_VERSION" ]; then
+  export BASH_SILENCE_DEPRECATION_WARNING=1
+fi
```

#### [MODIFY] [deploy.sh](file:///Users/mt-kage/dotfiles/scripts/deploy.sh)

- `source ~/.bashrc` の後に、zshの場合の `source ~/.zshrc` を追加（現在のシェルに応じて切り替え）

```diff
-  source ~/.bashrc
+  if [ -n "$ZSH_VERSION" ]; then
+    source ~/.zshrc
+  else
+    source ~/.bashrc
+  fi
```

#### [MODIFY] [initialize.sh](file:///Users/mt-kage/dotfiles/scripts/initialize.sh)

- デフォルトシェルの `chsh` 行を削除し、bash/zsh両方を使えるようにする（ユーザーが任意に切り替え可能）

---

## 変更不要のファイル

| ファイル | 理由 |
|---------|------|
| `.aliases` | POSIX互換の構文のみ使用、bash/zsh両対応で変更不要 |
| `.inputrc` | readline用設定。zshでは使用しないが、bash側で引き続き必要なため変更不要 |
| `.curlrc`, `.gitconfig` 等 | シェル非依存のため変更不要 |

---

## 検証計画

### 構文チェック
- `zsh -n configs/.zshrc` で構文エラーがないことを確認
- `zsh -n configs/.zsh_prompt` で構文エラーがないことを確認
- `bash -n configs/.exports` でbashでの構文互換性を確認

### ユーザーによる手動確認
- デプロイ後に `zsh` を起動し、プロンプトが正しく表示されることを確認
- `zsh` でエイリアスが動作することを確認
- `zsh` でGit補完が動作することを確認
