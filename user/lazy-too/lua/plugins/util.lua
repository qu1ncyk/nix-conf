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
  {
    "qu1ncyk/lf.nvim",
    config = function()
      require("lf").setup({})
      vim.api.nvim_create_autocmd("User", {
        pattern = "LfTermEnter",
        callback = function(a)
          vim.api.nvim_buf_set_keymap(a.buf, "t", "<Esc>", "<Esc>", { nowait = true })
        end,
      })
    end,
    cmd = "Lf",
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      local autopairs = require("nvim-autopairs")
      local cond = require("nvim-autopairs.conds")
      local Rule = require("nvim-autopairs.rule")

      local ignored_next_char = [=[[%w%%%'%[%"%.%`]]=]
      autopairs.setup({
        enable_moveright = false,
        ignored_next_char = ignored_next_char,
      })
      autopairs.add_rules({
        Rule("$", "$", "typst")
          :with_pair(cond.not_after_regex(ignored_next_char))
          :with_pair(cond.not_before_regex([=[[%w%%%'%"%.%`]]=]))
          :with_pair(cond.not_add_quote_inside_quote()),
      })
    end,
    event = "InsertEnter",
  },
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
  { "akinsho/toggleterm.nvim", opts = {}, cmd = "ToggleTermToggleAll" },
  { "nmac427/guess-indent.nvim", opts = {} },
  { "prichrd/netrw.nvim", opts = {}, event = "VeryLazy" },
  { "lewis6991/gitsigns.nvim", opts = {}, event = "VeryLazy" },
  {
    "zk-org/zk-nvim",
    opts = { picker = "telescope" },
    config = function(_, opts)
      vim.env.ZK_NOTEBOOK_DIR = vim.fs.normalize("~/Sync/zk")
      require("zk").setup(opts)
    end,
    ft = "markdown",
    cmd = {
      "ZkBacklinks",
      "ZkCd",
      "ZkIndex",
      "ZkInsertLink",
      "ZkInsertLinkAtSelection",
      "ZkLinks",
      "ZkMatch",
      "ZkNew",
      "ZkNewFromContentSelection",
      "ZkNewFromTitleSelection",
      "ZkNotes",
      "ZkTags",
    },
  },
}
