local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.winborder = "rounded"
opt.showmode = false -- shown in statusline

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.swapfile = false
opt.confirm = true
opt.updatetime = 250
opt.timeoutlen = 300

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.completeopt = { "menu", "menuone", "noselect" }

-- Deferred: the clipboard provider can be slow to start on macOS
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { source = "if_many" },
  underline = true,
  update_in_insert = false,
})
