-- run :TSUpdate after treesitter installs/updates (must be before vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == "nvim-treesitter" and (d.kind == "install" or d.kind == "update") then
      if not d.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  -- colorscheme
  { src = "https://github.com/folke/tokyonight.nvim" },

  -- icons (must be here for nvim-tree / lualine / telescope / bufferline)
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  -- ui
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },

  -- telescope
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },

  -- treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

  -- completion (replaces nvim-cmp + cmp-* + LuaSnip)
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/saghen/blink.lib" },

  -- git
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- debugger
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },

  -- commenting
  { src = "https://github.com/numToStr/Comment.nvim" },
})
