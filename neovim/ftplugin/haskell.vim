" vim:fdm=marker
"General Settings {{{

setlocal suffixesadd=hs,lhs,hsc

ColorScheme lucius
hi clear Conceal
hi link Conceal Operator
"}}}
"{{{Autocommands

augroup ControlFolds
" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
    au!
    autocmd InsertEnter *.hs if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
    autocmd InsertLeave,WinLeave *.hs if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
augroup END
"}}}
