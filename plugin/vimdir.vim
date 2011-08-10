" Use our user unless we have a sudo user, then is it
let luser = substitute(system('whoami'), '\n', '', '')
if strlen($SUDO_USER)
    let luser = $SUDO_USER
endif
let $VIMHOME=expand('<sfile>:p:h:h')
let $VIM_USER_RC = $VIMHOME . "/vimrc.". luser
execute "silent! source " . $VIM_USER_RC
