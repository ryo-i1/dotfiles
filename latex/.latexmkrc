$latex = 'platex -file-line-error -halt-on-error -interaction=nonstopmode -kanji=utf8 %O %S';
$max_repeat = 5;

$bibtex = 'pbibtex %O %S';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';

$makeindex = 'mendex %O -o %D %S';

$dvipdf = 'dvipdfmx %O -o %D %S';
$pdf_mode = 3;

$clean_full_ext = "%R.synctex.gz"

