--leader (must be set before anything else)
vim.g.mapleader = " "
vim.g.python3_host_prog = "/usr/bin/python3"

--ui
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"

--tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

--search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

--files
vim.opt.swapfile = false
vim.opt.undofile = true

--performance
vim.opt.updatetime = 250

--clipboard (WSL)
local sys32 = "/mnt/c/Windows/System32"
local clip_exe = sys32 .. "/clip.exe"
local ps_exe = sys32 .. "/WindowsPowerShell/v1.0/powershell.exe"

if vim.fn.executable("win32yank.exe") == 1 then
  -- best option: Neovim detects win32yank by itself
  vim.opt.clipboard = "unnamedplus"
elseif vim.fn.executable(clip_exe) == 1 and vim.fn.executable(ps_exe) == 1 then
  local paste = ps_exe .. ' -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = { ["+"] = clip_exe, ["*"] = clip_exe },
    paste = { ["+"] = paste, ["*"] = paste },
    cache_enabled = 0,
  }
  -- not setting unnamedplus here: the powershell paste is slow, so use "+y / "+p explicitly
end

--persistent terminal
local term_buf = nil
local term_win = nil

local function open_term()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_set_current_win(term_win)
    return
  end
  vim.cmd("botright split | resize 15")
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end
  term_win = vim.api.nvim_get_current_win()
end

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])

vim.keymap.set("n", "<leader>i", function()
  vim.cmd("edit input.txt")
end)

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("write")

  local file = vim.fn.expand("%")
  local exe = vim.fn.expand("%:r")

  open_term()

  local cmd = string.format(
    "clear && g++ -std=c++20 -O2 -Wall -Wextra %s -o %s && echo '=== RUN ===' && ./%s",
    file, exe, exe)

  vim.fn.chansend(vim.b.terminal_job_id, cmd .. "\n")
end, { noremap = true, silent = true })

--plugins & config modules (order matters: cmp before lsp)
require("plugins.init")
require("config.ui")
require("config.telescope")
require("config.treesitter")
require("config.cmp")
require("config.lsp")
require("config.dap")
require("config.misc")
