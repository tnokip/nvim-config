require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("clangd", {
  cmd = {
    "clangd", "--background-index", "--clang-tidy",
    "--header-insertion=never",
    "--query-driver=/usr/bin/g++,/usr/bin/gcc",
  },
  capabilities = capabilities,
})
vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local o = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, o)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
    vim.keymap.set("n", "K",  vim.lsp.buf.hover, o)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, o)
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, o)
    vim.keymap.set("n", "<leader>lh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, o)
  end,
})

-- diagnostics: no inline text, rounded float on hover
vim.diagnostic.config({ signs = true, underline = true, virtual_text = false, update_in_insert = false })
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false, border = "rounded", source = "always",
      close_events = { "BufLeave", "InsertEnter", "CursorMoved" },
    })
  end,
})
