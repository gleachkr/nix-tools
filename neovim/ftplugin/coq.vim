au! WhichBufferVisualSettings
ColorScheme gruvbox
setlocal sw=2
setlocal iskeyword=@,48-57,_,'

let g:loaded_coqtail = 1
let g:coqtail#supported = 0

hi def CoqtailChecked ctermbg=Black guibg=NONE
hi def CoqtailSent    ctermbg=Black guibg=NONE

augroup CoqtailHighlights
  autocmd!
  autocmd ColorScheme *
    \  hi def CoqtailChecked ctermbg=Black guibg=NONE
    \| hi def CoqtailSent    ctermbg=Black guibg=NONE
augroup END
