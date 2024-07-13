$latex = 'platex -halt-on-error -interaction=nonstopmode -file-line-error %O %S';
$bibtex = 'pbibtex -kanji=utf8 %O %S';
$makeindex = 'mendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';

$max_repeat = 5;
$pdf_mode = 3;
