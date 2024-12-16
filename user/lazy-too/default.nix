{
  lazy-too,
  pkgs,
}: let
  neovim = lazy-too.buildNeovim {
    configRoot = ./.;
    # Tell Dream2Nix that this is the root dir
    # https://nix-community.github.io/dream2nix/reference/builtins-derivation/#paths
    paths = {
      projectRoot = ./.;
      projectRootFile = "default.nix";
      package = ./.;
    };
    passedToLua = {
      plugins = {
        treesitter = pkgs.symlinkJoin {
          name = "Treesitter and parsers";
          paths = with pkgs.vimPlugins.nvim-treesitter-parsers; [
            pkgs.vimPlugins.nvim-treesitter
            bash
            c
            cpp
            c_sharp
            css
            glsl
            html
            javascript
            json
            lua
            markdown
            matlab
            nix
            python
            rust
            scheme
            svelte
            toml
            typescript
            typst
            vimdoc
          ];
        };
        dap_python = pkgs.python3.withPackages (ps: [ps.debugpy]);
        image = pkgs.vimPlugins.image-nvim;
        magick = pkgs.luajitPackages.magick;
        mathjax = pkgs.mathjax-node-cli;
        lspconfig = pkgs.vimPlugins.nvim-lspconfig.overrideAttrs {
          inherit (pkgs) cargo;
          patches = [./lspconfig.patch];
          postPatch = ''
            substituteInPlace lua/lspconfig/configs/rust_analyzer.lua \
              --subst-var cargo
          '';
        };
      };

      lsp = {
        inherit (pkgs) pyright tinymist;
        clangd = pkgs.clang-tools_18;
        cssls = pkgs.vscode-langservers-extracted;
        emmet_ls = pkgs.emmet-language-server;
        html = pkgs.vscode-langservers-extracted;
        jsonls = pkgs.vscode-langservers-extracted;
        lua_ls = pkgs.lua-language-server;
        nil_ls = pkgs.nil;
        omnisharp = pkgs.omnisharp-roslyn;
        rust_analyzer = pkgs.writeScriptBin "rust-analyzer" ''
          PATH=$PATH:${pkgs.cargo}/bin:${pkgs.rustc}/bin
          ${pkgs.rust-analyzer}/bin/rust-analyzer
        '';
        svelte = pkgs.nodePackages.svelte-language-server;
        ts_ls = pkgs.nodePackages.typescript-language-server;
        # unocss = pkgs.unocss;
      };
      nls = {
        alejandra = pkgs.alejandra + "/bin/alejandra";
        autopep8 = pkgs.python312Packages.autopep8 + "/bin/autopep8";
        flake8 = pkgs.python312Packages.flake8 + "/bin/flake8";
        prettier = pkgs.nodePackages.prettier + "/bin/prettier";
        stylua = pkgs.stylua + "/bin/stylua";
      };
    };
  };
in {
  inherit neovim;
  inherit (neovim) lock;
}
