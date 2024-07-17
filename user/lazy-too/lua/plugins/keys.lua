return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup(opts)
    end,
    opts = {
      spec = {
        {
          { "<leader>/",  "gcc",                       desc = "Comment toggle",       noremap = false },
          { "<leader>b",  ":Telescope buffers<CR>",    desc = "Telescope buffers" },
          { "<leader>d",  group = "Diagnostics..." },
          { "<leader>dd", vim.diagnostic.open_float,   desc = "Diagnostics" },
          { "<leader>dj", vim.diagnostic.goto_prev,    desc = "Next diagnostic" },
          { "<leader>dk", vim.diagnostic.goto_next,    desc = "Previous diagnostic" },
          { "<leader>f",  ":Telescope find_files<CR>", desc = "Telescope files" },
          { "<leader>j",  ":m .+1<CR>==",              desc = "Move line down" },
          { "<leader>k",  ":m .-2<CR>==",              desc = "Move line up" },
          { "<leader>l",  ":Telescope filetypes<CR>",  desc = "Programming language" },
          { "<leader>o",  ":Telescope oldfiles<CR>",   desc = "Old files" },
          { "<leader>p",  ":Telescope projects<CR>",   desc = "Telescope projects" },
          { "<leader>s",  ":ToggleTerm<CR>",           desc = "Toggle shell" },
          { "<leader>t",  ":NvimTreeToggle<CR>",       desc = "Nvim Tree" },
          { ";",          ":",                         desc = "Command mode",         silent = false },
          { "f ",         ";",                         desc = "Next found char" },

          { "<A-,>",      ":BufferPrevious<CR>",       desc = "Previous buffer" },
          { "<A-.>",      ":BufferNext<CR>",           desc = "Next buffer" },
          { "<A-c>",      ":BufferClose<CR>",          desc = "Close buffer" },
          { "<A-h>",      "<C-w>h",                    desc = "Window left" },
          { "<A-j>",      "<C-w>j",                    desc = "Window down" },
          { "<A-k>",      "<C-w>k",                    desc = "Window up" },
          { "<A-l>",      "<C-w>l",                    desc = "Window right" },
          { "<A-H>",      "<C-w>H",                    desc = "Move window left" },
          { "<A-J>",      "<C-w>J",                    desc = "Move window down" },
          { "<A-K>",      "<C-w>K",                    desc = "Move window up" },
          { "<A-L>",      "<C-w>L",                    desc = "Move window right" },
          { "<A-n>",      ":tabnew<CR>",               desc = "New tab" },
          { "<leader>.",  vim.lsp.buf.code_action,     desc = "Code action" },
          { "<leader>h",  vim.lsp.buf.hover,           desc = "Hover" },
          { "<leader>H",  vim.lsp.buf.signature_help,  desc = "Show signature help" },
          { "<leader>dc", vim.lsp.buf.declaration,     desc = "Go to declaration" },
          { "<leader>df", vim.lsp.buf.definition,      desc = "Go to definition" },
          { "<leader>di", vim.lsp.buf.implementation,  desc = "Go to implementation" },
          { "<leader>dr", vim.lsp.buf.references,      desc = "Show references" },
          { "<leader>dt", vim.lsp.buf.type_definition, desc = "Go to type definition" },
          {
            "<leader>i",
            function()
              vim.lsp.buf.format({
                filter = function(client)
                  -- Don't use formatters from LSPs where there is a formatter
                  -- in none-ls
                  return not vim.tbl_contains({ "lua_ls", "tsserver", "cssls", "html" }, client)
                end,
              })
            end,
            desc = "Format code",
          },
          { "<leader>r",  vim.lsp.buf.rename,               desc = "Rename identifier" },
          { "<leader>w",  group = "Workspace..." },
          { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
          {
            "<leader>wl",
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "List workspace folders",
          },
          { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
        },
        {
          {
            mode = "v",
            { "<leader>/", "gc",               desc = "Toggle comment", noremap = false },
            { "<leader>j", ":m '>+1<CR>gv=gv", desc = "Move lines down" },
            { "<leader>k", ":m '<-2<CR>gv=gv", desc = "Move lines up" },
          },
          {
            mode = "t",
            { "<Esc>", "<C-\\><C-n>", desc = "Escape terminal mode" },
          },
          {
            mode = "i",
            { "jj", "<Esc>", desc = "Escape insert mode" },
          },
        },
      },
    },
  },
}
