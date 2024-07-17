local from_nix = require("lazy.from-nix")
return {
  {
    name = "nvim-treesitter",
    dir = from_nix.plugins.treesitter,
    main = "nvim-treesitter.configs",
    opts = {
      highlight = {
        enable = true,
      },
    },
  },
  { "kaarmu/typst.vim", ft = "typst" },
  -- { 'mfussenegger/nvim-dap', opts = {} },
  -- { 'rcarriga/nvim-dap-ui',    dependencies = 'mfussenegger/nvim-dap' },
  -- { 'mfussenegger/nvim-dap-python', dependencies = 'mfussenegger/nvim-dap' },
}
