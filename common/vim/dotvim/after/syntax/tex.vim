syntax region texZoneLstlisting
            \ matchgroup=texStatement
            \ start='\\begin{lstlisting}\%(\[[^]]*\]\)\?'
            \ end='\\end{lstlisting}'
            \ keepend
            \ contains=NONE
            \ containedin=ALL
