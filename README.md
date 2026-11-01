# nvim

My Neovim config. It is a small, from-scratch setup built on [lazy.nvim](https://github.com/folke/lazy.nvim)
and Neovim's built-in LSP client (`vim.lsp.config` / `vim.lsp.enable`).

## Requirements

- Neovim 0.11+
- `git`, a C compiler, and the [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) CLI (for parsers)
- [`fzf`](https://github.com/junegunn/fzf) and [`ripgrep`](https://github.com/BurntSushi/ripgrep) (for fzf-lua)
- `node`/`npm` (Mason installs several servers and tools through npm)
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)

## Install

```sh
git clone git@github.com:chrisdiebold/nvim.git ~/.config/nvim
nvim
```

The first launch bootstraps lazy.nvim and installs the plugins. Mason then installs the LSP servers, formatters,
and linters, and nvim-treesitter installs the parsers. Plugin versions are pinned in `lazy-lock.json`.

## Layout

```text
init.lua                 leader keys, then loads lua/config/*
lua/config/options.lua   editor options and diagnostic display
lua/config/keymaps.lua   general keymaps
lua/config/autocmds.lua  yank highlight, restore cursor position, equalize splits on resize
lua/config/lazy.lua      lazy.nvim bootstrap and setup
lua/plugins/             one file per area, auto-imported by lazy.nvim
```

## Plugins

| Area        | Plugins                                                                       |
| ----------- | ----------------------------------------------------------------------------- |
| Colorscheme | tokyonight (`night`)                                                          |
| Completion  | blink.cmp, friendly-snippets, lazydev                                         |
| LSP         | nvim-lspconfig, mason, mason-lspconfig, mason-tool-installer, SchemaStore     |
| Formatting  | conform.nvim (format on save)                                                 |
| Linting     | nvim-lint                                                                     |
| Syntax      | nvim-treesitter (`main` branch: highlighting, folds, indent)                  |
| Editor      | fzf-lua, oil.nvim, gitsigns, which-key, mini.nvim (icons, ai, surround, pairs, statusline) |

## Languages

| Language          | LSP                              | Formatter                              | Linter               |
| ----------------- | -------------------------------- | -------------------------------------- | -------------------- |
| Python            | basedpyright, ruff               | ruff                                   | ruff (LSP)           |
| JS / TS           | vtsls, eslint\*, biome\*         | biome\* or prettierd                   | eslint / biome (LSP) |
| Go                | gopls                            | goimports, gofumpt                     | gopls (staticcheck)  |
| Rust              | rust_analyzer                    | rustfmt                                | rust_analyzer        |
| C / C++           | clangd                           | clang-format                           | clang-tidy (clangd)  |
| Lua               | lua_ls                           | stylua                                 |                      |
| JSON / YAML       | jsonls, yamlls (SchemaStore)     | biome\* or prettierd / prettierd       |                      |
| TOML              | taplo                            | taplo (LSP)                            |                      |
| Markdown          | marksman                         |                                        | markdownlint-cli2    |
| Docker            | dockerls, docker_compose_language_service |                               | hadolint             |
| SQL               |                                  | sqlfluff\*                             |                      |
| HTML / CSS        |                                  | prettierd                              |                      |

\* Only runs when the project has the tool's config file (`biome.json`, an eslint config, `.sqlfluff`).

To add a server, add its lspconfig name to `servers` in `lua/plugins/lsp.lua`. Server settings go in
`configure_servers()` in the same file.

## Keymaps

Leader is `<Space>`, local leader is `\`. Press `<leader>` and wait for which-key to list everything.

### General

| Key                 | Action                         |
| ------------------- | ------------------------------ |
| `<C-h/j/k/l>`       | Move between windows           |
| `<S-h>` / `<S-l>`   | Previous / next buffer         |
| `<leader>bd`        | Delete buffer                  |
| `<Esc>`             | Clear search highlight         |
| `<Esc><Esc>`        | Leave terminal mode            |
| `-`                 | Open parent directory (oil)    |

### Search (fzf-lua)

| Key                 | Action                         |
| ------------------- | ------------------------------ |
| `<leader><space>`   | Find files                     |
| `<leader>/`         | Live grep                      |
| `<leader>,`         | Buffers                        |
| `<leader>fr`        | Recent files                   |
| `<leader>fc`        | Files in this config           |
| `<leader>sw`        | Grep word under cursor         |
| `<leader>sh`        | Help tags                      |
| `<leader>sk`        | Keymaps                        |
| `<leader>sd` / `sD` | Document / workspace diagnostics |
| `<leader>ss` / `sS` | Document / workspace symbols   |
| `<leader>sr`        | Resume last search             |

### LSP and code

Neovim's built-in LSP maps also apply: `K`, `grn`, `gra`, `grr`, `gri`, `grt`, `gO`, and `<C-s>`.

| Key                 | Action                         |
| ------------------- | ------------------------------ |
| `gd` / `gD`         | Go to definition / declaration |
| `<leader>ch`        | Toggle inlay hints             |
| `<leader>cd`        | Line diagnostics               |
| `<leader>xq`        | Diagnostics to quickfix        |
| `<leader>cf`        | Format buffer or selection     |
| `<leader>uf`        | Toggle format on save          |

### Git (gitsigns)

| Key                 | Action                         |
| ------------------- | ------------------------------ |
| `]h` / `[h`         | Next / previous hunk           |
| `<leader>ghs`       | Stage hunk                     |
| `<leader>ghr`       | Reset hunk                     |
| `<leader>ghp`       | Preview hunk inline            |
| `<leader>ghb`       | Blame line                     |

### Completion (blink.cmp)

`<CR>` accepts, `<C-n>` / `<C-p>` move through items, `<C-space>` opens the menu, `<C-e>` closes it, and
`<Tab>` / `<S-Tab>` jump between snippet placeholders.

### Editing (mini.nvim)

- `sa` / `sd` / `sr` add, delete, or replace surroundings
- Extra text objects come from mini.ai, such as `af`/`if` (function), `aa`/`ia` (argument), and `aq`/`iq` (quote)

## Formatting this config

Lua files are formatted with stylua (`stylua.toml`: 2 spaces, 120 columns).
