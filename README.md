# dotfiles

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply didy-kpn
```

# TOOLS

## chezmoi

[chezmoi](https://github.com/twpayne/chezmoi)

https://www.chezmoi.io/user-guide/command-overview/#daily-commands

### 同期（ローカルの変更を dotfiles に取り込む）

```
chezmoi add <path>
```

例:

```
chezmoi add ~/.local/share/devbox/global/default/devbox.json
chezmoi add ~/.local/share/devbox/global/default/devbox.lock
```

### 展開（dotfiles の内容を反映する）

```
chezmoi apply
```

## devbox (global)

devbox のグローバル環境は `devbox global shellenv` を利用します。
パッケージ追加は以下で行い、生成された `devbox.json` と `devbox.lock` を `chezmoi add` で取り込みます。

```
devbox global add <packages...>
```

### Services

常駐サービスは devbox で管理します。開始・停止は次の通りです。

```
devbox services start|stop [service]
```

詳細な設定・環境変数は `devbox info <package>` で確認できます。

```
devbox info mysql
devbox info php
devbox info rustup
devbox info nodejs
devbox info python3
```

# License

This project is licensed under the MIT License.

See [LICENSE](https://github.com/didy-kpn/dotfiles/blob/master/LICENSE) for details.
