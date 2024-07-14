local M = {}

local wk = require("which-key")
wk.setup({})

wk.add({
  { "<leader>/",  "gcc",                       desc = "Comment toggle",      noremap = false },
  { "<leader>b",  ":Telescope buffers<CR>",    desc = "Telescope buffers" },
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
})

wk.add({
  {
    mode = { "v" },
    { "<leader>/", "gc",               desc = "Toggle comment", noremap = false },
    { "<leader>j", ":m '>+1<CR>gv=gv", desc = "Move lines down" },
    { "<leader>k", ":m '<-2<CR>gv=gv", desc = "Move lines up" },
  },
})

wk.add({
  { ";",     ":",                   desc = "Execute command", silent = false },
  { "<A-,>", ":BufferPrevious<CR>", desc = "Previous buffer" },
  { "<A-.>", ":BufferNext<CR>",     desc = "Next buffer" },
  { "<A-c>", ":BufferClose<CR>",    desc = "Close buffer" },
  { "<A-h>", "<C-w>h",              desc = "Window left" },
  { "<A-j>", "<C-w>j",              desc = "Window down" },
  { "<A-k>", "<C-w>k",              desc = "Window up" },
  { "<A-l>", "<C-w>l",              desc = "Window right" },
  { "<A-n>", ":tabnew<CR>",         desc = "New tab" },
  { "f ",    ";",                   desc = "Next found char" },
})

wk.add({
  { "<Esc>", "<C-\\><C-n>", desc = "Escape terminal mode", mode = "t" },
})

wk.add({
  { "jj", "<Esc>", desc = "Escape insert mode", mode = "i" },
})

M.set_lsp_keys = function(client, bufnr)
  wk.add({
    { "<leader>.",  vim.lsp.buf.code_action,     buffer = bufnr, desc = "Code action" },
    { "<leader>H",  vim.lsp.buf.signature_help,  buffer = bufnr, desc = "Show signature help" },
    { "<leader>dc", vim.lsp.buf.declaration,     buffer = bufnr, desc = "Go to declaration" },
    { "<leader>df", vim.lsp.buf.definition,      buffer = bufnr, desc = "Go to definition" },
    { "<leader>di", vim.lsp.buf.implementation,  buffer = bufnr, desc = "Go to implementation" },
    { "<leader>dr", vim.lsp.buf.references,      buffer = bufnr, desc = "Show references" },
    { "<leader>dt", vim.lsp.buf.type_definition, buffer = bufnr, desc = "Go to type definition" },
    { "<leader>h",  vim.lsp.buf.hover,           buffer = bufnr, desc = "Hover" },
    {
      "<leader>i",
      function()
        vim.lsp.buf.format({ async = true })
      end,
      buffer = bufnr,
      desc = "Format code",
    },
    { "<leader>r",  vim.lsp.buf.rename,               buffer = bufnr, desc = "Rename identifier" },
    { "<leader>wa", vim.lsp.buf.add_workspace_folder, buffer = bufnr, desc = "Add workspace folder" },
    {
      "<leader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      buffer = bufnr,
      desc = "List workspace folders",
    },
    { "<leader>wr", vim.lsp.buf.remove_workspace_folder, buffer = bufnr, desc = "Remove workspace folder" },
  })
end

return M
