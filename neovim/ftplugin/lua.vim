set conceallevel=1
set fdm=indent

ColorScheme nordfox

command! -buffer REPL call ActivateREPL("lua -i " . expand("%") . " || lua -i",{
            \ "Name" : "lua_interpreter",
            \ "FileType" : "lua"
            \})
