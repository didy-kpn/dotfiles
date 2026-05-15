# Neovim Configuration

Helix からの移行を前提に、Neovim 0.11 系で使いやすい最小構成へ整理した設定です。`tokyonight` を前提に、LSP、Treesitter、検索、複数カーソル、Git 操作を標準寄りの構成でまとめています。

## 方針

- LazyVim 依存は外し、`lazy.nvim` だけでプラグインを管理します。
- `lua/config/options.lua` と `lua/config/keymaps.lua` を起点に、挙動を把握しやすい構成にしています。
- Helix の「標準で入っている体験」を Neovim 本体機能と少数プラグインで再現します。

## プラグイン一覧

- `folke/tokyonight.nvim`
  説明: カラースキーマです。
  利用理由: 要望どおり `tokyonight` で統一し、LSP や補完 UI と相性が良いためです。

- `folke/snacks.nvim`
  説明: picker、通知、input、statuscolumn などをまとめた QoL 集です。
  利用理由: Telescope を分解せず、検索やバッファ一覧を軽量にまとめられるためです。インデントとスコープ表示は専用プラグインへ分離しています。

- `lukas-reineke/indent-blankline.nvim`
  説明: インデントガイドと現在スコープの強調表示を行います。
  利用理由: スコープの見え方を細かく調整しやすく、Helix 的なブロック把握に寄せやすいためです。現在はインデントをレインボー配色、現在スコープを太線で強調し、PHP では `if`、`for`、`while`、`switch`、配列、括弧式などにも適用しています。

- `HiPhish/rainbow-delimiters.nvim`
  説明: Treesitter ベースで括弧やブロックの対応関係を色分け表示します。
  利用理由: ネストの深いコードでも括弧の対応を追いやすくするためです。

- `folke/flash.nvim`
  説明: 画面内ジャンプと Treesitter ベース移動を強化します。
  利用理由: Helix の高速な移動感に最も近づけやすいためです。

- `stevearc/oil.nvim`
  説明: ディレクトリをバッファとして編集するファイルブラウザです。
  利用理由: ツリー UI より軽く、Helix のファイル操作感に寄せやすいためです。

- `Bekaboo/dropbar.nvim`
  説明: winbar にパンくずを表示し、現在の文脈を辿れます。
  利用理由: `nvim-navic` より操作性が高く、LSP と Treesitter の両方で文脈ナビゲーションをしやすいためです。

- `nvim-treesitter/nvim-treesitter`
  説明: 構文解析、ハイライト、fold、textobject を提供します。
  利用理由: Helix 同様に Treesitter を編集体験の中核に置くためです。

- `nvim-treesitter/nvim-treesitter-textobjects`
  説明: 関数やクラス単位の textobject を追加します。
  利用理由: 構文単位の選択や移動を増やし、Helix の selection 操作を補うためです。

- `neovim/nvim-lspconfig`
  説明: Neovim 標準 LSP のサーバ設定を提供します。
  利用理由: 0.11 系の標準 LSP を素直に使うためです。

- `mason.nvim`
  説明: LSP や formatter の外部ツールを管理します。
  利用理由: 言語サーバ導入の手間を減らすためです。

- `mason-lspconfig.nvim`
  説明: Mason と `nvim-lspconfig` をつなぎます。
  利用理由: よく使う LSP を揃えやすくするためです。

- `Saghen/blink.cmp`
  説明: 補完 UI と LSP 補完を提供します。
  利用理由: `nvim-cmp` より軽快で、Neovim 0.11 系との相性が良く、候補一覧にソース名を出して `phpactor` と snippet を見分けやすくできるためです。

- `zbirenbaum/copilot.lua`
  説明: GitHub Copilot のインライン提案 UI を提供します。
  利用理由: `copilot-language-server` 単体よりグレー表示の補完が安定しやすいためです。提案は `tokyonight` に合わせて水色寄りに強調しています。

- `nvim-neotest/neotest`
  説明: テストの実行、結果表示、サマリー表示を提供します。
  利用理由: エディタ内で PHPUnit を回せるようにし、PHP のテスト実行を素早くするためです。Laravel では `vendor/bin/phpunit` を優先して使います。

- `mfussenegger/nvim-dap`
  説明: DAP クライアントです。
  利用理由: PHP を Xdebug + `php-debug-adapter` でデバッグできるようにするためです。

