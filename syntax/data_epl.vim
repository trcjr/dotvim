if !exists("b:current_syntax")
    finish
endif

let cs = b:current_syntax
runtime! syntax/html.vim
unlet b:current_syntax

syn include @Perl syntax/perl.vim
unlet b:current_syntax

syn include @Html syntax/html.vim
syn cluster htmlPreproc add=MojoPerlCode

syn match MojoStart "<%=*" contained
syn match MojoStart "^\s*%=*" contained
syn match MojoEnd "=*%>" contained

syn match MojoFileNameStart "@@" contained
syn cluster Mojo contains=MojoStart,MojoEnd

syn region MojoFileContainer start=/@@/ end=/@@/me=s-1 contains=MojoPerlCode,@Html,MojoFileName keepend fold
syn region MojoFileName start=/@@/ end="$" keepend contains=MojoFileNameStart contained keepend
syn region MojoPerlCode start="<%=*" end="=*%>" contains=@Perl,@Mojo oneline contained keepend
syn region MojoPerlCode start="^\s*%=*" end="$" contains=@Perl,@Mojo oneline contained keepend

hi link MojoStart perlType
hi link MojoEnd perlType
hi link MojoFileName perlString
hi link MojoFileNameStart perlSpecial

let b:current_syntax = cs
