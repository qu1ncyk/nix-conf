return {
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
  { "windwp/nvim-autopairs",   opts = {}, event = "InsertEnter" },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "ahmedkhalf/project.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      telescope.load_extension("projects")
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "InsertEnter",
    opts = {
      enable_autocmd = false,
    },
  },
  { "akinsho/toggleterm.nvim", opts = {}, cmd = "ToggleTerm" },
  {
    "ahmedkhalf/project.nvim",
    main = "project_nvim",
    opts = {},
    event = "VeryLazy",
  },
  { "nmac427/guess-indent.nvim", opts = {} },
  { "prichrd/netrw.nvim",        opts = {}, event = "VeryLazy" },
  { "lewis6991/gitsigns.nvim",   opts = {}, cmd = "Gitsigns" },
  {
    "zk-org/zk-nvim",
    opts = { picker = "telescope" },
    config = function (_, opts)
      vim.env.ZK_NOTEBOOK_DIR = vim.fs.normalize("~/Sync/zk")
      require("zk").setup(opts)
    end,
    event = "VeryLazy",
  },
}
