ColorScheme pencil
Background light
"within a table or codeblock. that'd be a nice feature...
"setlocal fo+=l
""this is supposed to keep long lines from being autoformatted, but I think it is not working for some reason.
"setlocal fo+=t

setlocal background=light
setlocal spell
"setlocal autoindent "preserves indentation to help with the appearance of lists and similar things
"setlocal tw=78
setlocal so=10 "keep at least ten lines visible above and below the cursor.
setlocal lsp=5 "five pixels linespace for readability
set guifont=Cousine:h14

" Don't automatically grab markdown files
" Add support for markdown files in tagbar.
let g:tagbar_type_pandoc = {
    \ 'ctagstype': 'pandoc',
    \ 'ctagsbin' : '~/.config/nvim/helpers/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

let g:pandoc#formatting#mode="hA" "lets try autoformatting again
let g:pandoc#syntax#codeblocks#embeds#langs=['haskell', 'hs=haskell', 'diagram=haskell', 'tex', 'latex=tex']
let g:pandoc#keyboard#enabled_submodules=["lists", "references", "sections", "links"]
let g:pandoc#after#modules#enabled = ["nrrwrgn", "ultisnips"]
let g:pandoc#command#custom_open = "MyPandocOpen"
let g:pandoc#modules#disabled = ["chdir"]
let b:pandoc_autoformat_enabled = 1
hi clear Conceal
hi link Conceal Character

setlocal statusline=%<%f\ %h%m%r%=%-14.(fmt:%{b:pandoc_autoformat_enabled}%)\ 
nmap <buffer> <leader>f :call pandoc#formatting#ToggleAutoformat()<cr>

function! Render()
    let l:bufnr = bufnr("%")
    botright 10 new
    call termopen("while true; do nvr --remote-expr 'join(getbufline(" . l:bufnr . ",1,\"$\"),\"\n\")' | pandoc -s --css='https://cdn.jsdelivr.net/gh/kognise/water.css/dist/light.css' | (echo 'HTTP/1.1 200 OK'; echo; cat) | nc -Nlp 1500; done")
    call jobstart("firefox localhost:1500")
endfunction

function! WatchLatex()
    augroup WATCHLATEX
        au BufWritePost <buffer> Pandoc pdf --listings
    augroup END
    call jobstart(["sioyek", expand("%:r") . ".pdf"])
endfunction

command! -buffer Render call Render()
