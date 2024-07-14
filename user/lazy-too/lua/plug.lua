local from_nix = require("lazy.from-nix")
return require("lazy").setup({
  "nvim-tree/nvim-web-devicons",
  "echasnovski/mini.icons",
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },
    cmd = "NvimTreeToggle",
  },
  {
    "Mofiqul/vscode.nvim",
    opts = {
      color_overrides = {
        vscBack = "#000000",
        vscFront = "#E0E0E0",

        vscLineNumber = "#777777",

        vscYellow = "#F9DB95",
        vscPink = "#CD98C9",
        vscBlue = "#6FABDC",
        vscOrange = "#D49D87",
        vscGreen = "#1EAE50",
        vscLightGreen = "#3BDE74",
        vscRed = "#F66060",
      },
    },
    config = function(_, opts)
      local vscode = require("vscode")
      vscode.setup(opts)
      vscode.load("dark")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    name = "nvim-lspconfig",
    dir = from_nix.plugins.lspconfig,
    config = function()
      local lspconfig = require("lspconfig")

      local function setup_lsp(lsp, config)
        local cmd = lspconfig[lsp].document_config.default_config.cmd
        local exe = from_nix.lsp[lsp] .. "/bin/" .. cmd[1]
        cmd[1] = exe

        lspconfig[lsp].setup(vim.tbl_extend("keep", config or {}, {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = require("keys").set_lsp_keys,
          cmd = cmd,
        }))
      end

      setup_lsp("cssls")
      setup_lsp("clangd", {
        cmd = {
          from_nix.lsp.clangd .. "/bin/clangd",
          "--header-insertion=never",
        },
      })
      setup_lsp("emmet_ls")
      setup_lsp("html")
      setup_lsp("jsonls")
      setup_lsp("lua_ls")
      setup_lsp("nil_ls")
      setup_lsp("pyright")
      setup_lsp("rust_analyzer")
      setup_lsp("svelte")
      setup_lsp("tsserver")
      setup_lsp("typst_lsp")
      -- setup_lsp("unocss", {
      --   filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "astro" },
      -- })
    end,
  },
  { "kaarmu/typst.vim",     ft = "typst" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "Mofiqul/vscode.nvim" },
    config = function()
      local lualine = require("lualine")
      local function spaces()
        return " " .. vim.o.shiftwidth
      end
      lualine.setup({
        sections = {
          lualine_x = {
            spaces,
            "encoding",
            "fileformat",
            "filetype",
          },
        },
        options = {
          theme = "vscode",
        },
        extensions = { "nvim-tree", "toggleterm" },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
        }),
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  { "windwp/nvim-autopairs",   config = true, event = "InsertEnter" },
  {
    "nvimtools/none-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local null_ls = require("null-ls")
      local helpers = require("null-ls.helpers")

      local autopep8 = {
        name = "autopep8",
        filetypes = { "python" },
        method = { null_ls.methods.FORMATTING },
        generator = helpers.formatter_factory({
          command = from_nix.nls.autopep8,
          args = { "-" },
          to_stdin = true,
        }),
      }

      local flake8 = {
        name = "flake8",
        filetypes = { "python" },
        method = { null_ls.methods.DIAGNOSTICS },
        generator = helpers.generator_factory({
          command = from_nix.nls.flake8,
          args = { "-" },
          to_stdin = true,
          from_stderr = true,
          format = "line",
          on_output = helpers.diagnostics.from_pattern(
            ":(%d+):(%d+): ((%u)%w+) (.*)",
            { "row", "col", "code", "severity", "message" },
            {
              severities = {
                E = helpers.diagnostics.severities["error"],
                W = helpers.diagnostics.severities["warning"],
                F = helpers.diagnostics.severities["information"],
                D = helpers.diagnostics.severities["information"],
                R = helpers.diagnostics.severities["warning"],
                S = helpers.diagnostics.severities["warning"],
                I = helpers.diagnostics.severities["warning"],
                C = helpers.diagnostics.severities["warning"],
                B = helpers.diagnostics.severities["warning"],     -- flake8-bugbear
                N = helpers.diagnostics.severities["information"], -- pep8-naming
              },
            }
          ),
        }),
      }

      null_ls.setup({
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
        sources = {
          null_ls.builtins.formatting.prettier.with({
            command = from_nix.nls.prettier,
          }),
          autopep8,
          flake8,
          null_ls.builtins.formatting.stylua.with({
            command = from_nix.nls.stylua,
          }),
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "ahmedkhalf/project.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      telescope.load_extension("projects")
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    main = "project_nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "terrortylor/nvim-comment",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    cmd = "CommentToggle",
    config = function()
      require("nvim_comment").setup({
        hook = function()
          require("ts_context_commentstring.internal").update_commentstring()
        end,
      })
    end,
  },
  {
    "romgrk/barbar.nvim",
    config = true,
  },
  { "akinsho/toggleterm.nvim", config = true, cmd = "ToggleTerm" },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("keys") -- Keymaps
    end,
  },
  { "nmac427/guess-indent.nvim", config = true },
  { "prichrd/netrw.nvim",        config = true, event = "VeryLazy" },
  {
    name = "nvim-treesitter",
    dir = from_nix.plugins.treesitter,
    main = "nvim-treesitter.configs",
    opts = {
      highlight = {
        enable = true,
      },
      context_commentstring = {
        enable = true,
      },
    },
  },
  { "lewis6991/gitsigns.nvim", config = true },
  -- { 'mfussenegger/nvim-dap', config = true },
  -- { 'rcarriga/nvim-dap-ui',    dependencies = 'mfussenegger/nvim-dap' },
  -- { 'mfussenegger/nvim-dap-python', dependencies = 'mfussenegger/nvim-dap' },
})
