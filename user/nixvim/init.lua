-- https://mattermost.com/blog/how-to-install-and-set-up-neovim-for-code-editing/

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = " "
vim.g.localleader = "\\"

-- IMPORTS
require("vars") -- Variables
require("opts") -- Options
require("plug") -- Plugins

-- PLUGINS: Add this section
