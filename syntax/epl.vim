syn clear

if !exists("main_syntax")
    let main_syntax = 'epl'
endif

runtime! syntax/html.vim
syn cluster htmlPreproc add=MojoPerlCode

syn include @Perl syntax/perl.vim

syn match MojoStart "<%=*" contained
syn match MojoEnd "=*%>" contained
syn match MojoStart "^\s*%=*" contained

syn cluster Mojo contains=MojoStart,MojoEnd

syn region MojoPerlCode start="<%=*" end="=*%>" contains=@Perl,@Mojo oneline contained keepend
syn region MojoPerlCode start="^\s*%=*" end="$" contains=@Perl,@Mojo oneline contained keepend

hi link MojoStart perlType
hi link MojoEnd perlType
