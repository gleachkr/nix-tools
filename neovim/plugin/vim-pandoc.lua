vim.g["pandoc#formatting#mode"] = "hA"
vim.g["pandoc#syntax#codeblocks#embeds#langs"] = {'haskell', 'hs=haskell', 'diagram=haskell', 'tex', 'latex=tex'}
vim.g["pandoc#keyboard#enabled_submodules"] = {"lists", "references", "sections", "links"}
vim.g["pandoc#after#modules#enabled"] =  {"nrrwrgn", "ultisnips"}
vim.g["pandoc#command#custom_open"] =  "MyPandocOpen"
vim.g["pandoc#modules#disabled"] =  {"chdir"}
vim.b["pandoc_autoformat_enabled"] =  1

vim.cmd.packadd("vim-pandoc")
