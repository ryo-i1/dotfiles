# Neovim Cheat Sheet

`Leader` は `,` です．

## Basic

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Esc Esc` | 検索 highlight を消す |
| normal | `j` | 折り返し表示行で下へ移動 |
| normal | `k` | 折り返し表示行で上へ移動 |
| normal / visual | `Ctrl+n` | 20 行下へ移動 |
| normal / visual | `Ctrl+p` | 20 行上へ移動 |
| normal | `Space O` | 上に空行を挿入 |
| normal | `Space o` | 下に空行を挿入 |
| insert | `Shift+Tab` | indent を 1 段削除 |

## Commands

| Command | Action |
| --- | --- |
| `:R` | 画面を再描画 |
| `:Run [args...]` | zsh file を保存し，下部 terminal で実行 |

`:Run` は `filetype=zsh` の buffer で利用できます．
command line では `:run` も `:Run` に展開されます．

## File Explorer

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Leader e` | Oil を開く |
| Oil | `q` | Oil window を閉じる |
| Oil | `Leader s` | entry を horizontal split で開く |
| Oil | `Leader v` | entry を vertical split で開く |
| Oil | `X` | 選択した archive を展開 |

## Clipboard

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Leader c` | OSC52 yank operator |
| normal | `Leader cc` | 現在行を OSC52 で yank |
| visual | `Leader c` | 選択範囲を OSC52 で yank |

通常の yank でも，対象 register が unnamed，`+`，`*` の場合は
OSC52 へ自動転送されます．

## Search

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Leader ff` | file を検索 |
| normal | `Leader fg` | text を grep |
| normal | `Leader fb` | buffer 一覧を表示 |
| normal | `Leader fh` | help tag を検索 |

## LSP

| Mode | Key | Action |
| --- | --- | --- |
| normal | `K` | hover を表示 |
| normal | `gd` | 定義へ移動 |
| normal | `gr` | reference を表示 |
| normal | `Leader rn` | rename |
| normal | `Leader ca` | code action |
| normal | `Leader d` | diagnostic float を表示 |

LSP keymap は LSP が attach された buffer で有効です．

## Format And Markdown

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Leader Leader` | buffer を format |
| normal | `Leader m` | Markdown render を切り替え |

## Git

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Leader` | 次の hunk へ移動 |
| normal | `[h` | 前の hunk へ移動 |
| normal | `Leader hp` | hunk preview を表示 |
| normal | `Leader hr` | hunk を reset |

## Completion

| Mode | Key | Action |
| --- | --- | --- |
| insert | `Ctrl+Space` | 補完 menu を表示 |
| insert | `Enter` | 補完候補を確定 |
| insert | `Tab` | 次の補完候補を選択 |
| insert | `Shift+Tab` | 前の補完候補を選択 |

## Help

| Mode | Key | Action |
| --- | --- | --- |
| normal | `Leader ?` | which-key を表示 |
