vim.cmd.colorscheme("tokyonight")

require("nvim-web-devicons").setup()

require("nvim-tree").setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = { enable = true },
  renderer = {
    highlight_git = true,
    indent_markers = { enable = true },
  },
})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

require("lualine").setup()
require("bufferline").setup()
