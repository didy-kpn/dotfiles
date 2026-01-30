# Dotfiles Modernization (Homebrew + Devbox)


This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds. This document follows `/Users/note066/.codex/.agent/PLANS.md`.

## Purpose / Big Picture


この変更により、Homebrew は GUI アプリ中心、Devbox は CLI/TUI と言語環境中心に整理され、yabai/skhd は撤去されます。ユーザーは段階的に安全に移行でき、`brew bundle check` と `devbox shell` の双方で環境が再現できることを確認できます。最初の成果は、yabai/skhd が dotfiles と Brewfile から消えていることです。

## Progress


- [x] (2026-01-21 10:52) ExecPlan を作成して合意を取る。
- [x] (2026-01-21 10:53) yabai/skhd を撤去する（Brewfile と設定ファイル）。
- [ ] (2026-01-28 10:40) devbox の導入方針を確定し、mise からの移行を開始する（進行中: Homebrew を cask-only 化、zshrc に devbox global shellenv を追加、mise 連携を削除、devbox global の生成ファイルを取り込み済み。npm グローバルは README から削除し、別途運用方針で対応）。 
- [ ] (2026-01-21 17:05) zsh 設定を整理する（devbox/ツール連携含む。進行中: carapace/zoxide/atuin の初期化、eza/bat/fd/rg のエイリアス整理、peco/mvim の削除）。
- [ ] (2026-01-21 17:05) Helix/rio/yazi/zellij/lazygit を導入・設定する。

## Surprises & Discoveries


- Observation: まだなし。
  Evidence: なし。
- Observation: `devbox global init` はサブコマンドとして存在せず、`devbox global add` などから自動生成される。
  Evidence: `devbox global` のヘルプに `init` がなく、`devbox global path` が設定ディレクトリを作成した。
- Observation: 多数のパッケージを `devbox global add` で一括追加するとインストールに時間がかかり、外部の自動実行ではタイムアウトしやすい。
  Evidence: 120 秒でタイムアウトし、devbox.json の packages が空のままだった。
- Observation: devbox の生成ファイルは `private_dot_local/private_share/devbox/global/default/` に取り込まれた。
  Evidence: `private_dot_local/private_share/devbox/global/default/devbox.json` と `devbox.lock` が作成された。

## Decision Log


- Decision: ExecPlan を作成し、段階的に変更する。
  Rationale: 大規模変更の安全性と検証性を高めるため。
  Date/Author: 2026-01-21 / Codex
- Decision: yabai/skhd は削除し、退避は行わない。
  Rationale: ユーザーが削除を明示指定したため。
  Date/Author: 2026-01-21 / Codex
- Decision: devbox は `devbox global shellenv` を使って常時有効化する。
  Rationale: mise の activate に近い運用で、ユーザーの意図と一致するため。
  Date/Author: 2026-01-21 / Codex
- Decision: Homebrew は GUI（cask）専用にし、CLI/TUI/常駐サービスは devbox に寄せる。
  Rationale: ユーザーの方針に合わせ、責務を分離するため。
  Date/Author: 2026-01-21 / Codex
- Decision: colima と docker/compose、mysql は devbox で管理する。
  Rationale: 常駐サービスも devbox で統一する方針のため。
  Date/Author: 2026-01-21 / Codex
- Decision: exa の代わりに eza を採用する。
  Rationale: 後継ツールを使う方針のため。
  Date/Author: 2026-01-21 / Codex
- Decision: Brewfile は dot_Brewfile として chezmoi 管理し、brew bundle は --global を使う。
  Rationale: chezmoi の命名規則と Homebrew の標準パスに合わせるため。
  Date/Author: 2026-01-21 / Codex
- Decision: セットアップ時に devbox の後に lix 経由で nix を導入し、Xcode CLI Tools を最初に促す。
  Rationale: devbox 利用に必要な Nix を確保し、ツールチェーンの前提を整えるため。
  Date/Author: 2026-01-21 / Codex
- Decision: ターミナルは ghostty/alacritty ではなく rio を採用する。
  Rationale: ユーザー希望に合わせて統一するため。
  Date/Author: 2026-01-27 / Codex

## Outcomes & Retrospective


- まだ途中。最初のマイルストーンである yabai/skhd の撤去が完了した。
- まだ途中。Homebrew の cask-only 化と `brew bundle --global` の適用が完了。devbox 連携準備、run_once_setup.sh の導入が進んだ。zsh の整理が進行中。

## Context and Orientation


