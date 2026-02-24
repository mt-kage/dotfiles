# dotfiles zsh対応 ウォークスルー

## 変更概要

bash専用だったdotfilesにzshサポートを追加した。

## 新規作成ファイル

| ファイル | 内容 |
|---------|------|
| [.zprofile](file:///Users/mt-kage/dotfiles/configs/.zprofile) | `.bash_profile` 相当。PATH、brew、共通dotfiles読み込み、zsh固有オプション、補完、anyenv/direnv/sdkman |
| [.zshrc](file:///Users/mt-kage/dotfiles/configs/.zshrc) | `.bashrc` 相当。ログインシェル時に `.zprofile` を読み込む |
| [.zsh_prompt](file:///Users/mt-kage/dotfiles/configs/.zsh_prompt) | `.bash_prompt` 相当。zsh形式のプロンプト（`%n`, `%~`, `%{...%}` 等に変換） |

## 修正ファイル

| ファイル | 変更内容 |
|---------|---------|
| [.exports](file:///Users/mt-kage/dotfiles/configs/.exports) | `HISTFILESIZE`/`HISTCONTROL` をbash用、`SAVEHIST` をzsh用に条件分岐。`BASH_SILENCE_DEPRECATION_WARNING` をbash限定に |
| [deploy.sh](file:///Users/mt-kage/dotfiles/scripts/deploy.sh) | デプロイ後のsource対象をシェル種別で切り替え |
| [initialize.sh](file:///Users/mt-kage/dotfiles/scripts/initialize.sh) | `chsh -s /bin/bash` を削除（bash/zsh両方使用可能に） |

## bash → zsh 主な変換ポイント

| bash | zsh | 用途 |
|------|-----|-----|
| `shopt -s nocaseglob` | `setopt NO_CASE_GLOB` | 大文字小文字を区別しないglob |
| `shopt -s histappend` | `setopt APPEND_HISTORY` | ヒストリ追記 |
| `shopt -s cdspell` | `setopt CDSPELL` | cdタイプミス補正 |
| `shopt -s globstar` | `setopt EXTENDED_GLOB` | 拡張グロブ |
| `shopt -s autocd` | `setopt AUTO_CD` | cd省略 |
| `complete` | `zstyle ':completion:*'` | 補完設定 |
| `PS1` (`\u`, `\w`, `\[...\]`) | `PROMPT` (`%n`, `%~`, `%{...%}`) | プロンプト |

## 検証結果

すべてのファイルで構文チェック（`zsh -n` / `bash -n`）が正常に通過：

- ✅ `.zprofile` — `zsh -n` OK
- ✅ `.zshrc` — `zsh -n` OK
- ✅ `.zsh_prompt` — `zsh -n` OK
- ✅ `.exports` — `bash -n` OK / `zsh -n` OK
