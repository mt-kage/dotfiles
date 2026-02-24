# [Goal Description]

現在のシェル設定は `.zprofile` および `.bash_profile` に環境変数とインタラクティブな設定（エイリアスや補完、画面表示など）が混在しており、さらに `.zshrc` / `.bashrc` からそれらを再度読み込むことで、初期化処理が二重に実行されています。これにより、iTerm2などで新規セッションを開くたびに `zsh` と `bash`（外部コマンドの実行）が複数回行き来して表示される現象が起きています。

この計画では、シェルの設定ファイルの標準的な責務（Profile系は環境変数やパスの定義、RC系は対話型シェルの設定）に従って設定内容を分割し、二重実行を解消します。

## Proposed Changes

### Configuration Files

#### [MODIFY] [.zprofile](file:///Users/mt-kage/dotfiles/configs/.zprofile)
- **残すもの:** `brew shellenv`, `.path` や `.exports` の読み込み。これらはログイン時に一度だけ設定されれば環境変数として子プロセスに引き継がれるため、ここに配置します。
- **削除するもの:** 履歴設定(`APPEND_HISTORY`など)、キーバインド(`bindkey`)、ディレクトリ移動(`cd`)に関わる設定、補完(`compinit`)、`anyenv`, `direnv`, `sdkman` 等の初期化。これらは `.zshrc` に移行します。

#### [MODIFY] [.zshrc](file:///Users/mt-kage/dotfiles/configs/.zshrc)
- `.zprofile` から移行するインタラクティブな設定（履歴、補完、キーバインドなど）を記述します。
- `.aliases` と `.zsh_prompt` の読み込みをここで行うように変更します。
- `anyenv init`, `direnv hook`, `sdkman-init.sh` などのツール群の初期化（関数定義やフックの登録を行うため、対話型シェルごとに必要）をここに配置します。
- `[ -n "$PS1" ] && source ~/.zprofile;` の記述を削除、または二重読み込み防止のガードを追加します。基本的には macOS では Terminal/iTerm2 が常にログインシェルを起動するため、`.zprofile` → `.zshrc` の順で安全に実行されます。非ログインシェル（tmux など）のために環境変数を再評価したい場合は、インクルードガード（例: `[ -z "$ZPROFILE_LOADED" ]`）を設けて対応します。

#### [MODIFY] [.bash_profile](file:///Users/mt-kage/dotfiles/configs/.bash_profile)
- `.zprofile` と同様の方針で、`brew shellenv`, `.path`, `.exports` の読み込みのみを残します。

#### [MODIFY] [.bashrc](file:///Users/mt-kage/dotfiles/configs/.bashrc)
- `.bash_profile` から移行するインタラクティブな設定（`shopt`, `complete`, historyなど）を記述します。
- `.aliases`, `.bash_prompt` の読み込みと、各種ツールの初期化処理を配置します。
- `source ~/.bash_profile` を削除（またはガード処理による一回のみの読み込みに変更）します。

## Verification Plan

### Manual Verification
- ユーザーに iTerm2 で新規タブを開いていただき、タブやタイトルの表示が高速化され、ちらつき（`zsh` と `bash` の行き来）が解消されているか確認してもらいます。
- ターミナル上で `brew`, `anyenv`, `direnv`, `sdk` などのコマンドが正常に動作するか（環境変数や補完などの設定が正しくロードされているか）を確認してもらいます。
- `zsh` および `bash` の両方で、プロンプトの表示やエイリアスが適用されていることを確認します。
