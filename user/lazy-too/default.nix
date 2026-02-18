{
  lazy-too,
  pkgs,
  stable-pkgs,
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
            # nvim-treesitter normally copies queries from `runtime/queries`
            # to `~/.local/share/nvim/site/queries`
            # https://github.com/nvim-treesitter/nvim-treesitter/blob/4967fa48b0fe7a7f92cee546c76bb4bb61bb14d5/lua/nvim-treesitter/install.lua#L412
            (pkgs.vimPlugins.nvim-treesitter.overrideAttrs {
              fixupPhase = ''
                # `runtime` is not actually part of the runtimepath,
                # but the plugin root dir is
                mv $out/runtime/queries $out
                rm runtime -r
              '';
            })
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
            julia
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
            substituteInPlace lsp/rust_analyzer.lua \
              --subst-var cargo
          '';
        };
      };

      lsp = {
        inherit (pkgs) pyright tinymist;
        clangd = pkgs.llvmPackages_18.clang-tools;
        cssls = pkgs.vscode-langservers-extracted;
        emmet_language_server = wrapWithPath pkgs.emmet-language-server [pkgs.nodejs];
        hls =
          wrapWithPath pkgs.haskellPackages.haskell-language-server
          # hls needs itself in the PATH or else the wrapper cannot find it
          [pkgs.ghc pkgs.haskellPackages.haskell-language-server];
        html = pkgs.vscode-langservers-extracted;
        jsonls = pkgs.vscode-langservers-extracted;
        julia = pkgs.buildFHSEnv {
          name = "julia";
          targetPkgs = ps: [ps.julia-bin];
          runScript = "julia";
        };
        lua_ls = stable-pkgs.lua-language-server;
        nil_ls = pkgs.nil;
        omnisharp = pkgs.omnisharp-roslyn;
        rascal_lsp = pkgs.callPackage ../../pkgs/rascal-lsp.nix {};
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
