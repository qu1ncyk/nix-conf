local from_nix = require("lazy.from-nix")

return {
  "folke/snacks.nvim",
  dir = from_nix.plugins.snacks,
  ---@type snacks.Config
  opts = {
    image = {
      icons = {
        image = "",
      },
      doc = {
        conceal = function()
          return false
        end,
      },
    },
  },
}
