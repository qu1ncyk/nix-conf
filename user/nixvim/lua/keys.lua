local M = {}

local wk = require("which-key")
wk.setup({})

wk.register({
  t = { ":NvimTreeToggle<CR>", "Nvim Tree" },
  f = { ":Telescope find_files<CR>", "Telescope files" },
  b = { ":Telescope buffers<CR>", "Telescope buffers" },
  -- https://vim.fandom.com/wiki/Moving_lines_up_or_down
  j = { ":m .+1<CR>==", "Move line down" },
  k = { ":m .-2<CR>==", "Move line up" },
  ["/"] = { ":CommentToggle<CR>", "Comment toggle" },
  d = {
    d = { vim.diagnostic.open_float, "Diagnostics" },
    k = { vim.diagnostic.goto_prev, "Previous diagnostic" },
    j = { vim.diagnostic.goto_next, "Next diagnostic" },
  },
  s = { ":ToggleTerm<CR>", "Toggle shell" },
  o = { ":Telescope oldfiles<CR>", "Old files" },
  p = { ":Telescope projects<CR>", "Telescope projects" },
  l = { ":Telescope filetypes<CR>", "Programming language" },
}, { prefix = "<leader>" })

wk.register({
  ["/"] = { ":CommentToggle<CR>", "Toggle comment" },
  j = { ":m '>+1<CR>gv=gv", "Move lines down" },
  k = { ":m '<-2<CR>gv=gv", "Move lines up" },
}, { prefix = "<leader>", mode = "v" })

wk.register({
  [";"] = { ":", "Execute command", silent = false },
  ["<A-h>"] = { "<C-w>h", "Window left" },
  ["<A-j>"] = { "<C-w>j", "Window down" },
  ["<A-k>"] = { "<C-w>k", "Window up" },
  ["<A-l>"] = { "<C-w>l", "Window right" },
  ["<A-,>"] = { ":BufferPrevious<CR>", "Previous buffer" },
  ["<A-.>"] = { ":BufferNext<CR>", "Next buffer" },
  ["<A-c>"] = { ":BufferClose<CR>", "Close buffer" },
  ["<A-n>"] = { ":tabnew<CR>", "New tab" },
  ["f "] = { ";", "Next found char" },
})

wk.register({
  ["<Esc>"] = { "<C-\\><C-n>", "Escape terminal mode" },
}, { mode = "t" })

wk.register({
  ["jj"] = { "<Esc>", "Escape insert mode" },
}, { mode = "i" })

M.set_lsp_keys = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  wk.register({
    h = { vim.lsp.buf.hover, "Hover" },
    H = { vim.lsp.buf.signature_help, "Show signature help" },
    d = {
      c = { vim.lsp.buf.declaration, "Go to declaration" },
      f = { vim.lsp.buf.definition, "Go to definition" },
      i = { vim.lsp.buf.implementation, "Go to implementation" },
      t = { vim.lsp.buf.type_definition, "Go to type definition" },
      r = { vim.lsp.buf.references, "Show references" },
    },
    w = {
      a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
      r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
      l = {
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        "List workspace folders",
      },
    },
    i = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "Format code",
    },
    ["."] = { vim.lsp.buf.code_action, "Code action" },
    r = { vim.lsp.buf.rename, "Rename identifier" },
  }, { buffer = bufnr, prefix = "<leader>" })
end

return M
