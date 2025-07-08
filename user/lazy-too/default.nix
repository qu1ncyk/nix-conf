{
  lazy-too,
  pkgs,
}: let
  wrapWithPath = pkg: pathPkgs:
    pkgs.runCommand "wrap-with-path" {
      nativeBuildInputs = [pkgs.makeWrapper];
    } ''
      cd ${pkg}
      mkdir -p $out/bin
      for bin in bin/*; do
        makeWrapper ${pkg}/$bin $out/$bin \
          --suffix PATH : ${pkgs.lib.makeBinPath pathPkgs}
      done
    '';
  neovim = lazy-too.buildNeovim {
    neovim = pkgs.neovim-unwrapped;
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
            elsa
            glsl
            haskell
            html
            javascript
            json
            latex
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
        snacks = pkgs.vimPlugins.snacks-nvim.overrideAttrs {
          inherit (pkgs) typst tectonic;
          imagemagick = pkgs.imagemagick.override {ghostscriptSupport = true;};
          patches = [./snacks.patch];
          postPatch = ''
            substituteInPlace lua/snacks/image/convert.lua \
              --subst-var typst \
              --subst-var tectonic \
              --subst-var imagemagick
          '';
        };
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
        emmet_language_server = wrapWithPath pkgs.emmet-language-server [pkgs.nodejs];
        hls =
          wrapWithPath pkgs.haskellPackages.haskell-language-server
          # hls needs itself in the PATH or else the wrapper cannot find it
          [pkgs.ghc pkgs.haskellPackages.haskell-language-server];
        html = pkgs.vscode-langservers-extracted;
        jsonls = pkgs.vscode-langservers-extracted;
        lua_ls = pkgs.lua-language-server;
        nil_ls = pkgs.nil;
        omnisharp = pkgs.omnisharp-roslyn;
        rust_analyzer = wrapWithPath pkgs.rust-analyzer [pkgs.rustc pkgs.cargo];
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
      dap = {
        inherit (pkgs) gdb;
        python = pkgs.vimPlugins.nvim-dap-python;
        python_debugpy = pkgs.python3.withPackages (ps: [ps.debugpy]);
      };
    };
  };
in {
  inherit neovim;
  inherit (neovim) lock;
}
