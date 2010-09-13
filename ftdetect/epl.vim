au! BufRead,BufNewFile *.epl set filetype=epl
au! BufRead,BufNewFile *.ep set filetype=epl
au! BufRead,BufNewFile *
\ if exists("b:current_syntax") |
\ syn include @perlDATA syntax/data_epl.vim |
\ endif
