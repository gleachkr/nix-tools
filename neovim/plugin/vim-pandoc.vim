let g:pandoc#formatting#mode="hA" "lets try autoformatting again
let g:pandoc#syntax#codeblocks#embeds#langs=['haskell', 'hs=haskell', 'diagram=haskell', 'tex', 'latex=tex']
let g:pandoc#keyboard#enabled_submodules=["lists", "references", "sections", "links"]
let g:pandoc#after#modules#enabled = ["nrrwrgn", "ultisnips"]
let g:pandoc#command#custom_open = "MyPandocOpen"
let g:pandoc#modules#disabled = ["chdir"]
let b:pandoc_autoformat_enabled = 1

packadd vim-pandoc
