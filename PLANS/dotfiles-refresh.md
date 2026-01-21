# Dotfiles Modernization (Homebrew + Devbox)


This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds. This document follows `/Users/note066/.codex/.agent/PLANS.md`.

## Purpose / Big Picture


この変更により、Homebrew は GUI アプリ中心、Devbox は CLI/TUI と言語環境中心に整理され、yabai/skhd は撤去されます。ユーザーは段階的に安全に移行でき、`brew bundle check` と `devbox shell` の双方で環境が再現できることを確認できます。最初の成果は、yabai/skhd が dotfiles と Brewfile から消えていることです。

## Progress


- [x] (2026-01-21 10:52) ExecPlan を作成して合意を取る。
- [x] (2026-01-21 10:53) yabai/skhd を撤去する（Brewfile と設定ファイル）。
- [ ] (2026-01-21 10:50) devbox の導入方針を確定し、mise からの移行を開始する。
- [ ] (2026-01-21 10:50) zsh 設定を整理する（devbox/ツール連携含む）。
- [ ] (2026-01-21 10:50) Helix/ghostty/yazi/zellij/lazygit を導入・設定する。

## Surprises & Discoveries


- Observation: まだなし。
  Evidence: なし。

## Decision Log


- Decision: ExecPlan を作成し、段階的に変更する。
  Rationale: 大規模変更の安全性と検証性を高めるため。
  Date/Author: 2026-01-21 / Codex
- Decision: yabai/skhd は削除し、退避は行わない。
  Rationale: ユーザーが削除を明示指定したため。
  Date/Author: 2026-01-21 / Codex

## Outcomes & Retrospective


- まだ途中。最初のマイルストーンである yabai/skhd の撤去が完了した。

## Context and Orientation


このリポジトリは `chezmoi` を前提にした dotfiles 管理です。現在の主な構成は次の通りです。`Brewfile` に Homebrew の定義、`dot_zshenv`/`dot_zshrc` に zsh 設定、`dot_config/` にアプリ設定があります。yabai と skhd の設定は `dot_config/yabai/executable_yabairc` と `dot_config/skhd/executable_skhdrc` にあります。なお、`dot_config` には `alacritty` と `nvim` の設定もあり、今後 `ghostty` と `helix` の設定を追加する予定です。

## Plan of Work


最初のマイルストーンでは、yabai/skhd の撤去を行います。`Brewfile` から該当 tap と formula を削除し、`dot_config/yabai` と `dot_config/skhd` を削除（または退避）します。`rg -n "yabai|skhd" .` で参照が残っていないことを確認し、`brew bundle check` で整合性を確認します。

次のマイルストーンでは devbox へ移行するための方針を確定し、`mise` からの移行を開始します。どのツールを Homebrew と devbox に振り分けるかを明確にし、`Brewfile` と devbox の定義を更新します。必要なら段階的に併存させ、検証後に `mise` を撤去します。

その後、zsh 設定を整理し、devbox との連携や不要な設定の削除を進めます。最後に Helix/ghostty/yazi/zellij/lazygit を導入・設定し、AI コーディング向けの構成を整えます。各段階で小さく検証し、手順は冪等に保ちます。

## Concrete Steps


作業ディレクトリは `/Users/note066/dotfiles` とします。

1) yabai/skhd 撤去
- `Brewfile` から `tap "koekeishiya/formulae"` と `brew "koekeishiya/formulae/skhd"`, `brew "koekeishiya/formulae/yabai"` を削除する。
- `dot_config/skhd` と `dot_config/yabai` を削除する（退避する場合は `archive/` に移動）。
- 参照確認: `rg -n "yabai|skhd" .`

2) 変更確認
- `brew bundle check` を実行し、欠落がないことを確認する。

## Validation and Acceptance


- `rg -n "yabai|skhd" .` が空になる。
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
