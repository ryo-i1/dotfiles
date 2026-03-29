" ~/.vim/ftdetect/zsh.vim

au BufRead,BufNewFile *.sh if getline(1) =~# '^#!.*/zsh' | setfiletype zsh | endif
