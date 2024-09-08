if (&ft=="html")
    setlocal spell
    let g:use_emmet_complete_tag = 1
    ColorScheme sweater
    hi MatchParen ctermfg=197 ctermbg=236 guibg=#F8F1E9 guifg=#f92672 cterm=underline gui=underline

    setlocal ts=2 sw=2 autoindent "spaces for tabs

    command -buffer BrowserSync :term browser-sync start --listen 0.0.0.0 --server "%:h" --cors --index "%:t" --files "%:h/*.js" --files "%:h/*.mjs" --files "%:h/*.css" --files "%:h/*.html"

    imap <buffer>\|\| </<C-x><C-o>

    augroup HtmlCS
        au!
        au ColorScheme * hi MatchParen ctermfg=197 ctermbg=236 guibg=#F8F1E9 guifg=#f92672 cterm=underline gui=underline
        "fix matchparen for sweater
    augroup END
endif
