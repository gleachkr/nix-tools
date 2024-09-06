{ wrapNeovimUnstable, stdenv, neovim-unwrapped, neovimUtils, vimPlugins, lib }: 
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

    neovimConfig = neovimUtils.makeNeovimConfig { };
in
  wrapNeovimUnstable neovim-unwrapped (neovimConfig // { 
    luaRcContent = '' 
    vim.loader.enable()
    vim.opt.rtp:prepend('${nvimRtp}/lua')
    '' + builtins.readFile ./init.lua + ''
    vim.opt.rtp:prepend('${nvimRtp}/nvim')
    vim.opt.rtp:prepend('${nvimRtp}/after')
    '';
    wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs 
    + " --set NVIM_APPNAME nvim-nix";
  })

# References:

# https://github.com/nix-community/kickstart-nix.nvim/blob/main/nix/mkNeovim.nix
