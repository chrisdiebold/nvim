return {
  "saghen/blink.cmp",
  version = "1.*", -- release tags ship a prebuilt fuzzy-matcher binary
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    -- <CR> accept, <C-n>/<C-p> navigate, <C-space> open, <C-e> close, <Tab>/<S-Tab> jump in snippets
    keymap = { preset = "enter" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    signature = { enabled = true },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
  },
}
