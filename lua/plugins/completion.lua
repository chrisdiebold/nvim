return { -- Autocompletion
    'saghen/blink.cmp',

    dependencies = {
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        'folke/lazydev.nvim',
    },
    build = 'cargo +nightly build --release',
    event = 'InsertEnter',
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        keymap = {
            ['<CR>'] = { 'accept', 'fallback' },
            ['<C-\\>'] = { 'hide', 'fallback' },
            ['<C-n>'] = { 'select_next', 'show' },
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
            ['<C-p>'] = { 'select_prev' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
        },

        completion = {
            list = {
                -- Insert items whild navigating the completion list
                selection = { preselect = false, auto_insert = true },
                max_items = 10,
            },
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = false },
            menu = {
                scrollbar = false,
                draw = {
                    gap = 2,
                    columns = {
                        { 'kind_icon', 'kind', gap = 1 },
                        { 'label', 'label_description', gap = 1 },
                    },
                },
            },
        },
        snippets = { preset = 'luasnip' },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
            providers = {
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
        },
        signature = {
            window = {
                border = 'single',
            },
        },

        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- By default, we use the Lua implementation instead, but you may enable
        -- the rust implementation via `'prefer_rust_with_warning'`
        --
        fuzzy = { implementation = 'prefer_rust_with_warning' },

        -- See :h blink-cmp-config-fuzzy for more information
    },
    opts_extend = { 'sources.default' },
}