- `rcarriga/nvim-dap-ui`
  説明: DAP の変数、スタック、REPL などの UI を表示します。
  利用理由: ブレークポイント停止後の状態確認をエディタ内でしやすくするためです。

- `stevearc/conform.nvim`
  説明: 保存時フォーマットを担当します。
  利用理由: LSP format と外部 formatter の切り替えが扱いやすいためです。PHP は Laravel 向けに `pint` へ固定しています。

- `mfussenegger/nvim-lint`
  説明: 外部 linter の結果を `vim.diagnostic` に流し込みます。
  利用理由: Laravel では PHP の診断を `phpstan + larastan` に寄せたいためです。

- `lewis6991/gitsigns.nvim`
  説明: hunk 差分、blame、preview を表示します。
  利用理由: Helix の Git 情報表示を Neovim で補うためです。

- `brenton-leighton/multiple-cursors.nvim`
  説明: 複数カーソルを提供します。
  利用理由: Helix 移行時に最も不足しやすい操作を補うためです。

- `nvim-mini/mini.ai`
  説明: textobject を拡張します。
  利用理由: selection-first には届かなくても、構文単位の編集を増やせるためです。

- `nvim-mini/mini.surround`
  説明: surround の追加・削除・置換を提供します。
  利用理由: Helix でよく使う括弧や引用符まわりの編集を素早くするためです。

- `nvim-mini/mini.pairs`
  説明: 括弧や引用符の自動補完を行います。
  利用理由: 標準に近い軽さで自動ペアを足せるためです。

- `numToStr/Comment.nvim`
  説明: コメントトグルを提供します。
  利用理由: Neovim 標準の `gc` 系操作を複数カーソル時にも扱いやすくするためです。

- `MagicDuck/grug-far.nvim`
  説明: プロジェクト全体の検索置換を行います。
  利用理由: Helix のワークスペース置換を補うためです。

- `folke/which-key.nvim`
  説明: キーマップの候補をポップアップ表示します。
  利用理由: `preset = "helix"` で移行直後の学習コストを下げるためです。

## キーマップ一覧

### 基本

- `<leader>w`: 保存
- `<leader>q`: 終了
- `<Esc>`: 検索ハイライト解除
- `x`: ヤンクせず 1 文字削除
- `<leader>ay`: バッファ全選択

### ウィンドウ・バッファ

- `<leader>-`: 横分割
- `<leader>|`: 縦分割
- `<C-h>` `<C-j>` `<C-k>` `<C-l>`: ウィンドウ移動
- `<leader>h`: 前のバッファ
- `<leader>l`: 次のバッファ
- `<leader>bd`: バッファ削除
- `-`: `oil.nvim` で親ディレクトリを開く

### 検索・移動

- `<leader>ff`: ファイル検索
- `<leader>fg`: 文字列検索
- `<leader>fb`: バッファ一覧
- `<leader>fr`: 最近開いたファイル
- `<leader>fh`: ヘルプ検索
- `<leader>fd`: diagnostics 一覧
- `<leader>sr`: 現在語句を起点に検索置換
- `s`: `flash.nvim` でジャンプ
- `S`: Treesitter 対象へジャンプ
- `r` `R` (`o/x` モード): remote jump / treesitter search
- `<leader>;`: `dropbar.nvim` のパンくずを選択
- `[;`: 現在コンテキストの先頭へ移動
- `];`: 次のコンテキスト候補を選択

### LSP

- `K`: hover
- `gd`: 定義へ移動
- `gD`: 宣言へ移動
- `gr`: 参照一覧
- `gi`: 実装へ移動
- `<leader>ca`: code action
- `<leader>rn`: rename
- `<leader>lf`: format
- `<leader>li`: `:LspInfo` を開く
- `[d` `]d`: diagnostics 前後移動
- `<leader>e`: 行 diagnostics 表示
- `<leader>xq`: location list に diagnostics を流す
- `<C-f>` (`insert`): Copilot の提案を受け入れる
- `<C-g>` (`insert`): Copilot の次候補へ切り替える
- `blink.cmp` の候補一覧末尾: 補完ソース名を表示 (`LSP`, `Snippets`, `Buffer`, `Path` など)

### テスト

