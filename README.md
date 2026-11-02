# nvim

My Neovim config. It is a small, from-scratch setup built on [lazy.nvim](https://github.com/folke/lazy.nvim)
and Neovim's built-in LSP client (`vim.lsp.config` / `vim.lsp.enable`).

## Requirements

- Neovim 0.11+
- `git`, a C compiler, and the [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) CLI (for parsers)
- [`fzf`](https://github.com/junegunn/fzf) and [`ripgrep`](https://github.com/BurntSushi/ripgrep) (for fzf-lua)
- `curl`, `unzip`, `tar`, and `gzip` (Mason downloads and unpacks packages with these)
- `node`/`npm` (Mason installs basedpyright, vtsls, eslint, prettierd, markdownlint-cli2, and others through npm)
- `python3` with `venv` (Mason installs sqlfluff through pip)
- `go` (Mason builds gopls, gofumpt, and goimports with `go install`)
- `rustup` (provides `rustfmt`; Mason does not install it)
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)

Everything else (LSP servers, formatters, linters) is installed by Mason on first launch.

### macOS

Install the Xcode command line tools (C compiler, `git`) and [Homebrew](https://brew.sh), then:

```sh
xcode-select --install
brew install neovim git tree-sitter-cli fzf ripgrep node python

# Go (official installer from go.dev; installs to /usr/local/go and adds it to PATH)
GO_VERSION=$(curl -s 'https://go.dev/VERSION?m=text' | head -n1)
GO_ARCH=$([ "$(uname -m)" = arm64 ] && echo arm64 || echo amd64)
curl -LO "https://go.dev/dl/${GO_VERSION}.darwin-${GO_ARCH}.pkg"
sudo installer -pkg "${GO_VERSION}.darwin-${GO_ARCH}.pkg" -target /
echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.zshrc

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y   # Rust, includes rustfmt
brew install --cask font-jetbrains-mono-nerd-font   # optional
```

### Ubuntu

The `neovim` package in apt is too old, so install a current release from the
[Neovim releases page](https://github.com/neovim/neovim/releases) (or the `neovim-ppa/unstable` PPA). The apt
versions of `node` and `go` are also old, so install those from upstream.

```sh
sudo apt update
sudo apt install -y build-essential git curl unzip tar gzip fzf ripgrep python3 python3-venv python3-pip

# Neovim (official release tarball)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >> ~/.bashrc

# Node via nvm, then the tree-sitter CLI
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install --lts
npm install -g tree-sitter-cli

# Go (official tarball from go.dev)
GO_VERSION=$(curl -s 'https://go.dev/VERSION?m=text' | head -n1)
curl -LO "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "${GO_VERSION}.linux-amd64.tar.gz"
echo 'export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"' >> ~/.bashrc

# Rust (includes rustfmt)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
```

On ARM machines, use `nvim-linux-arm64.tar.gz` and `linux-arm64` for Go instead. For icons, download a Nerd Font from
[nerdfonts.com](https://www.nerdfonts.com/font-downloads), unzip it into `~/.local/share/fonts`, and run `fc-cache -f`.
Ubuntu 22.04 ships an old `fzf`; if fzf-lua complains, install the latest from the
[fzf releases page](https://github.com/junegunn/fzf/releases).

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
