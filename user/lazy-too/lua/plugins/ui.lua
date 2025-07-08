return {
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
    "nvim-lualine/lualine.nvim",
    dependencies = { "Mofiqul/vscode.nvim" },
    config = function()
      local lualine = require("lualine")
      local function spaces()
        return "󰌒 " .. vim.o.shiftwidth
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
    "romgrk/barbar.nvim",
    opts = {},
  },
}
