local from_nix = require("lazy.from-nix")
return {
  {
    name = "nvim-lspconfig",
    dir = from_nix.plugins.lspconfig,
    config = function()
      ---@param lsp string
      ---@param config vim.lsp.Config?
      local function setup_lsp(lsp, config)
        local cmd = vim.lsp.config[lsp].cmd
        if cmd and from_nix.lsp[lsp] then
          local exe = from_nix.lsp[lsp] .. "/bin/" .. cmd[1]
          cmd[1] = exe
        end

        vim.lsp.config(
          lsp,
          vim.tbl_extend("keep", config or {}, {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            cmd = cmd,
          })
        )
        vim.lsp.enable(lsp)
      end

      setup_lsp("cssls")
      setup_lsp("clangd", {
        cmd = {
          from_nix.lsp.clangd .. "/bin/clangd",
          "--header-insertion=never",
        },
      })
      setup_lsp("emmet_language_server")
      setup_lsp("hls")
      setup_lsp("html")
      setup_lsp("jsonls")
      -- Unfortunally, you need to install julials manually:
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#julials
      setup_lsp("julials", {
        cmd = vim.tbl_extend("keep", {
          from_nix.lsp.julia .. "/bin/julia",
        }, vim.lsp.config.julials.cmd),
      })
      setup_lsp("lua_ls")
      setup_lsp("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = {
              command = { from_nix.nls.alejandra },
            },
          },
        },
      })
      setup_lsp("omnisharp", { cmd = { from_nix.lsp.omnisharp .. "/bin/OmniSharp" } })
      setup_lsp("pyright")
      setup_lsp("rascal_lsp")
      setup_lsp("rust_analyzer")
      setup_lsp("svelte")
      setup_lsp("ts_ls")
      -- https://github.com/Myriad-Dreamin/tinymist/issues/638#issuecomment-2395941103
      setup_lsp("tinymist", { single_file_support = true, offset_encoding = "utf-8" })
      -- setup_lsp("unocss", {
      --   filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "astro" },
      -- })
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
}
