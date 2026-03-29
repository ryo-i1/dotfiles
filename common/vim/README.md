# Vim

このディレクトリは，dotfiles における Vim の設定およびインストールスクリプトを管理します．

---

## 構成

```
common/vim/
├── install.sh
├── uninstall.sh
├── vimrc
└── dotvim/
└── ftdetect/
```

| Path            | Destination     | 説明                          |
|-----------------|-----------------|-------------------------------|
| `vimrc`         | `~/.vimrc`      | メイン設定ファイル（symlink） |
| `dotvim/`       | `~/.vim/`       | Vim 補助設定ディレクトリ      |
| `install.sh`    | -               | インストールスクリプト        |
| `uninstall.sh`  | -               | アンインストールスクリプト    |

---

## インストール

```bash
cd common/vim
./install.sh
```


### 処理内容

* `~/.vimrc` をシンボリックリンクで配置
* `~/.vim/ftdetect` をリンク
* `~/.vim/bundle` を作成
* Vundle を clone
* （必要に応じて）プラグインをインストール

---

## プラグインのインストール

`install.sh` では自動実行を無効にしているため，初回は手動で実行します．

```bash
vim +PluginInstall +qall
```

または Vim 内で：

```
:PluginInstall
```

---

## アンインストール

```bash
cd common/vim
./uninstall.sh
```

### 動作方針

* 本リポジトリが作成したシンボリックリンクのみ削除
* ユーザが独自に作成したファイルは削除しない
* 空ディレクトリのみ削除

---

## 設計方針


### 1. 「上書きしない」

既存ファイルは削除せず，バックアップまたはスキップ


### 2. 「最小限の管理」

* Vim 本体設定は `vimrc`
* 補助設定のみ `dotvim/` に配置


### 3. 「責務分離」

| 種類             | 管理場所           |
| ---------------- | ------------------ |
| インストール処理 | `install.sh`       |
| 実行時設定       | `vimrc`, `dotvim/` |

