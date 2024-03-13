require('nvim-tree').setup {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true
    }
}

local vscode = require 'vscode'
vscode.setup {
    color_overrides = {
        vscBack = '#000000',
        vscFront = '#E0E0E0',

        vscLineNumber = '#777777',

        vscYellow = '#F9DB95',
        vscPink = '#CD98C9',
        vscBlue = '#6FABDC',
        vscOrange = '#D49D87',
        vscGreen = '#1EAE50',
        vscLightGreen = '#3BDE74',
        vscRed = '#F66060'
    }
}
vscode.load('dark')

local function spaces()
    return ' ' .. vim.o.shiftwidth
end
require('lualine').setup {
    sections = {
        lualine_x = {
            spaces, 'encoding', 'fileformat', 'filetype'
        }
    },
    options = {
        theme = 'vscode'
    },
    extensions = { 'nvim-tree', 'toggleterm' }
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local null_ls = require 'null-ls'
local helpers = require 'null-ls.helpers'

local autopep8 = {
    name = "autopep8",
    filetypes = { "python" },
    method = { null_ls.methods.FORMATTING },
    generator = helpers.formatter_factory {
        command = "autopep8",
        args = { "-" },
        to_stdin = true
    }
}

local flake8 = {
    name = "flake8",
    filetypes = { "python" },
    method = { null_ls.methods.DIAGNOSTICS },
    generator = helpers.generator_factory {
        command = "flake8",
        args = { "-" },
        to_stdin = true,
        from_stderr = true,
        format = "line",
        on_output = helpers.diagnostics.from_pattern(
            ":(%d+):(%d+): ((%u)%w+) (.*)",
            { "row", "col", "code", "severity", "message" },
            {
                severities = {
                    E = helpers.diagnostics.severities["error"],
                    W = helpers.diagnostics.severities["warning"],
                    F = helpers.diagnostics.severities["information"],
                    D = helpers.diagnostics.severities["information"],
                    R = helpers.diagnostics.severities["warning"],
                    S = helpers.diagnostics.severities["warning"],
                    I = helpers.diagnostics.severities["warning"],
                    C = helpers.diagnostics.severities["warning"],
                    B = helpers.diagnostics.severities["warning"],     -- flake8-bugbear
                    N = helpers.diagnostics.severities["information"], -- pep8-naming
                }
            }
        )
    },
}

null_ls.setup {
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    sources = {
        null_ls.builtins.formatting.prettier,
        autopep8,
        flake8
    }
}

local telescope = require 'telescope'
telescope.setup {}
telescope.load_extension('projects')

require('nvim_comment').setup {
    hook = function()
        require('ts_context_commentstring.internal').update_commentstring()
    end
}

vim.o.timeout = true
vim.o.timeoutlen = 300
require('keys') -- Keymaps

require('guess-indent').setup {}
