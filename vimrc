" pathogen
silent! call pathogen#runtime_append_all_bundles()

set number
set nocompatible

set wildignore+=*CVS

" snipmate
filetype on
filetype plugin on
filetype indent on

set laststatus=2 

" backspaces over everything in insert mode
set backspace=indent,eol,start

" Indent
set autoindent
set tabstop=3 "set tab character to 3 characters"
set shiftwidth=3 "indent width for autoindent"
set smarttab " insert tabs on start of line according to shiftwidth, not tabstop
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
let NERDTreeIgnore=['CVS']


set incsearch
set ignorecase
set smartcase
set visualbell
set noerrorbells
set hlsearch

" clear recent search highlighting with space
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


" save files as root without prior sudo
cmap w!! w !sudo tee % >/dev/null

set nobackup
set noswapfile

set list
set listchars=tab:.\ ,trail:.,extends:#,nbsp:.

" font
if has("gui_gnome")
	set guifont=Monospace\ 8
	colorscheme sri2
	set list
	set listchars=tab:▸\ ,eol:¬,extends:#,nbsp:.,trail:.
	" hide toolbar

elseif has("gui_macvim")
	set guifont=Menlo\ bold:h11
	"set guifont=Menlo:h12
	colorscheme sri2
	set list
	set listchars=tab:▸\ ,eol:¬,extends:#,nbsp:.,trail:.
	" hide toolbar
endif

if &t_Co >= 256 || has("gui_running")
	set guioptions-=r
	set go-=L
	set go-=T
else
	colorscheme ir_black
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
map <Leader>cs :colorscheme sri2<cr>
map <Leader>f :TlistToggle<cr>
map <Leader>M :!perl % daemon --reload<cr>
map <Leader>x :!perl -Ilib %<cr>
map <leader><space> :CommandT<cr>
" cd to directory of current file
map <leader>cd :cd %:p:h<cr>
map <leader>F :NERDTreeFind<cr>
map <leader>R :source ~/.vimrc<cr>

map <leader>pull :silent !sandbox pull %<cr>
map <leader>push :silent !sandbox push %<cr>
map <leader>same :!sandbox same %<cr>
map <leader>rt :!sandbox rtest %<cr>
map <leader>diff :!sandbox diff %<cr>
nnoremap <F5> :GundoToggle<cr>

" autocompletion
imap <Leader><Tab> <C-X><C-O>

" perldoc for module || perl command
noremap K :!perldoc <cword> <bar><bar> perldoc -f <cword><cr>
" Opens nerdtree and puts focus in edited file
autocmd VimEnter * exe 'NERDTree' | wincmd l | exe 'NERDTreeToggle'

" file types
au BufRead,BufNewFile *.t,*.cgi set filetype=perl
au BufRead,BufNewFile *.conf set filetype=apache

" save/retrieve folds automatically
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" ,T perl tests
"nmap <Leader>T :let g:testfile = expand("%")<cr>:echo "testfile is now" g:testfile<cr>:call Prove (1,1)<cr>
function! Prove ( verbose, taint )
    if ! exists("g:testfile")
        let g:testfile = "t/*.t"
    endif
    if g:testfile == "t/*.t" || g:testfile =~ "\.t$"
        let s:params = "lrc"
        if a:verbose
            let s:params = s:params . "v"
        endif
"        if a:taint
"            let s:params = s:params . "t"
"        endif
        "execute !HARNESS_PERL_SWITCHES=-MDevel::Cover prove -" . s:params . " " . g:testfile
        execute "!prove --timer --normalize --state=save -" . s:params . " " . g:testfile
		  "TEST_VERBOSE=1 prove -lvc --timer --normalize --state=save
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

" perltidy
autocmd BufRead,BufNewFile *.t,*.pl,*.plx,*.pm nmap <Leader>te :let g:testfile = expand("%")<cr>:echo "testfile is now" g:testfile<cr>:call Prove (1,1)<cr>
autocmd BufRead,BufNewFile *.t,*.pl,*.plx,*.pm command! -range=% -nargs=* Tidy <line1>,<line2>!perltidy -q
autocmd BufRead,BufNewFile *.t,*.pl,*.plx,*.pm noremap <Leader>pt :Tidy<CR>

" python does not like tabs
autocmd filetype python set expandtab

" perl omnicompletion
autocmd FileType perl set omnifunc=perlcomplete#Complete

" xmlfolding
au BufNewFile,BufRead *.xml,*.htm,*.html so bundle/plugin/XMLFolding.vim

autocmd FileType perl syn include @perlDATA bundle/mojo/syntax/MojoliciousTemplate.vim

let g:ackprg="ack-grep -H --nocolor --nogroup --column"

au! Syntax newlang source $VIM/syntax/nt.vim
