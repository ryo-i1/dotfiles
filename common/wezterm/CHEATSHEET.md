# WezTerm Cheat Sheet

`Leader` は `Ctrl+q` です．

## Workspace

| Key | Action |
| --- | --- |
| `Leader w` | workspace 一覧を表示 |
| `Leader $` | 現在の workspace 名を変更 |
| `Leader Shift+W` | workspace を作成して移動 |

## Tab

| Key | Action |
| --- | --- |
| `Cmd+t` | 現在の pane domain で tab を作成 |
| `Cmd+w` | 現在の tab を閉じる |
| `Ctrl+Tab` | 次の tab へ移動 |
| `Ctrl+Shift+Tab` | 前の tab へ移動 |
| `Leader {` | tab を左へ移動 |
| `Leader }` | tab を右へ移動 |
| `Cmd+1` ... `Cmd+8` | 指定した番号の tab へ移動 |
| `Cmd+9` | 最後の tab へ移動 |

## Pane

| Key | Action |
| --- | --- |
| `Leader d` | pane を上下に分割 |
| `Leader r` | pane を左右に分割 |
| `Leader x` | 現在の pane を閉じる |
| `Leader h` | 左の pane へ移動 |
| `Leader j` | 下の pane へ移動 |
| `Leader k` | 上の pane へ移動 |
| `Leader l` | 右の pane へ移動 |
| `Ctrl+Shift+[` | pane 選択 |
| `Leader z` | 現在の pane の zoom を切り替え |
| `Leader a` then `h/j/k/l` | 方向を指定して pane へ移動 |
| `Leader s` then `h/j/k/l` | pane サイズを調整 |
| `Leader s` then `Enter` | pane サイズ調整モードを終了 |

## Copy And Paste

| Key | Action |
| --- | --- |
| `Leader [` | copy mode を開始 |
| `Cmd+c` | clipboard へコピー |
| `Cmd+v` | clipboard から貼り付け |

### Copy Mode

| Key | Action |
| --- | --- |
| `h/j/k/l` | カーソルを移動 |
| `w` / `b` / `e` | 単語単位で移動 |
| `0` / `^` / `$` | 行頭，非空白の行頭，行末へ移動 |
| `g` / `G` | scrollback の先頭，末尾へ移動 |
| `H` / `M` / `L` | viewport の上，中央，下へ移動 |
| `Ctrl+b` / `Ctrl+f` | 1 ページ上，下へ移動 |
| `Ctrl+u` / `Ctrl+d` | 半ページ上，下へ移動 |
| `f` / `t` | 前方へ文字ジャンプ |
| `F` / `T` | 後方へ文字ジャンプ |
| `;` | 直前のジャンプを繰り返し |
| `v` | cell 選択 |
| `Ctrl+v` | block 選択 |
| `V` | line 選択 |
| `o` / `O` | 選択範囲の反対側へ移動 |
| `y` | clipboard へコピー |
| `Enter` | コピーして copy mode を終了 |
| `Esc` / `Ctrl+c` / `q` | copy mode を終了 |

## Window And Command

| Key | Action |
| --- | --- |
| `Cmd+p` | command palette を表示 |
| `Ctrl+Shift+p` | command palette を表示 |
| `Ctrl+Shift+r` | 設定を再読み込み |
| `Alt+Enter` | full screen を切り替え |
| `Ctrl++` | font size を大きくする |
| `Ctrl+-` | font size を小さくする |
| `Ctrl+0` | font size を reset |

## Input

| Key | Action |
| --- | --- |
| `¥` | `\` を入力 |
| `Opt+¥` | `¥` を入力 |
