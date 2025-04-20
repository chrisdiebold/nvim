return { -- Autocompletion
  "saghen/blink.cmp",
  event = "InsertEnter",
  build = "cargo +nightly build --release",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "folke/lazydev.nvim",
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      -- preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-\\>"] = { "hide", "fallback" },
      ["<C-n>"] = { "select_next", "show" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<C-p>"] = { "select_prev" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      kind_icons = require("icons").symbol_kinds,
      nerd_font_variant = "mono",
    },

    completion = {
      list = {
        -- Insert items whild navigating the completion list
        selection = { preselect = false, auto_insert = true },
        max_items = 10,
      },
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      -- menu = {
      --   draw = {
      --     components = {
      --       kind_icon = {
      --         text = function(ctx)
      --           local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
      --           return kind_icon
      --         end,
      --         -- (optional) use highlights from mini.icons
      --         highlight = function(ctx)
      --           local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
      --           return hl
      --         end,
      --       },
      --       kind = {
      --         -- (optional) use highlights from mini.icons
      --         highlight = function(ctx)
      --           local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
      --           return hl
      --         end,
      --       },
      --     },
      --   },
      -- },
    },
    snippets = { preset = "luasnip" },

    sources = {
      -- Disable some sources in comments and strings.
      default = function()
        local sources = { "lsp", "buffer" }
        local ok, node = pcall(vim.treesitter.get_node)

        if ok and node then
          if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            table.insert(sources, "path")
          end
          if node:type() ~= "string" then
            table.insert(sources, "snippets")
          end
        end

        return sources
      end,
      -- default = { "lsp", "path", "snippets", "lazydev" },
      providers = {
        lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },

    signature = { enabled = true },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- See :h blink-cmp-config-fuzzy for more information
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    -- extend neovim's client capabilities iwth the completion ones
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
  end,
  -- opts_extend = { "sources.default" },
}
