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
    "MeanderingProgrammer/markdown.nvim",
    ft = "markdown",
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
