# latex-style

個人用 LaTeX スタイルファイル集です．実体は
`tex/latex/mysty/*.sty` にあり，`install.sh` で
`~/local/texmf/tex/latex/mysty/` へシンボリックリンクします．

## Install / Uninstall

```sh
./install.sh
./uninstall.sh
```

`env.zsh` は `TEXMFHOME="${HOME}/local/texmf"` を設定し，
`install.sh` が `~/.zsh/rc.d/latex-style.zsh` へリンクします．

## Packages

| package | file | purpose |
|---|---|---|
| `mysty-common` | `tex/latex/mysty/mysty-common.sty` | 共通パッケージ読み込み，色・単位・表・文献・フォントサイズ補助 |
| `mysty-sp` | `tex/latex/mysty/mysty-sp.sty` | `mysty-common` に加えて，行間・余白・フッターを一括調整 |

## `mysty-common`

### 基本

```tex
\usepackage{mysty-common}
```

主にプリアンブルで設定します．フォントサイズ設定は
`\begin{document}` 時に適用されます．

### Preamble API

| command | example | description |
|---|---|---|
| `\MCFontSize{<size>}` | `\MCFontSize{14pt}` | `\normalsize` を基準サイズにして，標準フォントサイズ群と数式サイズを再定義します． |
| `\MCKeepSmallFontNormal` | `\MCKeepSmallFontNormal` | `\small`, `\footnotesize`, `\scriptsize`, `\tiny` を `\normalsize` 相当にします． |
| `\MCBibStyle{<style>}` | `\MCBibStyle{myjunsrt}` | `\MCBibPrint` で使う BibTeX スタイルを指定します．デフォルトは `myjunsrt` です． |
| `\MCBibFile{<bibfile>}` | `\MCBibFile{myrefs}` | `\MCBibPrint` で使う `.bib` ファイルを指定します．デフォルトは `myrefs` です． |

### Document API

| command | example | description |
|---|---|---|
| `\erase{<text>}` | `\erase{修正前}` | テキストを黒色で出力します． |
| `\red{<text>}` | `\red{重要}` | テキストを赤色で出力します． |
| `\blue{<text>}` | `\blue{メモ}` | テキストを青色で出力します． |
| `\dd` | `\int f(x)\,\dd x` | 微分記号の upright `d` です． |
| `\hquad` | `A\hquad B` | `0.5em` の水平スペースです． |
| `\tblcaption{<caption>}` | `\tblcaption{結果}` | `minipage` 内などで表キャプションを出します． |
| `\unit{<unit>}` | `10\unit{m/s}` | `siunitx` の単位を薄い空白付きで出します． |
| `\unitb{<unit>}` | `速度\unitb{m/s}` | 角括弧付きの単位を出します． |
| `\MCBibPrint` | `\MCBibPrint` | 本文中で `\cite` が使われた場合だけ文献リストを出します． |
| `\MCSubfilePostamble` | `\MCSubfilePostamble` | `\clearpage` してから `\MCBibPrint` を実行します．`subfiles` 用の後処理です． |

### 自動設定

`mysty-common` は以下の設定をまとめて行います．

| area | settings |
|---|---|
| driver | `graphics`, `xcolor` に `dvipdfmx` を指定 |
| packages | `graphicx`, `xcolor`, `amsmath`, `bm`, `siunitx`, `booktabs`, `multirow`, `here`, `enumitem`, `listings`, `jlisting`, `subcaption`, `url`, `placeins`, `pgffor`, `cite` |
| `siunitx` | 桁区切りを `,`，4 桁以上で区切り |
| `subcaption` | subfigure/subtable のラベルを `(a)`, `(b)` 形式に設定 |
| `listings` | C 言語向け，行番号付き，`jlisting` 前提の表示設定 |
| bibliography | `\cite` の使用有無を記録し，未使用時は `\MCBibPrint` で文献リストを出さない |

### Example

