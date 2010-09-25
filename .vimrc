" pathgen
silent! call pathogen#runtime_append_all_bundles()

:set number
:set nocompatible

" snipmate
filetype on
filetype plugin on
filetype indent on

set laststatus=2 

" Indent
set autoindent
set tabstop=3 "set tab character to 3 characters"
set shiftwidth=3 "indent width for autoindent"
set smartindent
syntax on

set textwidth=79
set formatoptions=qrn1
if version >= 703
	set colorcolumn=80
endif

" folding
set foldmethod=indent

" Sidebar folder navigation
let NERDTreeShowLineNumbers=1
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeWinSize=41

" incremental search
set incsearch
set ignorecase
set smartcase

set list
set listchars=tab:>\ 
colorscheme ir_black

" font
if has("gui_gnome")
	set guifont=Monospace:9
	colorscheme sri2
	set list
	set listchars=tab:▸\ ,eol:¬
elseif has("gui_macvim")
	set guifont=Menlo\ bold:h12
	colorscheme sri2
	set list
	set listchars=tab:▸\ ,eol:¬
endif


" line tracking
set numberwidth=5 
set cursorline
set cursorcolumn

"" shortcuts
inoremap jj <Esc>

nnoremap ; :

let mapleader = ","
nnoremap <Leader>a :Ack 
map <Leader>, :NERDTreeToggle<cr>
map <Leader>t :tabnew<cr>
map <Leader>h :tabprevious<cr>
map <Leader>l :tabnext<cr>
map <Leader>w :tabclose<cr>
map <Leader>pd :!perldoc %<cr>
map <Leader>cs :colorscheme 
map <Leader>f :TlistToggle<cr>
map <Leader>M :!perl % daemon --reload<cr>
map <Leader>x :!perl %<cr>
map <leader><space> :CommandT<cr>
" cd to directory of current file
map <leader>cd :cd %:p:h<cr>
map <leader>F :NERDTreeFind<cr>
map <leader>R :source ~/.vimrc<cr>

" autocompletion
imap <Leader><Tab> <C-X><C-O>

" perldoc for module || perl command
noremap K :!perldoc <cword> <bar><bar> perldoc -f <cword><cr>
" Opens nerdtree and puts focus in edited file
autocmd VimEnter * exe 'NERDTree' | wincmd l | exe 'NERDTreeToggle'


" ,T perl tests
function! Prove ( verbose, taint )
    if ! exists("g:testfile")
        let g:testfile = "t/*.t"
    endif
    if g:testfile == "t/*.t" || g:testfile =~ "\.t$"
        let s:params = "lr"
        if a:verbose
            let s:params = s:params . "v"
        endif
"        if a:taint
"            let s:params = s:params . "t"
"        endif
        execute "!HARNESS_PERL_SWITCHES=-MDevel::Cover prove -" . s:params . " " . g:testfile
    else
       call Compile ()
    endif
endfunction

function! Compile ()
    if ! exists("g:compilefile")
        let g:compilefile = expand("%")
    endif
    execute "!perl -wc -Ilib " . g:compilefile
endfunction

nmap <Leader>te :let g:testfile = expand("%")<cr>:echo "testfile is now" g:testfile<cr>:call Prove (1,1)<cr>
au BufRead,BufNewFile *.t,*.cgi set filetype=perl
au BufRead,BufNewFile *.conf set filetype=apache

" perltidy
autocmd BufRead,BufNewFile *.t,*.pl,*.plx,*.pm nmap <Leader>te :let g:testfile = expand("%")<cr>:echo "testfile is now" g:testfile<cr>:call Prove (1,1)<cr>
autocmd BufRead,BufNewFile *.t,*.pl,*.plx,*.pm command! -range=% -nargs=* Tidy <line1>,<line2>!perltidy -q
autocmd BufRead,BufNewFile *.t,*.pl,*.plx,*.pm noremap <Leader>pt :Tidy<CR>

" save/retrieve folds automatically
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
