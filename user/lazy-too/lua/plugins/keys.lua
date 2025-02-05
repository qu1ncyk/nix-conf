---The keybind for pressing `I` or `A` in visual line mode. This function makes
---the behavior the similar to normal mode, but on multiple lines.
---@param key "I" | "A"
local function v_line_IA(key)
  local v_block_insert
  if key == "I" then
    v_block_insert = vim.api.nvim_replace_termcodes("<C-V>0I", true, false, true)
  else
    v_block_insert = vim.api.nvim_replace_termcodes("<C-V>$A", true, false, true)
  end

  return function()
    -- Only in visual line mode
    if vim.fn.mode() == "V" then
      vim.api.nvim_feedkeys(v_block_insert, "n", false)
      -- Make `gv` enter visual line mode instead of visual block
      vim.api.nvim_create_autocmd("InsertLeave", {
        once = true,
        callback = function()
          local gv_v_line = vim.api.nvim_replace_termcodes("ugvV<Esc><C-R>gvV<Esc>", true, false, true)
          vim.api.nvim_feedkeys(gv_v_line, "n", false)
        end,
      })
    else
      vim.api.nvim_feedkeys(key, "n", false)
    end
  end
end

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
          { "<leader>/", "gcc", desc = "Comment toggle", noremap = false },
          { "<leader>b", ":Telescope buffers<CR>", desc = "Telescope buffers" },
          { "<leader>d", group = "Diagnostics..." },
          { "<leader>dd", vim.diagnostic.open_float, desc = "Diagnostics" },
          { "<leader>dj", vim.diagnostic.goto_prev, desc = "Next diagnostic" },
          { "<leader>dk", vim.diagnostic.goto_next, desc = "Previous diagnostic" },
          { "<leader>f", ":Telescope find_files<CR>", desc = "Telescope files" },
          { "<leader>m", ":Lf<CR>", desc = "Manage files (lf)" },
          { "<leader>j", ":m .+1<CR>==", desc = "Move line down" },
          { "<leader>k", ":m .-2<CR>==", desc = "Move line up" },
          { "<leader>l", ":Telescope filetypes<CR>", desc = "Programming language" },
          { "<leader>o", ":Telescope oldfiles<CR>", desc = "Old files" },
          { "<leader>p", ":Telescope projects<CR>", desc = "Telescope projects" },
          {
            "<leader>s",
            function()
              require("toggleterm").toggle(vim.v.count)
            end,
            desc = "Toggle shell",
          },
          { "<leader>S", ":ToggleTermToggleAll<CR>", desc = "Toggle all shells" },
          { "<leader>t", ":NvimTreeToggle<CR>", desc = "Nvim Tree" },
          { ";", ":", desc = "Command mode", silent = false },
          { "f ", ";", desc = "Next found char" },

          { "<A-,>", ":BufferPrevious<CR>", desc = "Previous buffer" },
          { "<A-.>", ":BufferNext<CR>", desc = "Next buffer" },
          { "<A-c>", ":BufferClose<CR>", desc = "Close buffer" },
          { "<A-h>", "<C-w>h", desc = "Window left" },
          { "<A-j>", "<C-w>j", desc = "Window down" },
          { "<A-k>", "<C-w>k", desc = "Window up" },
          { "<A-l>", "<C-w>l", desc = "Window right" },
          { "<A-H>", "<C-w>H", desc = "Move window left" },
          { "<A-J>", "<C-w>J", desc = "Move window down" },
          { "<A-K>", "<C-w>K", desc = "Move window up" },
          { "<A-L>", "<C-w>L", desc = "Move window right" },
          { "<A-n>", ":tabnew<CR>", desc = "New tab" },
          { "<leader>.", vim.lsp.buf.code_action, desc = "Code action" },
          { "<leader>h", vim.lsp.buf.hover, desc = "Hover" },
          { "<leader>H", vim.lsp.buf.signature_help, desc = "Show signature help" },
          { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle DAP breakpoint" },
          { "<leader>dc", vim.lsp.buf.declaration, desc = "Go to declaration" },
          { "<leader>df", vim.lsp.buf.definition, desc = "Go to definition" },
          { "<leader>di", vim.lsp.buf.implementation, desc = "Go to implementation" },
          { "<leader>dr", vim.lsp.buf.references, desc = "Show references" },
          { "<leader>dt", vim.lsp.buf.type_definition, desc = "Go to type definition" },
          {
            "<leader>i",
            function()
              vim.lsp.buf.format({
                filter = function(client)
                  -- Don't use formatters from LSPs where there is a formatter
                  -- in none-ls
                  return not vim.tbl_contains({ "lua_ls", "tsserver", "cssls", "html" }, client.name)
                end,
              })
            end,
            desc = "Format code",
          },
          { "<leader>r", vim.lsp.buf.rename, desc = "Rename identifier" },
          { "<leader>w", group = "Workspace..." },
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
            { "<leader>/", "gc", desc = "Toggle comment", noremap = false },
            { "<leader>j", ":m '>+1<CR>gv=gv", desc = "Move lines down" },
            { "<leader>k", ":m '<-2<CR>gv=gv", desc = "Move lines up" },
          },
          {
            mode = "v",
            { "I", v_line_IA("I"), desc = "Prepend" },
            { "A", v_line_IA("A"), desc = "Append" },
          },
          {
            mode = "t",
            { "<Esc>", "<C-\\><C-n>", desc = "Escape terminal mode" },
          },
          {
            mode = {"i", "s"},
            { "jj", "<Esc>", desc = "Escape insert mode" },
          },
          {
            mode = { "n", "v" },
            {
              "j",
              function()
                if vim.v.count == 0 then
                  vim.api.nvim_feedkeys("gj", "n", false)
                else
                  vim.api.nvim_feedkeys(vim.v.count .. "j", "n", false)
                end
              end,
            },
            {
              "k",
              function()
                if vim.v.count == 0 then
                  vim.api.nvim_feedkeys("gk", "n", false)
                else
                  vim.api.nvim_feedkeys(vim.v.count .. "k", "n", false)
                end
              end,
            },
          },
          {
            mode = { "v", "o" },
            {
              "iq",
              function()
                local current_line = vim.fn.line(".")
                local quote_pos = vim.fn.searchpos([['\|"\|`]], "cnWz", current_line)
                if quote_pos[1] == 0 then
                  return
                end
                local quote = vim.fn.getline("."):sub(quote_pos[2], quote_pos[2])
                vim.api.nvim_feedkeys("i" .. quote, "n", false)
              end,
              desc = "inner quote",
            },
            {
              "aq",
              function()
                local current_line = vim.fn.line(".")
                local quote_pos = vim.fn.searchpos([['\|"\|`]], "cnWz", current_line)
                if quote_pos[1] == 0 then
                  return
                end
                local quote = vim.fn.getline("."):sub(quote_pos[2], quote_pos[2])
                vim.api.nvim_feedkeys("a" .. quote, "n", false)
              end,
              desc = "quote",
            },
          },
        },
        {
          "<S-CR>",
          function()
            local luasnip = require("luasnip")
            if luasnip.jumpable() then
              luasnip.jump(1)
            end
          end,
          desc = "Jump to next LuaSnip input",
          mode = { "n", "i", "s" },
        },
      },
    },
  },
}
