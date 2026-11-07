# Neovim

Neovim 0.12以降の `vim.pack` を使う、コードレビュー中心の設定です。配色は Kanagawa Wave です。設定本体は `init.lua`、`lua/dotfiles/`、`after/lsp/` にあります。

## セットアップと更新

`task link:dry-run` でリンク先を確認し、必要なら `task link` を実行します。プラグインは初回起動時に `vim.pack` が `nvim-pack-lock.json` のリビジョンで導入します。固定ファイルはGit管理し、更新時は設定と一緒に保存します。更新はリポジトリのルートから `task nvim:sync` を実行します。言語サーバーやフォーマッターは Mason が起動時に確認し、自動更新はしません。Treesitter はパーサーを追加・更新します。

必要なCLIは `git`、`tree-sitter` とCコンパイラ、`curl`、`tar`、Node.js/npm、`rg`、`fd`、`lazygit`、`delta` です。`tree-sitter` はMasonからも導入します。アイコンには Nerd Font を使います。Copilot は初回に `:Copilot auth` が必要です。

設定を編集した後は `:wa` で保存し、`ZR` でNeovimを再起動できます。`task check` と `nvim --headless +qa` で基本的な確認を行います。

## 表示と編集

- 配色は透明背景の Kanagawa Wave。タブが2つ以上のとき自作タブラインを表示し、各ウィンドウのファイル名は incline.nvim で表示します。lualine は画面下に1本です。
- Space が leader と localleader です。行番号と相対行番号、カーソル行、2スペースのインデント、永続アンドゥ、Treesitter折りたたみを有効にしています。マウスは無効です。
- コマンドラインは tiny-cmdline.nvim、通知と検索は Snacks、メッセージは Neovim 0.12 の ui2 を使用します。
- `x`、`<leader>d/c` は無名レジスタを変えずに削除・変更し、`<leader>p` は直前にヤンクした内容を貼ります。`+` / `-` は数値変更、`Ctrl-a` は全選択です。
- `te` は新規タブ、`Tab` / `Shift-Tab` はタブ移動。`ss` / `sv` は分割、`sh` / `sj` / `sk` / `sl` はウィンドウ移動です。
- `<leader>bd` は未保存のものを除く隠れバッファを閉じます。`<leader>o` / `<leader>O` はコメント継続なしで行を挿入します。

## ファイルと検索

| キー | 動作 |
| --- | --- |
| `;f` / `;r` | 隠しファイルを含むファイル検索 / grep |
| `;;` | 最後のピッカーを再表示 |
| `\\` | バッファ一覧。表示中のウィンドウがあればそこへ移動 |
| `;e` / `;n` / `;h` | 診断 / 通知履歴 / Gitハンクの一覧 |
| `sf` | Oilのプレビュー付きフローティングを開く |

Oilではディレクトリを通常のバッファのように編集し、`:w` でファイル操作を確定します。`h` は親ディレクトリ、`q` は閉じる操作です。Git状態はアイコンの左側に2列で表示し、左がステージ済み、右が未ステージです。`A` は追加、`M` は変更、`D` は削除、`R` は名前変更、`C` はコピー、`T` は種類変更、`×` は競合、`U` は未追跡を示します。変更を含むディレクトリにも小さく淡い印を添えます。名前とアイコンはOil標準の表示を保ち、Git状態による太字や色付けはしません。Gitの無視対象は一覧から隠し、権限・サイズ・更新日時は表示しません。ファイル名変更時はLSPへ通知し、import更新を自動保存します。

Oilでは行番号とSnacksのカスタム行番号欄を無効にし、Git状態のサイン欄を常に2列確保します。

Git表示は `lua/dotfiles/utils/oil_git_status.lua` で非同期に取得します。名前変更・コピーや特殊文字を含む名前を正確に扱うため、GitのNUL区切り出力を使います。フォルダに異なる変更が混在する場合は `M`、競合を含む場合は赤い `×` を優先します。削除済みファイルは一覧には残りませんが、親フォルダに削除状態を表示します。Git操作後は `Ctrl-l` で一覧と状態を更新できます。

Git状態の解析チェックは、リポジトリのルートで `nvim --headless --clean -i NONE -l .config/nvim/tests/oil_git_status.lua` を実行します。

## LSP、補完、整形

`vim.lsp.enable()` で ESLint、Oxlint、Lua、CSS、TypeScript/JavaScript、Tailwind CSS、Rust のサーバーを有効にします。サーバー固有の設定は `after/lsp/` にあります。blink.cmp は Enter で補完を確定し、説明を200ms後に表示します。mini.pairs は括弧を補完します。挿入モードのインライン候補はCopilotが表示します。Copilot の候補は `Ctrl-l` で確定し、Alt-l / Alt-Shift-l で一部を確定します。GhosttyではOptionをAltとして送ります。

| キー | 動作 |
| --- | --- |
| `gd` / `gr` | 定義 / 参照をピッカーで確認 |
| `gD` / `gy` / `gI` | 宣言 / 型定義 / ソース定義または実装 |
| `K` / `gK` | ホバー / シグネチャ |
| `<leader>ca` / `<leader>cr` | コードアクション / リネーム |
| `<leader>f` | Conformで整形 |
| `Ctrl-j` | 次の診断へ移動 |

保存時は Conform が最大1秒で整形し、利用できるフォーマッターがなければLSPへフォールバックします。Web系はプロジェクトに設定があるとき oxfmt、次に prettierd、prettier の順です。Lua は stylua、シェルは shfmt、Fish は fish_indent です。`:ToggleFormatter` で現在のバッファの自動整形を切り替えます。

## Gitレビュー

| キー・コマンド | 動作 |
| --- | --- |
| `<leader>gb` / `<leader>gB` | 行 / バッファの blame |
| `<leader>go` | blame対象のコミット時点のファイルを新規タブで開く |
| `<leader>gs` / `<leader>gh` | バッファ / ハンクのステージ切り替え |
| `<leader>gd` | mini.diff のハンク表示 |
| `]c` / `[c` | 次 / 前のハンク |
| `<leader>dv` | CodeDiff の差分ビュー |
| `<leader>dh` / `<leader>dH` | ファイル / リポジトリの履歴 |
| `;g` | Snacks経由で LazyGit を開く |
| `:GitLink` | 現在行または選択範囲のURLをコピー |

LazyGitの `e` は起動元のNeovimウィンドウでファイルを開きます。差分表示には `delta` を使用します。ファイルパネルの `C` は Commitizen (`git cz`) を開きます。`task link` が `~/.czrc` を配置し、`task nvim:tools` がコマンドを導入します。

## エージェントへ文脈を渡す

| キー | 動作 |
| --- | --- |
| `<leader>yf` / `<leader>yp` | 現在行付きの相対 / 絶対ファイルパスをコピー |
| `<leader>cc`（選択中） | 作業ディレクトリからの相対パスと行番号付きMarkdownコードブロックをコピー |
| `<leader>j` | プロジェクトの `package.json` をフローティングで表示 |
