let g:pencil#autoformat_config = {
            \ 'mail': {
            \   'black': ['mail(HeaderKey|Subject|HeaderEmail|Header)']
            \ }} 
let g:pencil#conceallevel = 2

ColorScheme pencil 
Background light
set background=light 
setlocal spell 
setlocal fdm=syntax
setlocal fo+=w
setlocal tw=72

command! Tidy call IsReply()

function! IsReply()
    if line('$') > 1
        :g/^>\s\=--\s\=$/,$ delete
        :%!par w72q
        :%s/^.\+\ze\n\(>*$\)\@!/\0 /e
        :%s/^>*\zs\s\+$//e
        :1
        :put! =\"\n\n\"
        :1
    endif
endfunction

"whitespace that will mess up format=flowed
highlight ExtraWhitespace ctermbg=red guibg=lightgreen
match ExtraWhiteSpace /^\s\s*$\|\s\(\n^\s*$\)\@=\&\s\+\%#\@<!$/

setl tw=72
setl fo=aw