- `<leader>tn`: カーソル位置のテストを実行
- `<leader>tf`: 現在ファイルのテストを実行
- `<leader>td`: カーソル位置の PHPUnit テストを `nvim-dap` でデバッグ実行
- `<leader>tD`: 現在ファイルの PHPUnit テストを `nvim-dap` でデバッグ実行
- `<leader>tt`: 最後に実行したテストを再実行
- `<leader>to`: テスト出力を開く
- `<leader>ts`: テストサマリーを開閉
- サマリー上の `<CR>`: 選択位置へ移動
- サマリー上の `r`: 選択したテストまたはスイートを実行
- サマリー上の `t`: 実行ターゲットを切り替え
- サマリー上の `o`: 出力を開く
- サマリー上の `m`: マーク切り替え
- サマリー上の `M`: マークをクリア
- サマリー上の `[t` `]t`: 前後の失敗テストへ移動
- サマリー上の `u`: 実行中テストを停止

### デバッグ

- `<leader>dc`: デバッグ開始 / 継続
- `<leader>db`: ブレークポイント切り替え
- `<leader>di`: step into
- `<leader>do`: step over
- `<leader>dO`: step out
- `<leader>du`: DAP UI 開閉
- `<leader>dr`: DAP REPL 開閉
- `<leader>dx`: デバッグ終了

### Git

- `<leader>gg`: LazyGit
- `<leader>gb`: 現在行の blame
- `<leader>gd`: 現在バッファの diff
- `<leader>gh`: hunk preview
- `[h` `]h`: hunk 前後移動

### 複数カーソル

- `<leader>ma`: 単語一致へカーソル追加
- `<leader>mn`: 次の一致へ進みつつカーソル追加
- `<leader>mN`: 前の一致へ戻りつつカーソル追加
- `<leader>mv`: visual 選択した各行へカーソル追加
- `<leader>ml`: 仮想カーソルのロック切り替え

### Textobject / Surround / Comment

- `gc` `gcc`: コメント切り替え
- `sa`: surround 追加
- `sd`: surround 削除
- `sr`: surround 置換
- `af` `if`: 関数 textobject
- `ac` `ic`: class textobject

## 補足

- LSP の有効化対象は `lua_ls`, `rust_analyzer`, `gopls`, `pyright`, `jsonls`, `yamlls`, `bashls`, `taplo`, `marksman`, `phpactor`, `intelephense`, `typos_lsp` です。
- Mason の追加導入対象として `php-debug-adapter` と `intelephense` も含めています。
- スコープ表示は `indent-blankline.nvim`、括弧の色分けは `rainbow-delimiters.nvim`、パンくずは `dropbar.nvim` に分担しています。
- `phpactor` は Laravel 向けに、LSP が解決した project root 配下の `_ide_helper.php` と `_ide_helper_models.php` が存在する場合だけ `indexer.stub_paths` と `worse_reflection.additive_stubs` に追加しています。
- `phpactor` の indexer は Laravel プロジェクト向けに `vendor/composer`, `storage/framework`, `bootstrap/cache`, `node_modules`, `public/build` などを除外しています。
- `phpactor` は負荷軽減のため `vendor` 全体を index 対象から外し、`file_events` と更新時 diagnostics を止めています。Laravel では補完と診断を主に `intelephense` に任せています。
- PHP 系 LSP の root は `.git` より `composer.json` と `artisan` を優先するため、Laravel では `backend` をプロジェクトルートとして扱います。
- PHP では補完を `intelephense` に寄せるため、`phpactor` の `completionProvider` は無効化しています。
- PHP の保存時整形は `vendor/bin/pint` を優先して使います。
- PHP のテスト実行は `neotest` 経由で `~/.local/bin/phpunit-neotest` を使います。このラッパーは PHP で動作し、`memory_limit=512M` を設定したうえで project の `vendor/bin/phpunit` を探して実行します。`phpunit.xml` または `phpunit.xml.dist` がある Laravel / PHP プロジェクトを前提にしています。
- PHP のデバッグは `nvim-dap` から `php-debug-adapter` を使います。テストのデバッグ実行 (`<leader>td`, `<leader>tD`) も `neotest` の `dap` strategy ではなく `nvim-dap` 直実行です。ローカル devbox 実行を前提に `pathMappings` は設定していません。Xdebug 側は通常 `client_port=9003` が必要です。
- PHP の診断は `nvim-lint` 経由で `vendor/bin/phpstan` を優先して使います。Laravel では `composer require --dev laravel/pint phpstan/phpstan larastan/larastan` を前提にしています。
- formatter は `stylua`, `shfmt`, `prettier`, `rustfmt`, `gofmt`, `ruff_format`, `taplo`, `pint` を想定しています。
- 外部ツールの導入は `:Mason` から追加できます。
