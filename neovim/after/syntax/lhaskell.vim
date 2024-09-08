syn include @PANDOC ~/.config/nvim/plugged/vim-pandoc-syntax/syntax/pandoc.vim
syn region pandocInMail start="^>\@!" end="$" contains=@PANDOC
