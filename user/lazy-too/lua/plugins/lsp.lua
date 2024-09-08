local from_nix = require("lazy.from-nix")
return {
  {
    name = "nvim-lspconfig",
    dir = from_nix.plugins.lspconfig,
    config = function()
      local lspconfig = require("lspconfig")

      local function setup_lsp(lsp, config)
        local cmd = lspconfig[lsp].document_config.default_config.cmd
        if cmd then
          local exe = from_nix.lsp[lsp] .. "/bin/" .. cmd[1]
          cmd[1] = exe
        end

        lspconfig[lsp].setup(vim.tbl_extend("keep", config or {}, {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
      setup_lsp("emmet_ls", { cmd = { from_nix.lsp.emmet_ls .. "/bin/emmet-language-server", "--stdio" } })
      setup_lsp("html")
      setup_lsp("jsonls")
      setup_lsp("lua_ls")
      setup_lsp("nil_ls")
      setup_lsp("omnisharp", { cmd = { from_nix.lsp.omnisharp .. "/bin/OmniSharp" } })
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
