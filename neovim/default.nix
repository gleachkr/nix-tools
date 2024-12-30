{ wrapNeovimUnstable, 
  stdenv, 
  gum, 
  symlinkJoin, 
  writeShellApplication, 
  neovim-unwrapped, 
  neovimUtils, 
  vimUtils, 
  vimPlugins, 
  codecompanion,
  vim-pandoc, 
  ripgrep,
  gh,
  nil,
  nodePackages,
  lua-language-server,
  yaml-language-server,
  texlab,
  lib,
}: 
let 
    nvimRtp = stdenv.mkDerivation {
      name = "nvim-rtp";
      src = ./.;

      buildPhase = ''
        mkdir -p $out/nvim
        mkdir -p $out/lua
        rm init.lua
      '';

      installPhase = ''
        if [ -d "lua" ]; then
          cp -r lua $out/lua
          rm -r lua
        fi
        if [ -d "after" ]; then
            cp -r after $out/after
            rm -r after
        fi
        if [ ! -z "$(ls -A)" ]; then
            cp -r -- * $out/nvim
        fi
      '';
    };

    codecompanion-plugin = (vimUtils.buildVimPlugin {
        pname = "vim-codecompanion";
        version = "v5.2.0";
        src = codecompanion;
      }).overrideAttrs {
        nvimSkipModule = [
          "codecompanion.actions.init"
          "codecompanion.actions.static"
          "codecompanion.providers.actions.mini_pick"
          "minimal"
        ];
        dependencies = [ 
          vimPlugins.plenary-nvim 
          vimPlugins.telescope-nvim
        ];
      };

    vim-pandoc-plugin = {
      plugin = vimUtils.buildVimPlugin {
        pname = "vim-pandoc";
        version = "v2";
        src = vim-pandoc;
      };
      config = null;
      optional = true;
    };

    nixpkgsPlugins = with vimPlugins; [
      nvim-treesitter.withAllGrammars
      luasnip
      nvim-cmp
      cmp_luasnip
      cmp-nvim-lsp
      lspkind-nvim
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-cmdline
      cmp-git
      cmp-latex-symbols
      cmp-spell
      lean-nvim
      nvim-lspconfig
      plenary-nvim
      which-key-nvim
      nvim-web-devicons
      zen-mode-nvim
      undotree
      # bg-nvim
      # guile-vim
      vimtex
      solarized-nvim
      # vim-lucius
      vim-hybrid
      Recover-vim
      mediawiki-vim
      vim-colorschemes
      # colour-schemes
      # matchit
      # anderson-vim
      zenburn
      gv-vim
      limelight-vim
      rainbow_parentheses-vim
      seoul256-vim
      vim-easy-align
      vim-sneak
      vim-sexp
      vim-sexp-mappings-for-regular-people
      vim-pug
      # sweater
      vim-javascript
      # vim-colors-pencil
      vim-commentary
      vim-fugitive
      vim-repeat
      vim-unimpaired
      vim-rhubarb
      # vim-interestingwords
      vim-racket
      colorizer
      # vim-syntax-shakespeare
      oceanic-next
      nightfox-nvim
      vim-jsx-pretty
      vim-nix
      Coqtail
      nvim-unception
      vim-loves-dafny
      fidget-nvim
      nvim-lightbulb
      neodev-nvim
      # coq-lsp-nvim
      friendly-snippets
      vim-obsession
      octo-nvim
      oil-nvim
      vim-pandoc-syntax
      quarto-nvim
      otter-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
    ];

    plugins = nixpkgsPlugins ++ [
      vim-pandoc-plugin
      codecompanion-plugin
    ];

    externalPackages = [
      ripgrep
      gh
      nil
      lua-language-server
      texlab
      yaml-language-server
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.vim-language-server
      # could add more - basically want anything that's not likely to depend on
      # the project.
    ];

    neovimConfig = neovimUtils.makeNeovimConfig { 
      inherit plugins;
      withPython3 = true;
      withNodeJs = true;
    };

    neovim = wrapNeovimUnstable neovim-unwrapped (neovimConfig // { 
      luaRcContent = '' 
      vim.loader.enable()
      vim.opt.rtp:prepend('${nvimRtp}/lua')
      '' + builtins.readFile ./init.lua + ''
      vim.opt.rtp:prepend('${nvimRtp}/nvim')
      vim.opt.rtp:prepend('${nvimRtp}/after')
      '';
      wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs 
      + " --set NVIM_APPNAME nvim-nix"
      + " --prefix PATH : '${lib.makeBinPath externalPackages}'";
    });

    neovimSession = writeShellApplication {
      name = "sesh";
      runtimeInputs = [
        neovim
        gum
      ];
      text = ''
        shopt -s nullglob #makes SESSIONS empty if there aren't any sessions

        SESSIONS=(~/.cache/nvim-nix/*.pipe)
        CMD="$(gum choose NEW-SESSION "''${SESSIONS[@]}")"

        if [ "$CMD" == NEW-SESSION ]; then
            SESSION_PATH="$HOME/.cache/nvim-nix/$(gum input --placeholder "session name?").pipe"
            if [ -f "$SESSION_PATH" ]; then echo "hold your horses!"; exit; fi
            nohup nvim --headless --listen "$SESSION_PATH" > /dev/null &
            sleep 1 #kludge to allow nvim time to start up
            nvim --server "$SESSION_PATH" --remote-ui
        else
            nvim --server "$CMD" --remote-ui
        fi
      '';
    };

in symlinkJoin {
  name = "nvim"; #so standard nvim is what you get with `nix run`
  paths = [ neovim neovimSession ];
}

# References:

# https://github.com/xnix-community/kickstart-nix.nvim/blob/main/nix/mkNeovim.nix
