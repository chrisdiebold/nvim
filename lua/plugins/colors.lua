return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            flavor = 'frappe', -- latte, frappe, macchiato, mocha
            --[[ background = {
                light = 'latte',
                dark = 'mocha',
            }, ]]
            transparent_background = false, -- disables setting the background color.
            integrations = {
                blink_cmp = {
                    style = 'bordered',
                },
            },
        },
    },
    {
        'rebelot/kanagawa.nvim',
        opts = {
            theme = 'wave', -- dragon, lotus, wave
            transparent = true,
            background = { -- map the value of 'background' option to a theme
                dark = 'wave', -- try "dragon" !
                light = 'lotus',
            },
        },
    },
}
