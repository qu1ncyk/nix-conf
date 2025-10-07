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
        enabled = false,
      },
    },
  },
  config = function(plugin, opts)
    local snacks = require("snacks")
    snacks.setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        snacks.image.doc.attach(args.buf)
      end,
    })
  end,
}
