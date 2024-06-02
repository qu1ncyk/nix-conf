{
  pkgs,
  nixvim,
  ...
}: {
  home.file.".config/nvim/lua".source = ./lua;
  imports = [nixvim.homeManagerModules.nixvim];
  programs.nixvim = {
    enable = true;
    extraConfigLua = builtins.readFile ./init.lua;
    extraPackages = with pkgs; [
      python311Packages.autopep8
      python311Packages.flake8
      # Needed for rust-analyzer
      gcc
    ];
    plugins = {
      barbar.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
      nvim-autopairs.enable = true;
      nvim-tree.enable = true;
      project-nvim.enable = true;
      telescope.enable = true;
      toggleterm.enable = true;
      ts-context-commentstring.enable = true;
      typst-vim.enable = true;
      which-key.enable = true;

      cmp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      luasnip.enable = true;

      lsp = {
        enable = true;
        capabilities = "capabilities = require('cmp_nvim_lsp').default_capabilities()";
        onAttach = "require('keys').set_lsp_keys(client, bufnr)";
        preConfig = "require('neodev').setup {}";
        servers = {
          clangd.enable = true;
          emmet_ls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          # marksman.enable = true;
          nil_ls = {
            enable = true;
            extraOptions.nix.flake.autoArchive = true;
          };
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          svelte.enable = true;
          tsserver.enable = true;
          typst-lsp.enable = true;
        };
      };

      none-ls = {
        enable = true;
        sources = {
          formatting = {
            alejandra.enable = true;
            # clang_format.enable = true;
            stylua.enable = true;
          };
        };
      };

      treesitter = {
        enable = true;
        ensureInstalled = [
          "bash"
          "c"
          "cpp"
          "css"
          "html"
          "javascript"
          "json"
          "lua"
          "markdown"
          "nix"
          "python"
          "rust"
          "svelte"
          "toml"
          "typescript"
          "typst"
        ];
      };
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vscode";
        src = pkgs.fetchFromGitHub {
          owner = "Mofiqul";
          repo = "vscode.nvim";
          rev = "2f248dceb66b5706b98ee86370eb7673862a3903";
          hash = "sha256-W9Kpq6/rypWDMqrS+ETWkButgU8WrJD4nAj5ehZUwQg=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "guess-indent";
        src = pkgs.fetchFromGitHub {
          owner = "nmac427";
          repo = "guess-indent.nvim";
          rev = "b8ae749fce17aa4c267eec80a6984130b94f80b2";
          hash = "sha256-fqQfyUaQBcVZ7bcFeWbLyse9spw97Dqt/B4JGPnaYcQ=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim_comment";
        src = pkgs.fetchFromGitHub {
          owner = "terrortylor";
          repo = "nvim-comment";
          rev = "e9ac16ab056695cad6461173693069ec070d2b23";
          hash = "sha256-O2jhrjXxKaWHMfm3YJ9+92Onm0niEHfUp5kOh2gETuc=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "neodev";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "neodev.nvim";
          rev = "84e0290f5600e8b89c0dfcafc864f45496a53400";
          hash = "sha256-VyJTGbWBzGmuEkotKwTxAVpznfrrQ26aaBc31n6ZjlE=";
        };
      })
    ];
  };
}
