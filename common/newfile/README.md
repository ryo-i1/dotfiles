# newfile

テンプレートからファイルまたはディレクトリを作成する
コマンドです．


## Install / Uninstall

```bash
./install.sh
./uninstall.sh
```


---
## Paths

| src         | dst                                  | note             |
| ---         | ---                                  | ---              |
| `bin/newfile` | `~/local/bin/newfile`              | 実行ファイル     |
| `templates`   | `~/local/share/newfile/templates`  | テンプレート集   |


---
## Usage

```bash
newfile tex report   # report/Makefile と report/report.tex を作成
newfile latex report # tex と同じ
```

テンプレート内では，次の placeholder を使えます．

| placeholder | value                    |
| ---         | ---                      |
| `@FILENAME@` | 拡張子なしのファイル名 |
| `@DATE@`     | 作成日                 |