```tex
\documentclass{jsarticle}
\usepackage{mysty-common}

\MCFontSize{12pt}
\MCBibStyle{myjunsrt}
\MCBibFile{myrefs}

\begin{document}
速度は \(10\unit{m/s}\) である\cite{sample}．

\MCBibPrint
\end{document}
```

## `mysty-sp`

### 基本

```tex
\def\SP{1}
\usepackage{mysty-sp}
```

`mysty-sp` は `mysty-common` を読み込みます．余白・行間・フッター調整を
有効にする場合は，`\usepackage{mysty-sp}` より前に `\SP` を定義します．
`\SP` が未定義の場合，`mysty-common` 相当だけを読み込み，`mysty-sp` の
レイアウト適用は行いません．

### Preamble API

| command | default | example | description |
|---|---:|---|---|
| `\SPFontSize{<size>}` | unset | `\SPFontSize{14pt}` | SP モード用の基準フォントサイズです．SP モードでは `\MCFontSize` より優先されます． |
| `\SPKeepSmallFontNormal` | unset | `\SPKeepSmallFontNormal` | SP モードで `\small`, `\footnotesize`, `\scriptsize`, `\tiny` を `\normalsize` 相当にします． |
| `\SPGeometry{<options>}` | `top=15truemm,bottom=5truemm,left=15truemm,right=15truemm` | `\SPGeometry{top=15truemm,bottom=5truemm,left=15truemm,right=15truemm}` | `geometry` に渡す余白設定です．`includefoot` と `footskip` は自動で追加されます． |
| `\SPFooterDate{<date>}` | current date | `\SPFooterDate{2026/07/17}` | フッターの日付を指定します． |
| `\SPFooterAuthor{<author>}` | empty | `\SPFooterAuthor{Ryo}` | フッターの著者欄を指定します． |
| `\SPFooterLabel{<label>}` | empty | `\SPFooterLabel{Report}` | フッターのラベル欄を指定します． |
| `\SPFooterVersion{<ver>}` | `\SP` or `-` | `\SPFooterVersion{2}` | フッターの `ver.<ver>` を指定します． |
| `\SPFootskip{<length>}` | `10truemm` | `\SPFootskip{10truemm}` | フッターまでの距離を指定します． |
| `\SPLineStretch{<ratio>}` | `5.0` | `\SPLineStretch{5.0}` | `setspace` の `\setstretch` に渡す行間倍率です． |

### Document API

| command | example | description |
|---|---|---|
| `\SPFloatBreak[<pos>]{<env>}` | `\SPFloatBreak[htbp]{figure}` | `figure` や `table` をいったん閉じ，同じ環境を `\ContinuedFloat` 付きで再開します．`<pos>` のデフォルトは `htbp` です． |

### 自動設定

`\SP` が定義されている場合，`mysty-sp` は以下を適用します．

| area | settings |
|---|---|
| packages | `fancyhdr`, `geometry[dvipdfmx,truedimen]`, `setspace`, `caption` |
| font size | `\SPFontSize` が指定されていれば，`\MCFontSize` より優先して通常フォントと数式サイズを再設定 |
| geometry | `includefoot`, `footskip=<\SPFootskip>`, `\SPGeometry` のオプションを適用 |
| footer | 中央フッターに `date author label ver.<version> p.<page>` を表示 |
| page style | `fancy` と `plain` に同じフッター設定を適用 |
| line spacing | `\SPLineStretch` の値を `\setstretch` に適用 |

### Example

```tex
\documentclass{jsarticle}
\def\SP{1}
\usepackage{mysty-sp}

\SPFontSize{14pt}
\SPKeepSmallFontNormal
\SPGeometry{top=15truemm,bottom=5truemm,left=15truemm,right=15truemm}
\SPFooterDate{2026/07/17}
\SPFooterAuthor{Ryo}
\SPFooterLabel{draft}
\SPFooterVersion{1}
\SPFootskip{10truemm}
\SPLineStretch{5.0}

\begin{document}
\maketitle

\begin{figure}[htbp]
  \centering
  % ...
  \caption{first}
\SPFloatBreak{figure}
  % ...
  \caption{second}
\end{figure}
\end{document}
```
