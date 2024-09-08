if has('autocmd')
	" change colorscheme depending on current buffer
	" if desired, you may set a user-default colorscheme before this point,
	" otherwise we'll use the Vim default.
	" Variables used:
		" g:colors_name : current colorscheme at any moment (Vim Built-in)
		" b:colors_name (if any): colorscheme to be used for the current buffer
        " b:light: true if current buffer should have a light bg
		" s:colors_name : default colorscheme, to be used where b:colors_name hasn't been set
	if has('user_commands')
		" User commands defined:
			" ColorScheme <name>
				" set the colorscheme for the current buffer
			" ColorDefault <name>
				" change the default colorscheme
            " BackgroundLight
                " make the buffer have a light background
		command! -nargs=1 -bar ColorScheme
            \ if (&ft !~ '|TelescopePrompt\|octo\|undotree\|tagbar\|qf\|vim\-plug\|^$\|peekaboo')
			\ | colorscheme <args>
			\ | let b:colors_name = g:colors_name
            \ | endif
		command! -nargs=1 -bar Background
            \ set background=<args>
			\ | let b:background_bright = &bg
		command! -nargs=1 -bar ColorDefault
			\ let s:colors_name = <q-args>
			\ | if !exists('b:colors_name')
				\ | colors <args>
			\ | endif
	endif
	if !exists('g:colors_name')
		let g:colors_name = 'default'
	endif
	let s:colors_name = g:colors_name

    augroup WhichBufferVisualSettings
    au!
	au BufEnter *
        \ if (exists('b:background_bright') && &bg != b:background_bright && &ft !~ '|TelescopePrompt\|octo\|undotree\|tagbar\|qf\|vim\-plug\|^$\|peekaboo')
            \ | exe 'set background=' . b:background_bright 
            \ | hi clear conceal
        \ | endif
    au BufEnter *
		\ let s:new_colors = (exists('b:colors_name')?(b:colors_name):(s:colors_name))
        \ | if (!exists('g:colors_name') || s:new_colors != g:colors_name && &ft !~ '|TelescopePrompt\|octo\|undotree\|tagbar\|qf\|vim\-plug\|^$\|peekaboo')
            \ | exe 'colors' s:new_colors
            \ | do ColorScheme s:new_colors
            \ | hi clear conceal
            "fires the appropriate colorscheme event.
        \ | endif
endif
