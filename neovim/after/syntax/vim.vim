if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
  " do nothing if b:current_syntax is defined.
  unlet b:current_syntax
endif
syn include @LUA syntax/lua.vim
syn region luaInVim start="lua >> LUA" end="LUA" contains=@LUA
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
else
  unlet b:current_syntax
endif
