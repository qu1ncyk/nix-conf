-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true
            }
        },
        cmd = 'NvimTreeToggle'
    },
    {
        'Mofiqul/vscode.nvim',
        opts = {
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
        },
        config = function(_, opts)
            local vscode = require 'vscode'
            vscode.setup(opts)
            vscode.load('dark')
        end
    },
    { 'folke/neodev.nvim',     opts = {} },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason').setup {
                PATH = 'append'
            }
            local mlsp = require 'mason-lspconfig'
            mlsp.setup()
            mlsp.setup_handlers {
                function(server)
                    local lsp = require 'lspconfig'
                    local capabilities = require('cmp_nvim_lsp').default_capabilities()
                    local config = {
                        capabilities = capabilities,
                        on_attach = require('keys').set_lsp_keys,
                    }
                    if server == 'clangd' then
                        config.cmd = {
                            'clangd',
                            '--header-insertion=never',
                        }
                    end
                    if server == 'unocss' then
                        config.filetypes = { 'html', 'javascriptreact',
                            'rescript', 'typescriptreact', 'vue', 'svelte', 'astro' }
                    end
                    if server == 'nil_ls' then
                        config.settings = {
                            ["nil"] = {
                                nix = {
                                    flake = {
                                        autoArchive = true
                                    }
                                }
                            }
                        }
                    end

                    lsp[server].setup(config)
                end
            }
        end,
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'folke/which-key.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'folke/neodev.nvim'
        }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'Mofiqul/vscode.nvim', 'nvim-tree/nvim-web-devicons' },
        config = function()
            local lualine = require 'lualine'
            local function spaces()
                return ' ' .. vim.o.shiftwidth
            end
            lualine.setup {
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
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
        event = 'InsertEnter',
        config = function()
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
        end
    },
    { 'windwp/nvim-autopairs', config = true, event = 'InsertEnter' },
    {
        'nvimtools/none-ls.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
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
                    -- null_ls.builtins.formatting.rustfmt,
                    -- null_ls.builtins.formatting.black,
                    -- null_ls.builtins.formatting.autopep8,
                    -- null_ls.builtins.diagnostics.flake8,
                    autopep8,
                    flake8
                }
            }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = { 'ahmedkhalf/project.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require 'telescope'
            telescope.setup {}
            telescope.load_extension('projects')
        end
    },
    {
        'ahmedkhalf/project.nvim',
        main = 'project_nvim',
        config = true,
        event = 'VeryLazy'
    },
    {
        'terrortylor/nvim-comment',
        dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
        cmd = 'CommentToggle',
        config = function()
            require('nvim_comment').setup {
                hook = function()
                    require('ts_context_commentstring.internal').update_commentstring()
                end
            }
        end
    },
    {
        'romgrk/barbar.nvim',
        config = true,
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    { 'akinsho/toggleterm.nvim',         config = true, cmd = 'ToggleTerm' },
    {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('keys') -- Keymaps
        end
    },
    { 'nmac427/guess-indent.nvim',       config = true },
    { 'prichrd/netrw.nvim',              config = true, event = 'VeryLazy' },
    { 'nvim-treesitter/nvim-treesitter', config = true, event = 'VeryLazy' },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
            highlight = {
                enable = true
            },
            context_commentstring = {
                enable = true,
            }
        }
    },
    { 'lewis6991/gitsigns.nvim', config = true },
    -- { 'mfussenegger/nvim-dap', config = true },
    -- { 'rcarriga/nvim-dap-ui',    dependencies = 'mfussenegger/nvim-dap' },
    -- { 'mfussenegger/nvim-dap-python', dependencies = 'mfussenegger/nvim-dap' },
}
