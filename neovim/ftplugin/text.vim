call pencil#init({'wrap':'soft'})
setlocal spell
let g:pencil#autoformat = 0
let g:pencil#conceallevel = 2
augroup textstyleset
    au!
    au BufEnter * if (&filetype != 'help' && &filetype == 'text') 
                \| ColorScheme pencil 
                \| set guifont=Cousine:h14 
                \| set background=light 
                \| set spell 
                \| endif
    "the autocommand only fires after modelines have been executed
    "the conditional blocks files with filetype 'help' from triggering the text
    "settings. 
augroup END
