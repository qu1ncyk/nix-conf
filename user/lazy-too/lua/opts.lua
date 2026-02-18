local opt = vim.opt

-- [[ Context ]]
opt.colorcolumn = "80" -- str:  Show col for max line length
opt.number = true -- bool: Show line numbers
opt.relativenumber = true -- bool: Show relative line numbers
opt.scrolloff = 4 -- int:  Min num lines of context
opt.signcolumn = "yes" -- str:  Show the sign column

-- [[ Filetypes ]]
opt.encoding = "utf8" -- str:  String encoding to use
opt.fileencoding = "utf8" -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable

-- [[ Search ]]
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = true -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- num:  Size of an indent
opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

opt.cursorline = true
opt.list = true

vim.api.nvim_create_autocmd({ "OptionSet", "BufEnter" }, {
  callback = function(ev)
    if ev.event == "OptionSet" and ev.match ~= "shiftwidth" then
      return
    end

    local spaces = (" "):rep(vim.bo[ev.buf].shiftwidth - 1)
    local listchars = "multispace:" .. spaces .. "┊,trail:~,tab:>-"
    if listchars ~= opt.listchars then
      opt.listchars = listchars
    end
  end,
})

opt.foldmethod = "indent"
opt.foldlevel = 99
vim.g.markdown_folding = true

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

vim.filetype.add({
  pattern = {
    ['.*/.*%.rsc'] = 'rascal',
  },
})
