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
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      checkbox = {
        checked = { icon = " " },
      },
      bullet = {
        icons = { "", "", "◆", "◇" },
      },
    },
  },
}
