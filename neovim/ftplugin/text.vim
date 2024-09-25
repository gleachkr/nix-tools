setlocal spell
augroup textstyleset
    au!
    au BufEnter * if (&filetype != 'help' && &filetype == 'text') 
                \| ColorScheme pencil 
                \| endif
    "the autocommand only fires after modelines have been executed
    "the conditional blocks files with filetype 'help' from triggering the text
    "settings. 
augroup END