このリポジトリは `chezmoi` を前提にした dotfiles 管理です。現在の主な構成は次の通りです。`Brewfile` に Homebrew の定義、`dot_zshenv`/`dot_zshrc` に zsh 設定、`dot_config/` にアプリ設定があります。`Brewfile` は GUI（cask）専用に整理中です。`dot_config` には `alacritty` と `nvim` の設定があり、今後 `rio` と `helix` の設定を追加する予定です。yabai/skhd の設定は最初のマイルストーンで撤去済みです。

## Plan of Work


最初のマイルストーンでは、yabai/skhd の撤去を行います。`Brewfile` から該当 tap と formula を削除し、`dot_config/yabai` と `dot_config/skhd` を削除（または退避）します。`rg -n "yabai|skhd" .` で参照が残っていないことを確認し、`brew bundle check` で整合性を確認します。

次のマイルストーンでは devbox へ移行するための方針を確定し、`mise` からの移行を開始します。どのツールを Homebrew と devbox に振り分けるかを明確にし、`Brewfile` と devbox の定義を更新します。必要なら段階的に併存させ、検証後に `mise` を撤去します。Homebrew は cask-only に整理し、zshrc は `devbox global shellenv` を使う形に変更していきます。devbox のグローバル設定は `devbox global add` の実行で生成します。

その後、zsh 設定を整理し、devbox との連携や不要な設定の削除を進めます。最後に Helix/rio/yazi/zellij/lazygit を導入・設定し、AI コーディング向けの構成を整えます。各段階で小さく検証し、手順は冪等に保ちます。

## Concrete Steps


作業ディレクトリは `/Users/note066/dotfiles` とします。

1) yabai/skhd 撤去
- `Brewfile` から `tap "koekeishiya/formulae"` と `brew "koekeishiya/formulae/skhd"`, `brew "koekeishiya/formulae/yabai"` を削除する。
- `dot_config/skhd` と `dot_config/yabai` を削除する（退避する場合は `archive/` に移動）。
- 参照確認: `rg -n "yabai|skhd" .`

2) 変更確認
- `brew bundle check` を実行し、欠落がないことを確認する。

3) devbox への移行準備（進行中）
- Homebrew を cask-only に整理する。
- `dot_zshrc` に `devbox global shellenv` を追加し、`mise` 連携を削除する。
- `run_once_setup.sh` を追加し、初期セットアップを chezmoi の実行時に自動化する。
- devbox global のパッケージ追加は手元ターミナルで実行し、生成された devbox.json/devbox.lock を chezmoi に取り込む。

4) 直近の更新（2026-01-21）
- `dot_Brewfile` に SketchyBar と AeroSpace を追加し、Homebrew の tap を調整。
- `run_once_setup.sh` に Xcode CLI Tools のインストールを追加。
- zsh のエイリアスと補完の整理を進めた（eza/rg/fd/bat、carapace/atuin/zoxide、peco/mvim の撤去）。

5) 直近の更新（2026-01-28）
- ターミナルを rio に切り替え、Brewfile を完全修飾で安定化。
- `homebrew/cask-fonts` の廃止に対応して tap を削除。
- `chezmoi apply --force` と `brew bundle --global` を正常完了。

次にやるべきこと（短期）
- devbox の npm グローバル導入コマンドを実行し、必要なら実行結果をメモする（codex/gemini/opencode）。
- zsh 設定の最終整理（不要なコメントや設定の最終確認）。
- Helix/rio/yazi/zellij/lazygit の設定ファイル追加と README への導線整理。

## Validation and Acceptance


- `rg -n "yabai|skhd" .` の結果が ExecPlan 内の記述のみになる。
- `brew bundle check` が成功する。
- `dot_config/` に yabai/skhd の設定が存在しない。

## Idempotence and Recovery


`rm -rf` で削除した場合は復元できないため、必要なら `archive/` に移動してから削除します。再実行時は `rg` の結果が空であることを確認し、`Brewfile` に該当行がないことを確認します。`brew bundle check` は何度でも実行してよく、差分があれば出力で分かります。

## Artifacts and Notes


例（期待される `rg` 結果は空）:

    $ rg -n "yabai|skhd" .
    (no output)

## Interfaces and Dependencies


Homebrew は `Brewfile` を唯一のインストール定義とします。Devbox は CLI/TUI と言語環境を管理する手段として扱います。zsh は `dot_zshrc` と `dot_zshenv` を中心に設定します。yabai/skhd の設定ファイルはこのマイルストーンで撤去されます。

更新内容: ExecPlan 作成と yabai/skhd 撤去の完了を反映したため。
