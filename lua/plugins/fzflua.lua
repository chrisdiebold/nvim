local icons = require 'icons'

return {
    {
        'ibhagwan/fzf-lua',
        command = 'FzfLua',
        dependencies = { 'echasnovski/mini.icons' },
        keys = {
            { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files in project directory' },
            {
                '<leader>fg',
                function()
                    require('fzf-lua').live_grep()
                end,
                desc = 'Find by grepping in project directory',
            },
            {
                '<leader>fc',
                function()
                    require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
                end,
                desc = 'Find in neovim configuration',
            },
            { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = '[F]ind [H]elp' },
            { '<leader>fk', '<cmd>FzfLua keymaps<cr>', desc = '[F]ind [K]eymaps' },
            { '<leader>fb', '<cmd>FzfLua builtin<cr>', desc = '[F]ind [B]uiltin FZF' },
            { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document diagnostics' },
            { '<leader>fD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace diagnostics' },
            { '<leader><leader>', '<cmd>FzfLua buffers<cr>', desc = '[F]ind [B]uffers' },
        },
        opts = function()
            local actions = require 'fzf-lua.actions'
            return {
                fzf_opts = {
                    ['--info'] = 'default',
                    ['--layout'] = 'reverse-list',
                },
                keymap = {
                    builtin = {
                        ['<C-/>'] = 'toggle-help',
                        ['<C-a>'] = 'toggle-fullscreen',
                        ['<C-i>'] = 'toggle-preview',
                        ['<C-f>'] = 'preview-page-down',
                        ['<C-b>'] = 'preview-page-up',
                    },
                    fzf = {
                        ['alt-s'] = 'toggle',
                        ['alt-a'] = 'toggle-all',
                        ['ctrl-i'] = 'toggle-preview',
                    },
                },
                winopts = {
                    height = 0.7,
                    width = 0.55,
                    preview = {
                        scrollbar = false,
                        layout = 'vertical',
                        vertical = 'up:40%',
                    },
                },
                defaults = { git_icons = false },
                previewers = {
                    codeaction = { toggle_behavior = 'extend' },
                },
                -- Configuration for specific commands.
                files = {
                    winopts = {
                        preview = { hidden = true },
                    },
                },
                grep = {
                    header_prefix = icons.misc.search .. ' ',
                    rg_glob_fn = function(query, opts)
                        local regex, flags = query:match(string.format('^(.*)%s(.*)$', opts.glob_separator))
                        -- Return the original query if there's no separator.
                        return (regex or query), flags
                    end,
                },
                helptags = {
                    actions = {
                        -- Open help pages in a vertical split.
                        ['enter'] = actions.help_vert,
                    },
                },
                lsp = {
                    symbols = {
                        symbol_icons = icons.symbol_kinds,
                    },
                    code_actions = {
                        winopts = {
                            width = 70,
                            height = 20,
                            relative = 'cursor',
                            preview = {
                                hidden = true,
                                vertical = 'down:50%',
                            },
                        },
                    },
                },
                oldfiles = {
                    include_current_session = true,
                    winopts = {
                        preview = { hidden = true },
                    },
                },
            }
        end,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(items, opts, on_choice)
                local ui_select = require 'fzf-lua.providers.ui_select'

                -- Register the fzf-lua picker the first time we call select.
                if not ui_select.is_registered() then
                    ui_select.register(function(ui_opts)
                        if ui_opts.kind == 'luasnip' then
                            ui_opts.prompt = 'Snippet choice: '
                            ui_opts.winopts = {
                                relative = 'cursor',
                                height = 0.35,
                                width = 0.3,
                            }
                        elseif ui_opts.kind == 'lsp_message' then
                            ui_opts.winopts = { height = 0.4, width = 0.4 }
                        else
                            ui_opts.winopts = { height = 0.6, width = 0.5 }
                        end

                        return ui_opts
                    end)
                end

                -- Don't show the picker if there's nothing to pick.
                if #items > 0 then
                    return vim.ui.select(items, opts, on_choice)
                end
            end
        end,
    },
}
